---
name: token-compressor-logic
description: "Minify code by removing comments, blank lines, and non-essential docstrings for efficient LLM token usage."
triggers: file troppo lungo, risparmia token, comprimi codice, minify, compress tokens, reduce context
---
# Token Compressor Logic

## When to Use
- "File troppo lungo", "risparmia token", "comprimi codice"
- Context window optimization

## Protocol

### 1. Remove Non-Essential Content
- Strip comments (except critical algorithm explanations)
- Remove blank lines
- Remove non-essential docstrings
- Collapse multi-line expressions where readable

### 2. Variable Abbreviation (Safe)
- Shorten internal variable names that don't affect API
- Keep public API names unchanged
- Preserve type annotations

### 3. Output Modes
- **Minified**: Maximum compression, for pure logic tasks
- **Balanced**: Remove only comments/blanks, preserve readability
- **API-safe**: Only remove comments, keep all signatures intact

### 4. Token Savings Report
Report original vs compressed token count.
