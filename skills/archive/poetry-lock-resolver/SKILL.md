---
name: poetry-lock-resolver
description: "Analyze Poetry dependency conflicts, identify version clashes (e.g. pydantic v1 vs v2), suggest exact fix commands."
triggers: errore dipendenze, poetry lock, conflitto, dependency conflict, version mismatch, poetry install
---
# Poetry Lock Resolver

## When to Use
- "Errore dipendenze", "poetry lock", "conflitto"
- Dependency resolution failures

## Protocol

### 1. Analyze Error
Parse the Poetry resolution error output.
Identify the conflicting packages and version constraints.

### 2. Identify Conflicts
Common patterns:
- `pydantic` v1 vs v2
- `numpy` version pinning conflicts
- Transitive dependency mismatches

### 3. Resolution Strategy
- **Option A**: Update the conflicting package to a compatible version
- **Option B**: Pin a specific version that satisfies all constraints
- **Option C**: Use `poetry add package@^version` to override

### 4. Commands
```bash
poetry lock --no-update  # Try without updating
poetry update package    # Update specific package
poetry add package@^2.0  # Pin version
```

### 5. Verify
Run `poetry check` and `poetry install --dry-run` to confirm resolution.
