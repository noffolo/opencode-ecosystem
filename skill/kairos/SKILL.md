---
name: kairos
description: "Proactive daemon for OpenCode. Monitors repositories for bugs, prepares commits, and generates actionable observations. Works with autodream for idle consolidation and memory-index-reader for memory updates. Reports findings to memory for downstream processing."
triggers: kairos, bug hunter, commit prepper, proactive scan, repository monitor, find bugs, prepare commit, scan repository
---

# Kairos - Proactive Repository Guardian

## Concept

Kairos is the "scout" of the memory ecosystem. While you work:
1. **Bug Hunter** - Scans for code smells, TODOs, missing error handling
2. **Commit Prepper** - Prepares atomic commits from unstaged changes
3. **Doc Watcher** - Detects outdated documentation
4. **Observer** - Generates structured observations for autodream

## Architecture

```
┌─────────────┐
│   kairos   │──────────────┐
│  (scout)   │              │
└──────┬──────┘              │
       │ observations         │ reports
       v                     v
┌─────────────┐      ┌─────────────┐
│ autodream   │      │    user     │
│(consolidate)│      │ (TUI/notif) │
└─────────────┘      └─────────────┘
```

## When to Use

- **Automatic**: Via cron or on-save hook
- **Manual**: `bash ~/.config/opencode/memory/kairos.sh [repo_path]`
- **On Git Hook**: Post-commit or pre-push

## Protocol

### Phase 1: Bug Hunter

Scans recent changes for patterns:

```bash
# TODO/FIXME comments added
TODO_COUNT=$(git diff HEAD~5 -- '*.ts' '*.js' '*.py' '*.go' | grep -c 'TODO' || true)

# Empty catch blocks
CATCH_COUNT=$(git diff HEAD~5 -- '*.ts' '*.js' | grep -c 'catch' || true)

# Debug statements
DEBUG_COUNT=$(git diff HEAD~5 -- '*.ts' '*.js' '*.py' | grep -cE 'console\.(log|debug)|print\(|debugger' || true)

# Hardcoded secrets
SECRET_COUNT=$(git diff HEAD~5 | grep -cE 'password=|api_key=|secret=' || true)
```

### Phase 2: Commit Prepper

Prepares Conventional Commits from unstaged changes:

```bash
# Categorize changes
FEAT_FILES=$(git diff --name-only | grep -E 'src/|lib/' | grep -v test)
TEST_FILES=$(git diff --name-only | grep -E 'test|spec')
DOC_FILES=$(git diff --name-only | grep -E 'README|docs|\.md$')

# Generate commit suggestions
if [ -n "$FEAT_FILES" ]; then
  echo "feat: $(git diff --stat | tail -1)"
fi
```

### Phase 3: Doc Watcher

Detects documentation out of sync with code:

```bash
# Find function docs missing
for func in $(grep -r 'function ' src/ --include='*.ts' | cut -d: -f2 | cut -d'(' -f1); do
  if ! grep -q "$func" docs/*.md; then
    echo "Missing doc: $func"
  fi
done
```

### Phase 4: Generate Observations

Creates structured observations for autodream:

```
[FINDING] timestamp | Discovered {N} TODOs in recent commits | refs: {files} | status: new | confidence: high
[ISSUE] timestamp | Empty catch blocks detected | refs: {files} | status: new | confidence: medium
[INSIGHT] timestamp | Commit prep ready: {N} files staged | refs: none | status: new | confidence: high
```

## Output Format

Kairos generates a daily report:

```markdown
# Kairos Report - {date}

## Bug Hunter
- [WARN] {N} TODOs added in recent commits
- [INFO] {N} catch blocks detected
- [WARN] {N} debug statements
- [CRITICAL] {N} potential secrets

## Commit Prepper
- Staged: {N} files
- Unstaged: {N} files
- Suggested commits:
  - feat: {description}
  - test: {description}
  - docs: {description}

## Doc Watcher
- Missing docs: {N} items
- Outdated docs: {N} items

## Observations Generated
{N} observations sent to autodream
```

## Integration

### With autodream
- Observations logged to `observations.log` for consolidation
- Corrections logged to `corrections.log`

### With memory-index-reader
- Updates MEMORY.md with findings
- Adds topic entries for patterns discovered

### With ultraplan
- If critical issues found, suggests running ultraplan

## CLI Usage

```bash
# Scan current directory
kairos.sh

# Scan specific repo
kairos.sh /path/to/repo

# Bug hunt only
kairos.sh --bug-hunt

# Commit prep only
kairos.sh --commit-prep

# Generate observations only
kairos.sh --observe

# Quiet mode (less output)
kairos.sh --quiet
```

## Cron Setup

```bash
# Run every 30 minutes
*/30 * * * * ${HOME}/.config/opencode/memory/kairos.sh >> /dev/null 2>&1

# On save hook (add to .git/hooks/post-commit)
#!/bin/bash
${HOME}/.config/opencode/memory/kairos.sh $(pwd)
```

## Git Hook Integration

To run kairos on commit:

```bash
# .git/hooks/post-commit
#!/bin/bash
${HOME}/.config/opencode/memory/kairos.sh "$(pwd)"
```

## Validation Checklist

- [ ] Bug patterns detected correctly
- [ ] Commit suggestions accurate
- [ ] Observations logged in correct format
- [ ] Report generated with timestamp
- [ ] Corrections logged when issues found
- [ ] Works with empty git diff
- [ ] Works with multiple git remotes

## Files

- `kairos.sh` - Main daemon script
- `raw/observations.log` - Output observations
- `raw/corrections.log` - Issues found
- `raw/kairos-report-{date}.md` - Daily reports
- `raw/kairos-activity.log` - Activity history

## Report Severity

| Level | Meaning | Action |
|-------|---------|--------|
| `[CRITICAL]` | Security issues, secrets | Immediate action |
| `[WARN]` | Code smells, TODOs | Fix soon |
| `[INFO]` | Informational | Review later |
| `[OK]` | No issues | None |
