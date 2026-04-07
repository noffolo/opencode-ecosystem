---
name: autodream
description: "Consolidates memory observations during idle time. Verifies observations against codebase, updates topics, and regenerates MEMORY.md. Runs automatically when OpenCode is inactive. Part of the memory plugin ecosystem with kairos, memory-index-reader, and ultraplan."
triggers: autodream, consolidation, idle consolidation, memory consolidation, verifica osservazioni, consolida memoria
---

# autoDream - Memory Consolidation Protocol

## Concept

autoDream is the "night shift" of the memory ecosystem. While you're working, kairos observes and logs. When you're idle, autoDream:
1. **Verifies** observations against the actual codebase
2. **Consolidates** confirmed observations into topics
3. **Corrects** contradictions (marks them for review)
4. **Cleans** stale/obsolete data
5. **Regenerates** MEMORY.md from verified topics
6. **Sedimentation (NEW):** Cross-references daily challenges with the synchronized external Knowledge Base to propose new skills for user validation.

## Architecture

```
┌─────────────┐    observations    ┌─────────────┐
│   kairos    │ ─────────────────> │  autodream   │
│  (observe)  │                    │ (consolidate)│
└─────────────┘                    └──────┬──────┘
                                         │
                    ┌────────────────────┼────────────────────┐
                    │                    │                    │
                    v                    v                    v
             ┌──────────┐        ┌──────────┐        ┌────────────────┐
             │  topics/ │        │ MEMORY.md│        │ skill-proposals│
             │  (L2)    │        │   (L1)   │        │   (Pending)    │
             └──────────┘        └──────────┘        └────────────────┘
```

## When to Use

- **Automatic**: Runs via cron when OpenCode is inactive (>10 min idle)
- **Manual**: `bash ~/.config/opencode/memory/autodream.sh`
- **After planning**: `autopilot.sh` chain includes autodream

## Observation Format

Observations sent to `observations.log` must follow this format:

```
[TYPE] timestamp | content | refs: file1.md, file2.ts | status: new | confidence: high
```

Types:
- `FINDING` - Something discovered in the codebase
- `PATTERN` - Recurring pattern identified
- `DECISION` - Architectural decision made
- `ISSUE` - Bug or problem found
- `INSIGHT` - Strategic observation
- `LINK` - Relationship between components

## Protocol

### Phase 1: Collect Observations
```bash
# Read all new observations since last consolidation
OBSERVATIONS=$(grep -v "^#" "$RAW_DIR/observations.log" | tail -50)
```

### Phase 2: Verify Against Codebase
For each observation with refs:

```bash
# Check if referenced files still exist
verify_ref() {
  local ref="$1"
  # Resolve relative paths from observation context
  if [ -f "$ref" ] || [ -d "$ref" ]; then
    return 0  # Verified
  fi
  # Check if pattern still exists in codebase
  if grep -rq "pattern" src/ 2>/dev/null; then
    return 0  # Pattern still present
  fi
  return 1  # Contradicted or stale
}
```

### Phase 3: Categorize

| Verdict | Action |
|---------|--------|
| **VERIFIED** | File exists AND content matches observation | Add to appropriate topic |
| **CONTRADICTED** | File changed OR pattern no longer exists | Log to corrections.log |
| **STALE** | Observation older than 7 days, no refs | Archive to raw/old-observations/ |
| **UNVERIFIED** | No refs to check | Keep for next run |

### Phase 4: Update Topics

For verified observations:
```bash
# Append to appropriate topic file
TOPIC_FILE="$TOPICS_DIR/${observation_type,,}s.md"
echo "$observation" >> "$TOPIC_FILE"
```

### Phase 5: Regenerate MEMORY.md

```bash
# Use strict_write to rebuild MEMORY.md from topics
python3 "$MEMORY_DIR/strict_write.py" regenerate
```

### Phase 6: Knowledge Sedimentation & Autonomous Skill Genesis

If high-friction points (`ISSUE` or repetitive `PATTERN`) were observed during the day:
1. Search the external Knowledge Base (`~/.opencode/knowledge_base/prompt-in-context-learning/`) for relevant solutions.
2. If a structural solution is found, invoke `meta-skill-to-craft-skills` to generate a candidate skill.
3. **Autonomous Validation Loop:**
   - Deploy the candidate skill to a temporary test directory.
   - Run a simulated `bash` task using the new skill against a sandboxed dummy file or test suite representing the original friction point.
   - **Evaluate:** Did the skill successfully resolve the issue without causing side-effects (e.g., failed tests, syntax errors)?
     - If **PASS**: Automatically move the skill to `~/.config/opencode/skill/` and log the ingestion: *"Skill [name] autonomously generated, validated, and deployed."*
     - If **FAIL**: Attempt ONE self-correction cycle by editing the skill's constraints based on the failure log. If it fails again, discard the draft to prevent polluting the ecosystem.
4. Update the archive index via `skill-auto-activator` protocols to make the new skill available for immediate use.

### Phase 7: Log Activity

```bash
echo "[$(date)] Consolidation: $VERIFIED verified, $CONTRADICTED corrected, $STALE cleaned, $NEW_SKILLS autonomously validated and deployed" >> "$RAW_DIR/autodream.log"
```

## Integration Points

### With kairos
- kairos generates observations with refs
- autodream verifies them during idle

### With memory-index-reader
- Uses strict_write.py for MEMORY.md updates
- Reads topic structure from memory-index-reader

### With ultraplan
- If many contradictions found, suggest running ultraplan for analysis
- Log planning suggestions to observations.log

## CLI Usage

```bash
# Standard run (uses 10 min idle threshold)
autodream.sh

# Custom idle threshold
autodream.sh 30

# Force run (ignore idle check)
autodream.sh --force

# Show only (dry run)
autodream.sh --dry-run
```

## Validation Checklist

- [ ] OpenCode idle check works
- [ ] Observations parsed correctly
- [ ] File refs verified against codebase
- [ ] Contradictions logged to corrections.log
- [ ] Topics updated with verified observations
- [ ] MEMORY.md regenerated correctly
- [ ] Activity logged to autodream.log

## Example Output

```
=== autoDream Consolidation ===
Time: 2026-04-06 02:30
Idle: 15 minutes

Observations: 12
  FINDING: 5
  PATTERN: 3
  ISSUE: 2
  DECISION: 2

Results:
  ✓ VERIFIED: 8 (added to topics)
  ✗ CONTRADICTED: 2 (logged to corrections.log)
  ⊘ STALE: 2 (archived)
  ? UNVERIFIED: 0

MEMORY.md regenerated: OK (6 pointers)
```

## Cron Setup

```bash
# Run every 30 minutes if idle > 10 min
*/30 * * * * ${HOME}/.config/opencode/memory/autodream.sh >> /dev/null 2>&1
```

## Error Handling

| Error | Action |
|-------|--------|
| observations.log missing | Create empty file, log warning |
| topics/ directory missing | Create via memory-index-reader |
| MEMORY.md regeneration fails | Keep previous version, log error |
| Ref verification timeout | Skip, mark as UNVERIFIED |

## Files

- `autodream.sh` - Main consolidation script
- `strict_write.py` - MEMORY.md update utility
- `topics/` - Consolidated observation files
- `raw/observations.log` - Source observations
- `raw/corrections.log` - Contradictions found
- `raw/autodream.log` - Consolidation history
