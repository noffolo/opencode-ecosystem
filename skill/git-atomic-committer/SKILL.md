---
name: git-atomic-committer
description: "Split changes into logical commits following Conventional Commits standard with Context lines referencing task IDs."
triggers: commit, pusha, finito task, git commit, salva lavoro, conventional commits, atomic commit, impatto aleph, impatto scraper
---
# Atomic Git Commit

## When to Use
- "Commit", "pusha", "finito task"
- After completing any logical unit of work

## Protocol

### 1. Analyze Changes
Run `git diff` to see all modifications.

### 2. Split into Logical Commits
Separate changes by concern:
- `feat:` — new features
- `fix:` — bug fixes
- `docs:` — documentation updates
- `refactor:` — code restructuring (no behavior change)
- `test:` — test additions/modifications
- `chore:` — config, dependencies, tooling

### 3. Write Commit Messages
Follow Conventional Commits:
```
<type>(<scope>): <description>

Context: <task-id-or-reference>
```

### 4. Atomic Rule
Each commit must:
- Be independently compilable
- Pass all existing tests
- Represent a single logical change

### 4. Impact Section
Include a specific `Impact:` line citing affected systems:
- `Impact: [Aleph | Scraper | DevOps]`
- What changed and why
- Affected modules
- Breaking changes (if any)

### 5. Verify
Run `git log --oneline` to confirm clean history.
