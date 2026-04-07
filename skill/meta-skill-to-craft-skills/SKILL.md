---
name: meta-skill-to-craft-skills
description: "Generates new skill files following a standardized schema. Analyzes user requests, creates .md files with title/ID/triggers/instructions, checks for duplicates, and saves to the skills directory."
triggers: crea una nuova skill, aggiungi potere, nuova abilità, genera skill, create new skill, add capability
---

# Meta Skill to Craft Skills

## When to Use
- "Crea una nuova skill", "aggiungi potere", "nuova abilità", "genera skill"
- Any request to create a new agent skill or capability

## Protocol

### 1. Analyze the Request
Identify the new functionality the user needs:
- What domain does it cover? (DevOps, UI, data, testing, etc.)
- What triggers should activate it?
- What existing skills overlap with this? (check the skills index first)

### 2. Generate the Skill File
Create a `.md` file following this exact schema:

```markdown
---
name: <kebab-case-name>
description: "<One-line description of what the skill does and when to use it>"
triggers: <comma-separated natural language triggers>
---

# Skill Title

## When to Use
- When the user asks for X
- When Y situation occurs

## Protocol

### 1. Step Name
[What to do and how]

### 2. Step Name
[What to do and how]

## Validation Checklist
- [ ] Check 1
- [ ] Check 2
```

### 3. Project-Specific Integration
If the skill relates to a specific project or system:
- Add explicit instructions to consult the project's memory/index for existing patterns
- Reference the appropriate data structures and APIs
- Include resource-aware guidelines (RAM, CPU, network constraints)

### 4. Save & Self-Correct
- Propose the filename to the user
- Request permission before writing
- Default location: `~/.config/opencode/skill/<skill-name>/SKILL.md`

### 5. Self-Correction (Mandatory)
After writing the file, validate it immediately:

1. **Parse frontmatter**: Extract the YAML block between `---` markers
2. **Validate required fields**: `name`, `description`, `triggers` must all be present
3. **Check name matches directory**: The `name` value must equal the directory name (kebab-case)
4. **Verify YAML syntax**: Ensure no unquoted special characters in values
5. **If validation fails**: Fix the issue and rewrite the file before presenting to the user

Quick validation script you can run:
```bash
python3 -c "
import re
with open('path/to/SKILL.md') as f:
    c = f.read()
m = re.match(r'^---\n(.*?)\n---', c, re.DOTALL)
assert m, 'no frontmatter'
fm = m.group(1)
assert 'name:' in fm, 'missing name'
assert 'description:' in fm, 'missing description'
assert 'triggers:' in fm, 'missing triggers'
print('valid')
"
```

## Validation Checklist

Before presenting the new skill:

- [ ] **No duplicate**: Verified the skill doesn't already exist in the skills index
- [ ] **Resource-aware**: Instructions respect system constraints (RAM, CPU)
- [ ] **Triggers defined**: At least 3-4 natural language triggers
- [ ] **ID unique**: Name follows kebab-case and doesn't conflict with existing skills
- [ ] **Instructions actionable**: Each step is a concrete, verifiable action
- [ ] **Schema compliant**: Follows the standard YAML frontmatter + Markdown format
- [ ] **Universal**: No hardcoded project references unless explicitly requested
