#!/bin/bash

# ram-guard-cron.sh
# Prevents OOM crashes on macOS by killing ollama processes when free RAM < 15%

LOG_DIR="$HOME/.config/opencode/memory/raw"
LOG_FILE="$LOG_DIR/ram-guard.log"

mkdir -p "$LOG_DIR"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

DRY_RUN=0
if [[ "$1" == "--dry-run" ]]; then
    DRY_RUN=1
    log "Starting RAM Guard in DRY-RUN mode..."
fi

OS=$(uname -s)

if [ "$OS" = "Darwin" ]; then
    PAGE_SIZE=$(pagesize)
    MEM_TOTAL=$(sysctl -n hw.memsize)

    PAGES_FREE=$(vm_stat | awk '/Pages free/ {print $3}' | tr -d '.')
    PAGES_INACTIVE=$(vm_stat | awk '/Pages inactive/ {print $3}' | tr -d '.')
    PAGES_SPECULATIVE=$(vm_stat | awk '/Pages speculative/ {print $3}' | tr -d '.')

    # Calculate free RAM. On macOS, "Available" RAM is typically Free + Inactive + Speculative.
    # We use this combined value to avoid false positives from macOS's aggressive file caching.
    MEM_FREE_PAGES=$(( PAGES_FREE + PAGES_INACTIVE + PAGES_SPECULATIVE ))
    MEM_FREE_BYTES=$(( MEM_FREE_PAGES * PAGE_SIZE ))
    MEM_FREE_PCT=$(( MEM_FREE_BYTES * 100 / MEM_TOTAL ))
elif [ "$OS" = "Linux" ]; then
    MEM_TOTAL=$(free -b | awk '/^Mem:/ {print $2}')
    MEM_FREE_BYTES=$(free -b | awk '/^Mem:/ {print $7}')
    MEM_FREE_PCT=$(( MEM_FREE_BYTES * 100 / MEM_TOTAL ))
else
    log "Unsupported OS: $OS"
    exit 1
fi

log "Memory Status: ${MEM_FREE_PCT}% free/available (${MEM_FREE_BYTES} bytes out of ${MEM_TOTAL} bytes)"

if [ "$MEM_FREE_PCT" -lt 15 ]; then
    log "WARNING: Free RAM is below 15% threshold. Scanning for ollama processes..."

    OLLAMA_PROCS=$(ps -eo pid,rss,comm | grep -i "[o]llama")

    if [ -z "$OLLAMA_PROCS" ]; then
        log "No ollama processes found to kill."
        exit 0
    fi

    echo "$OLLAMA_PROCS" | while read -r PID RSS COMM; do
        [ -z "$PID" ] && continue

        if [[ "$DRY_RUN" -eq 1 ]]; then
            log "[DRY-RUN] Would send SIGTERM to $COMM (PID: $PID, RSS: ${RSS}KB)"
        else
            log "Action: Sending SIGTERM to $COMM (PID: $PID, RSS: ${RSS}KB)"
            kill -15 "$PID" 2>/dev/null

            sleep 2

            if kill -0 "$PID" 2>/dev/null; then
                log "Action: Process $PID ($COMM) still alive. Sending SIGKILL..."
                kill -9 "$PID" 2>/dev/null
            else
                log "Success: Process $PID ($COMM) terminated gracefully."
            fi
        fi
    done
else
    log "RAM is healthy (${MEM_FREE_PCT}%). No action required."
fi
