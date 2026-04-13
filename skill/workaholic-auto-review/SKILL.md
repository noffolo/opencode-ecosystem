---
name: workaholic-auto-review
description: "Review last output for hallucinations and syntax errors, auto-correct issues, block release until internal coherence check passes."
triggers: controlla bug, review, sicuro che va, auto review, quality check, verify output
---
# Workaholic Auto-Review

## When to Use
- "Controlla bug", "review", "sicuro che va?"
- Pre-release quality gate

## Protocol

### 1. Syntax Check
- Run linter on all modified files
- Verify type annotations
- Check for import errors

### 2. Hallucination Detection
- Verify all referenced APIs exist
- Confirm method signatures match actual libraries
- Validate file paths and module names
- Cross-check against actual codebase (not assumptions)

### 3. Logic Coherence
- Does the code do what was requested?
- Are edge cases handled?
- Are there any obvious bugs or race conditions?

### 4. Auto-Correction
If issues found:
- Fix automatically
- Re-run the check
- Max 2 correction cycles

### 5. Release Gate
Code is NOT released until:
- All syntax checks pass
- No hallucinations detected
- Logic coherence confirmed
- At least one verification command succeeds
