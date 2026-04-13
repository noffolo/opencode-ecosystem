---
name: memory-index-reader
description: "Read, update, and maintain the MEMORY.md index file with strict write discipline. Validates pointers against actual files before updating the index. Integrates with autodream, kairos, and ultraplan for a complete memory ecosystem."
triggers: aggiorna memoria, memory index, strict write, aggiorna MEMORY.md, memory pointer, verifica memoria, memory discipline, memory update
---

# Memory Index Reader

## Concept

Memory Index Reader is the "librarian" of the memory ecosystem. It maintains MEMORY.md and ensures memory integrity through strict write discipline.

## Ecosystem Integration

```
memory-observor ──> kairos ──> autodream ──> memory-index-reader
    (capture)       (scan)    (consolidate)     (index)
```

| Plugin | Role |
|--------|------|
| **memory-observor** | Captures observations during work |
| **kairos** | Generates structured observations from code |
| **autodream** | Consolidates observations into topics |
| **memory-index-reader** | Maintains MEMORY.md index |

## When to Use

- After completing a significant task that changes project state
- When the user asks to update memory
- Before starting a new session to refresh context
- After autodream has consolidated new observations
- When a pointer is suspected stale

## Protocol

### 1. Read Current State

```bash
# Global memory
cat ~/.config/opencode/memory/MEMORY.md

# Project memory
cat .opencode/memory/MEMORY.md
```

### 2. Strict Write Discipline

Before updating any pointer:

1. **Verify target exists**: `test -f topics/<topic>.md`
2. **Verify readable**: `head -1 topics/<topic>.md`
3. **Verify content relevant**: Read topic, confirm match
4. **Log the write attempt**: Add to raw/activity.log
5. **Only then update**: Add to MEMORY.md

```bash
# Use strict_write.py for validation
python3 ~/.config/opencode/memory/strict_write.py add \
  "category" \
  "Brief description" \
  "topics/file.md"
```

### 3. Pointer Format

```
[category] Brief description (~150 chars) → topics/file.md (verified YYYY-MM-DD)
```

Categories:
- `[project]` - Project configuration
- `[architecture]` - System design
- `[patterns]` - Code patterns
- `[skills]` - Skill-related
- `[plugins]` - Plugin ecosystem
- `[decisions]` - Architectural decisions
- `[memory]` - Memory system itself

### 4. Skeptical Reading

When using MEMORY.md:
- Every pointer is a **hint**, not a fact
- Verify against actual codebase before acting
- Mark stale pointers for correction

### 5. Adding New Topics

```bash
# Create topic file
cat > topics/new-topic.md << 'EOF'
# Topic: New Topic

## Summary
Brief overview

## Facts
- Verified fact 1
- Verified fact 2

## References
- src/file.ts
- docs/spec.md

## Last Updated
YYYY-MM-DD
EOF

# Add pointer (only after verification)
python3 strict_write.py add "category" "Description" "topics/new-topic.md"
```

### 6. Regenerate from Topics

```bash
# Rebuild MEMORY.md from topic files
python3 strict_write.py regenerate

# Verify all pointers
python3 strict_write.py verify
```

## Integration with autodream

After autodream consolidation:

```bash
# Verify autodream updates
python3 strict_write.py verify

# Check for stale pointers
grep "verified 2026" ~/.config/opencode/memory/MEMORY.md | \
  awk -F'|' '$2 < $(date -d '30 days ago' +%s)' | \
  while read -r line; do
    echo "STALE: $line"
  done
```

## Integration with kairos

Kairos findings update topics:

```bash
# Kairos updates raw/observations.log
# autodream consolidates to topics/
# memory-index-reader verifies topics

# Check for new kairos findings
tail -20 ~/.config/opencode/memory/raw/observations.log | \
  grep -E '\[ISSUE\]|\[FINDING\]'
```

## Integration with ultraplan

Planning sessions create topics:

```bash
# After ultraplan, update memory
echo "[planning] Plan: {name} created" >> topics/planning.md
python3 strict_write.py add "planning" "Plan: {name}" "topics/planning.md"
```

## Validation Checklist

- [ ] Target exists before adding
- [ ] Content verified against source
- [ ] Description ≤150 characters
- [ ] Verification date current
- [ ] Failed writes logged
- [ ] Stale pointers removed
- [ ] Category correct
- [ ] Format consistent

## CLI Reference

```bash
# Add pointer
strict_write.py add <category> <description> <topic>

# Verify all
strict_write.py verify

# Remove stale
strict_write.py remove <category>

# Regenerate
strict_write.py regenerate

# Check health
strict_write.py health
```

## Files

- `MEMORY.md` - Main index
- `topics/*.md` - Topic files
- `raw/failed-writes.log` - Failed attempts
- `raw/activity.log` - All writes
- `strict_write.py` - Validation utility
