---
name: memory-observor
description: "Captures observations during work and sends them to the memory system. Use when discovering patterns, making decisions, or finding issues. Feeds observations to kairos/autodream for consolidation."
triggers: osserva memoria, capture observation, log finding, memory observation, note this, remember this, capture pattern
---

# Memory Observor

## Concept

Memory Observor is the "scribe" of the memory ecosystem. While you work, it captures:
- **FINDING**: Something discovered in code
- **PATTERN**: Recurring pattern identified
- **DECISION**: Architectural decision made
- **ISSUE**: Bug or problem found
- **INSIGHT**: Strategic observation
- **LINK**: Relationship between components

## Observation Format

```
[TYPE] timestamp | content | refs: file1, file2 | status: new | confidence: high
```

## When to Use

- After discovering a new pattern in the codebase
- When making an architectural decision
- When finding a bug or issue
- When learning something about the project
- When linking two components together

## Protocol

### 1. Capture Observation

```bash
# Send observation to memory system
echo "[FINDING] $(date '+%Y-%m-%d %H:%M') | Found auth middleware pattern | refs: src/auth/middleware.ts | status: new | confidence: high" >> ~/.config/opencode/memory/raw/observations.log
```

### 2. Types

| Type | When | Example |
|------|------|---------|
| `FINDING` | Discovered something | Found error handling pattern |
| `PATTERN` | Recurring pattern | All API routes use try/catch |
| `DECISION` | Made a choice | Using JWT over sessions |
| `ISSUE` | Found a bug | Memory leak in WebSocket handler |
| `INSIGHT` | Strategic observation | Auth is the bottleneck |
| `LINK` | Relationship | auth.ts depends on config.ts |

### 3. Confidence Levels

- `high` - Verified against codebase
- `medium` - Likely but not verified
- `low` - Hypothesis

### 4. References

Always include file refs when possible:
- File paths: `refs: src/auth.ts, src/middleware.ts`
- Directories: `refs: src/components/`
- Patterns: `refs: grep -r 'TODO' src/`

## CLI Usage

```bash
# Quick observation
memory-observor.sh "[FINDING] New pattern discovered | refs: file.ts | confidence: high"

# Batch observations
memory-observor.sh << 'EOF'
[FINDING] Pattern 1 | refs: file1.ts | confidence: high
[PATTERN] Pattern 2 | refs: file2.ts | confidence: medium
EOF
```

## Integration

### With kairos
- kairos generates observations during scans
- memory-observor sends them to observations.log

### With autodream
- autodream reads observations.log
- Verifies and consolidates to topics

### With memory-index-reader
- Consolidated topics update MEMORY.md

## Validation Checklist

- [ ] Observation format correct
- [ ] Type is valid (FINDING/PATTERN/DECISION/ISSUE/INSIGHT/LINK)
- [ ] Timestamp included
- [ ] File refs provided when possible
- [ ] Confidence level set
