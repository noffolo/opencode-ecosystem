#!/bin/bash
# kairos.sh - Proactive Repository Guardian
# Bug hunter, commit prepper, doc watcher, observer
# Part of: memory-index-reader + autodream + ultraplan + kairos ecosystem

REPO_PATH="${1:-$(pwd)}"
MEMORY_DIR="$HOME/.config/opencode/memory"
RAW_DIR="$MEMORY_DIR/raw"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M')
TODAY=$(date '+%Y%m%d')
REPORT_FILE="$RAW_DIR/kairos-report-$TODAY.md"

cd "$REPO_PATH" || exit 1

# Ensure raw directory exists
mkdir -p "$RAW_DIR"

# === PHASE 1: BUG HUNTER ===
BUG_ISSUES=0
OBSERVATIONS=()

echo "=== Kairos Report ===" > "$REPORT_FILE"
echo "Date: $TIMESTAMP" >> "$REPORT_FILE"
echo "Repo: $REPO_PATH" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "## Bug Hunter" >> "$REPORT_FILE"

# TODO/FIXME comments
TODO_COUNT=$(git diff HEAD~5 -- '*.ts' '*.js' '*.py' '*.go' 2>/dev/null | grep -c 'TODO' || true)
[ -z "$TODO_COUNT" ] && TODO_COUNT=0
if [ "$TODO_COUNT" -gt 0 ]; then
    echo "- [WARN] $TODO_COUNT TODO comments in recent commits" >> "$REPORT_FILE"
    BUG_ISSUES=$((BUG_ISSUES + 1))
    TODO_FILES=$(git diff HEAD~5 --name-only -- '*.ts' '*.js' '*.py' '*.go' 2>/dev/null | head -5 | tr '\n' ',' | sed 's/,$//')
    [ -z "$TODO_FILES" ] && TODO_FILES="none"
    OBSERVATIONS+=("[ISSUE] $TIMESTAMP | Found $TODO_COUNT TODOs in recent commits | refs: $TODO_FILES | status: new | confidence: medium")
fi

# Empty catch blocks
CATCH_COUNT=$(git diff HEAD~5 -- '*.ts' '*.js' 2>/dev/null | grep -c 'catch' || true)
[ -z "$CATCH_COUNT" ] && CATCH_COUNT=0
if [ "$CATCH_COUNT" -gt 0 ]; then
    echo "- [INFO] $CATCH_COUNT catch blocks in recent diff" >> "$REPORT_FILE"
fi

# Debug statements
DEBUG_COUNT=$(git diff HEAD~5 -- '*.ts' '*.js' '*.py' 2>/dev/null | grep -cE 'console\.(log|debug)|print\(|debugger' || true)
[ -z "$DEBUG_COUNT" ] && DEBUG_COUNT=0
if [ "$DEBUG_COUNT" -gt 0 ]; then
    echo "- [WARN] $DEBUG_COUNT debug statements added" >> "$REPORT_FILE"
    BUG_ISSUES=$((BUG_ISSUES + 1))
    DEBUG_FILES=$(git diff HEAD~5 --name-only -- '*.ts' '*.js' '*.py' 2>/dev/null | head -5 | tr '\n' ',' | sed 's/,$//')
    [ -z "$DEBUG_FILES" ] && DEBUG_FILES="none"
    OBSERVATIONS+=("[ISSUE] $TIMESTAMP | Found $DEBUG_COUNT debug statements | refs: $DEBUG_FILES | status: new | confidence: high")
fi

# Hardcoded secrets (potential)
SECRET_COUNT=$(git diff HEAD~5 2>/dev/null | grep -cE 'password\s*=|api_key\s*=|secret\s*=|token\s*=' || true)
[ -z "$SECRET_COUNT" ] && SECRET_COUNT=0
if [ "$SECRET_COUNT" -gt 0 ]; then
    echo "- [CRITICAL] $SECRET_COUNT potential hardcoded secrets" >> "$REPORT_FILE"
    BUG_ISSUES=$((BUG_ISSUES + 1))
    OBSERVATIONS+=("[ISSUE] $TIMESTAMP | Potential secrets detected ($SECRET_COUNT) | refs: none | status: new | confidence: high")
fi

if [ "$BUG_ISSUES" -eq 0 ]; then
    echo "- [OK] No critical bug patterns detected" >> "$REPORT_FILE"
fi

# === PHASE 2: COMMIT PREPPER ===
echo "" >> "$REPORT_FILE"
echo "## Commit Prepper" >> "$REPORT_FILE"

UNSTAGED=$(git diff --name-only 2>/dev/null)
STAGED=$(git diff --cached --name-only 2>/dev/null)

if [ -z "$UNSTAGED" ] && [ -z "$STAGED" ]; then
    echo "- [OK] No pending changes" >> "$REPORT_FILE"
else
    echo "Pending changes:" >> "$REPORT_FILE"
    [ -n "$STAGED" ] && echo "  Staged: $(echo "$STAGED" | wc -l) files" >> "$REPORT_FILE"
    [ -n "$UNSTAGED" ] && echo "  Unstaged: $(echo "$UNSTAGED" | wc -l) files" >> "$REPORT_FILE"
    
    # Categorize for commits
    FEAT_FILES=$(git diff --name-only 2>/dev/null | grep -E 'src/|lib/|pkg/' | grep -v test | grep -v spec || true)
    TEST_FILES=$(git diff --name-only 2>/dev/null | grep -E 'test|spec' || true)
    DOC_FILES=$(git diff --name-only 2>/dev/null | grep -E 'README|docs|\.md$|CHANGELOG' || true)
    CONFIG_FILES=$(git diff --name-only 2>/dev/null | grep -E 'package\.json|\.config\.|tsconfig|webpack' || true)
    
    echo "" >> "$REPORT_FILE"
    echo "Suggested commits:" >> "$REPORT_FILE"
    
    [ -n "$FEAT_FILES" ] && echo "  feat: $(echo "$FEAT_FILES" | head -3 | tr '\n' ',' | sed 's/,$//')" >> "$REPORT_FILE"
    [ -n "$TEST_FILES" ] && echo "  test: update test coverage" >> "$REPORT_FILE"
    [ -n "$DOC_FILES" ] && echo "  docs: update documentation" >> "$REPORT_FILE"
    [ -n "$CONFIG_FILES" ] && echo "  chore: update configuration" >> "$REPORT_FILE"
    
    # Generate observation
    TOTAL_CHANGES=$(git diff --name-only 2>/dev/null | wc -l | tr -d ' ')
    OBSERVATIONS+=("[INSIGHT] $TIMESTAMP | $TOTAL_CHANGES files changed, commit ready | refs: none | status: new | confidence: high")
fi

# === PHASE 3: PATTERN DETECTION ===
echo "" >> "$REPORT_FILE"
echo "## Pattern Detection" >> "$REPORT_FILE"

# Detect new patterns
LANG=$(git diff HEAD~10 --name-only 2>/dev/null | grep -E '\.(ts|js)$' | head -1 | cut -d. -f2)
if [ "$LANG" = "ts" ] || [ "$LANG" = "js" ]; then
    NEW_IMPORTS=$(git diff HEAD~5 -- '*.ts' '*.js' 2>/dev/null | grep '^+import' | wc -l | tr -d ' ')
    if [ "$NEW_IMPORTS" -gt 5 ]; then
        echo "- [INFO] $NEW_IMPORTS new imports added" >> "$REPORT_FILE"
        OBSERVATIONS+=("[PATTERN] $TIMESTAMP | High import activity ($NEW_IMPORTS new) | refs: none | status: new | confidence: medium")
    fi
fi

# Detect architecture changes
ARCH_CHANGES=$(git diff --name-only 2>/dev/null | grep -E '^(src/components/|src/hooks/|src/context/)' | wc -l | tr -d ' ')
if [ "$ARCH_CHANGES" -gt 0 ]; then
    echo "- [INFO] $ARCH_CHANGES architecture-level changes" >> "$REPORT_FILE"
    OBSERVATIONS+=("[INSIGHT] $TIMESTAMP | Architecture changes detected ($ARCH_CHANGES files) | refs: src/components,src/hooks | status: new | confidence: high")
fi

echo "" >> "$REPORT_FILE"

# === PHASE 4: GENERATE OBSERVATIONS ===
echo "## Observations" >> "$REPORT_FILE"
OBS_COUNT=0
for obs in "${OBSERVATIONS[@]}"; do
    echo "$obs" >> "$RAW_DIR/observations.log"
    echo "$obs" >> "$REPORT_FILE"
    OBS_COUNT=$((OBS_COUNT + 1))
done

if [ "$OBS_COUNT" -eq 0 ]; then
    echo "- [OK] No new observations" >> "$REPORT_FILE"
fi

# === PHASE 5: LOG ACTIVITY ===
echo "[$TIMESTAMP] Kairos scan: $BUG_ISSUES issues, $OBS_COUNT observations" >> "$RAW_DIR/kairos-activity.log"

# === OUTPUT ===
echo ""
echo "Kairos Report: $REPORT_FILE"
echo ""
cat "$REPORT_FILE"
