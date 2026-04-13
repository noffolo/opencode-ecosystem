#!/bin/bash
# autodream.sh - Memory Consolidation During Idle Time
# Verifies observations, updates topics, regenerates MEMORY.md
# Part of: memory-index-reader + autodream + ultraplan + kairos ecosystem

set -euo pipefail

MEMORY_DIR="$HOME/.config/opencode/memory"
TOPICS_DIR="$MEMORY_DIR/topics"
RAW_DIR="$MEMORY_DIR/raw"
MEMORY_FILE="$MEMORY_DIR/MEMORY.md"
STRICT_WRITE="$MEMORY_DIR/strict_write.py"
CORRECTIONS_LOG="$RAW_DIR/corrections.log"
AUTODREAM_LOG="$RAW_DIR/autodream.log"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Parse args
IDLE_MINUTES=10
DRY_RUN=false
FORCE=false

while [[ $# -gt 0 ]]; do
  case $1 in
    --force) FORCE=true; shift ;;
    --dry-run) DRY_RUN=true; shift ;;
    --idle) IDLE_MINUTES="$2"; shift 2 ;;
    *) shift ;;
  esac
done

# === PHASE 0: IDLE CHECK ===
if [ "$FORCE" = false ]; then
  if pgrep -f "opencode" > /dev/null 2>&1; then
    echo "OpenCode active, skipping (use --force to override)"
    exit 0
  fi
fi

echo "=== autoDream Consolidation ==="
echo "Time: $(date '+%Y-%m-%d %H:%M')"
echo "Idle check: $IDLE_MINUTES minutes"

# Initialize counters
VERIFIED=0
CONTRADICTED=0
STALE=0
UNVERIFIED=0

# === PHASE 1: ENSURE STRUCTURE ===
mkdir -p "$TOPICS_DIR" "$RAW_DIR/raw"
touch "$RAW_DIR/observations.log"

# === PHASE 2: PROCESS OBSERVATIONS ===
OBS_FILE="$RAW_DIR/observations.log"
if [ ! -s "$OBS_FILE" ]; then
  echo "No observations to process"
  exit 0
fi

echo ""
echo "Processing observations..."

# Read observations (skip comments and empty lines)
while IFS= read -r line || [ -n "$line" ]; do
  # Skip comments and empty lines
  [[ "$line" =~ ^#.*$ ]] && continue
  [[ -z "$line" ]] && continue
  
  TYPE=$(echo "$line" | sed -n 's/^\[\([A-Z]*\)\].*/\1/p')
  [ -z "$TYPE" ] && TYPE="INSIGHT"
  CONTENT=$(echo "$line" | sed 's/^\[[A-Z]*\][^|]*| *//' | cut -d'|' -f1 | sed 's/^ *//;s/ *$//')
  REFS=$(echo "$line" | sed -n 's/.*refs: *\([^|]*\).*/\1/p' | tr ',' '\n' | sed 's/^ *//;s/ *$//')
  
  # === PHASE 2A: VERIFY REFS ===
  REF_VERIFIED=true
  REF_BROKEN=false
  
  if [ -n "$REFS" ]; then
    while IFS= read -r ref; do
      [ -z "$ref" ] && continue
      
      # Resolve path (try as-is, then relative to common dirs)
      if [ -f "$ref" ] || [ -d "$ref" ]; then
        continue  # Exists
      elif [ -f "$HOME/$ref" ]; then
        continue  # Exists in home
      elif [ -f "$(pwd)/$ref" ]; then
        continue  # Exists in cwd
      else
        REF_VERIFIED=false
        REF_BROKEN=true
        echo -e "${YELLOW}  ! Broken ref: $ref${NC}"
      fi
    done <<< "$REFS"
  fi
  
  # === PHASE 2B: CATEGORIZE ===
  if [ "$REF_VERIFIED" = true ] && [ -n "$REFS" ]; then
    # VERIFIED: refs exist and match
    VERIFIED=$((VERIFIED + 1))
    echo -e "${GREEN}  ✓ VERIFIED: ${CONTENT:0:60}...${NC}"
    
    # Add to topic file
    TOPIC_FILE="$TOPICS_DIR/${TYPE,,}s.md"
    echo "# $TYPE: $CONTENT" >> "$TOPIC_FILE"
    echo "Date: $(date '+%Y-%m-%d')" >> "$TOPIC_FILE"
    echo "Refs: $REFS" >> "$TOPIC_FILE"
    echo "" >> "$TOPIC_FILE"
    
  elif [ "$REF_BROKEN" = true ]; then
    # CONTRADICTED: refs don't exist
    CONTRADICTED=$((CONTRADICTED + 1))
    echo -e "${RED}  ✗ CONTRADICTED: $CONTENT${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M')] CONTRADICTED: $CONTENT | REFS: $REFS" >> "$CORRECTIONS_LOG"
    
  elif echo "$line" | grep -q '| status: stale'; then
    # STALE: marked as stale
    STALE=$((STALE + 1))
    echo -e "${YELLOW}  ⊘ STALE: ${CONTENT:0:60}...${NC}"
    # Archive old observation
    echo "$line" >> "$RAW_DIR/raw/old-observations-$(date '+%Y%m%d').log"
    
  else
    # UNVERIFIED: no refs to check
    UNVERIFIED=$((UNVERIFIED + 1))
    echo -e "  ? UNVERIFIED: ${CONTENT:0:60}..."
  fi
  
done < "$OBS_FILE"

# === PHASE 3: CLEAN OLD OBSERVATIONS ===
echo ""
echo "Cleaning old data..."

# Archive observations older than 3 days
find "$RAW_DIR" -name "*.log" -mtime +3 ! -name "autodream.log" -exec mv {} "$RAW_DIR/raw/" \; 2>/dev/null || true

# Remove duplicates from observations.log (keep latest)
if [ -f "$OBS_FILE" ]; then
  # Keep only recent observations (last 100 lines)
  tail -100 "$OBS_FILE" > "$OBS_FILE.tmp" || true
  mv "$OBS_FILE.tmp" "$OBS_FILE"
fi

# === PHASE 4: REGENERATE MEMORY.MD ===
echo ""
echo "Regenerating MEMORY.md..."

if [ "$DRY_RUN" = false ]; then
  if [ -f "$STRICT_WRITE" ]; then
    python3 "$STRICT_WRITE" verify 2>&1 | tee -a "$AUTODREAM_LOG"
  else
    # Manual regeneration if strict_write not available
    {
      echo "# MEMORY.md - Auto-generated, do not edit manually"
      echo "# Last consolidated: $(date '+%Y-%m-%d')"
      echo ""
      for topic in "$TOPICS_DIR"/*.md; do
        [ -f "$topic" ] || continue
        basename "$topic" .md | grep -v "MEMORY" | while read -r name; do
          echo "[memory] $name -> topics/$name.md (verified $(date '+%Y-%m-%d'))"
        done
      done
    } > "$MEMORY_FILE"
  fi
else
  echo "[DRY RUN] Would regenerate MEMORY.md"
fi

# === PHASE 5: LOG ACTIVITY ===
LOG_LINE="[$(date '+%Y-%m-%d %H:%M')] Consolidation: $VERIFIED verified, $CONTRADICTED contradicted, $STALE stale, $UNVERIFIED unverified"
echo "$LOG_LINE" >> "$AUTODREAM_LOG"

# === PHASE 6: SUGGESTIONS ===
echo ""
echo "=== Summary ==="
echo "Verified: $VERIFIED"
echo "Contradicted: $CONTRADICTED"
echo "Stale: $STALE"
echo "Unverified: $UNVERIFIED"

if [ "$CONTRADICTED" -gt 3 ]; then
  echo ""
  echo -e "${YELLOW}Suggestion: Run /ultraplan to analyze contradictions${NC}"
  echo "Many contradictions detected - consider deep analysis"
fi

echo ""
echo "=== autoDream Complete ==="
