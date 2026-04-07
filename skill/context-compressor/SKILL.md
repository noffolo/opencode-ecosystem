---
name: context-compressor
description: "Analyze open files and create a CONTEXT_MAP.md with main exports, env vars, and feature state to save tokens and RAM."
triggers: riassumi progetto, pulisci contesto, troppo codice, context map, compress context, save tokens
---
# Context Compression

## When to Use
- Context window getting full
- "Riassumi progetto", "pulisci contesto"
- Before switching to a different task

## Protocol

### 1. Analyze Open Files
Identify all active modules and their relationships.

### 2. Create CONTEXT_MAP.md
Generate a temporary file containing:
- **Main exports** of each module (signatures only, no implementation)
- **Required environment variables**
- **Current feature state** (what's done, what's pending)
- **Key interfaces and types**
- **Dependency graph** (which module imports which)

### 3. Request Context Forget
Ask the orchestrator to "forget" the full source files and use only CONTEXT_MAP.md for subsequent operations. This saves significant tokens and RAM.

### 4. Cleanup
Delete CONTEXT_MAP.md when the task is complete or when full context is needed again.
