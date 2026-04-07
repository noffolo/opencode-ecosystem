---
name: code-translator
description: "Translates code across languages using In-Context Learning from a project demonstration file to perfectly mimic local architectural styles."
triggers: translate code, convert code, port to, rewrite in, code translation
---

# Code Translator

## When to Use
- When the user asks to translate code from one language to another (e.g., Python to Go, React to Vue).
- When porting legacy code to a modern framework within the same project.
- When you need to ensure the translated code matches the exact architectural style and conventions of the target codebase.

## Protocol

### 1. Identify Source and Target
Determine the source code/file to be translated and the desired target language or framework.

### 2. Request Demonstration File (Mandatory)
**CRITICAL:** You MUST ask the user to point to a 'Demonstration' file in the target language within the current project. 
- Explain that this is required for In-Context Learning (ICL) to perfectly mimic the project's exact architectural style, rather than generating generic boilerplate.
- Pause and wait for the user to provide the file path before proceeding.

### 3. Analyze the Demonstration File (ICL Extraction)
Once provided, read the demonstration file and extract key project-specific conventions:
- Naming conventions (variables, functions, classes, files).
- Architectural patterns (e.g., dependency injection, functional vs. OOP, state management).
- Error handling and logging styles.
- Import structures and usage of internal utilities/helpers.

### 4. Perform Context-Aware Translation
Translate the source code into the target language, strictly applying the conventions learned in Step 3. 
- Do not use generic, textbook boilerplate.
- Map source concepts to the target language's idiomatic equivalents as demonstrated in the context file.

### 5. Review and Refine
Compare the translated output against both the source (for functional equivalence) and the demonstration file (for stylistic consistency). Adjust any deviations before presenting the final code.

## Validation Checklist
- [ ] Did I explicitly ask the user for a demonstration file in the target language?
- [ ] Did I wait for the user to provide the file before generating the translation?
- [ ] Does the translated code use the exact conventions, imports, and patterns found in the demonstration file?
- [ ] Is the translated code functionally equivalent to the original source?