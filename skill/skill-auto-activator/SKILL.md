---
name: skill-auto-activator
description: "Automatically discover, activate, and use archived skills when they match the current task. If nothing is found locally, search GitHub via the github-research-installer skill. Scans the archive index, finds relevant skills, copies them to active, and loads them — all without user intervention."
triggers: skill non attiva, skill archiviata, serve una skill, attiva skill, skill mancante, archived skill, skill not found, need a skill, auto activate, cerca skill, librarian skill, cerca su github
---

# Skill Auto-Activator

## When to Use
- The user asks for something that matches a skill in the archive but not in active
- You realize during a task that an archived skill would be highly relevant
- A trigger phrase suggests a capability you don't currently have loaded
- Before starting a complex task, scan the archive for skills that could help
- **Always check before saying "no skill available"** — the archive has 78+ skills, and GitHub has thousands more

## Protocol

### 1. Search the Archive (Two Ways)

**Option A: Direct search (fast)**
```bash
cat ~/opencode-ecosystem/skills/.archive-index.json
```
Search the JSON for keywords matching the current task. Each entry has `name`, `description`, and `triggers`.

**Option B: Via librarian agent (thorough)**
When the task is complex or you're not sure what to search for, delegate to librarian:
```
task(subagent_type="librarian", load_skills=[], run_in_background=true,
  prompt="Search the archive index at ~/opencode-ecosystem/skills/.archive-index.json for skills relevant to: [TASK DESCRIPTION]. Look at name, description, and triggers fields. Return any matches with their full entry. Also check what skills are currently active in ~/.config/opencode/skill/ to avoid duplicates.")
```

### 2. Evaluate Relevance
For each potential match, ask:
- Does this skill's description match what I need to do?
- Would this skill improve the quality of my output?
- Is the skill not already in the active directory (`~/.config/opencode/skill/`)?

### 3. Activate the Skill
Use the activation script to copy the skill from archive to active:
```bash
~/opencode-ecosystem/skills/activate-skill <skill-name>
```

This copies the skill from `~/opencode-ecosystem/skills/archive/<name>` to `~/.config/opencode/skill/<name>`.

### 4. Load and Use the Skill
After activation, use the `skill` tool to load it:
```
skill(name="<skill-name>")
```

Then follow the skill's protocol for the current task.

### 5. Nothing in the Archive? Search GitHub

If the archive has nothing relevant, **do not give up**. Use the `github-research-installer` skill to search GitHub for community skills, tools, or code patterns:

```
skill(name="github-research-installer")
```

This skill can:
- Search GitHub for skills (`filename:SKILL.md opencode`)
- Find repos with relevant code patterns
- Download, validate, and install what it finds
- Search for libraries, configs, Dockerfiles, MCP servers — not just skills

The GitHub token is already configured in `~/opencode-ecosystem/.env` (5000 API requests/hour).

### 6. Log the Activation
Tell the user what happened:
```
[skill-auto-activator] activated "<skill-name>" — reason: <brief explanation>
```
Or if found on GitHub:
```
[skill-auto-activator] found and installed "<skill-name>" from github.com/username/repo
```

### 7. Deactivate When Done (Optional)
If the skill was only needed temporarily:
```bash
~/opencode-ecosystem/skills/deactivate-skill <skill-name>
```

## Auto-Discovery Workflow

When starting any non-trivial task, run this check:

1. **Extract keywords** from the user's request
2. **Search the archive index** for matching descriptions or triggers
3. **Compare** against currently active skills
4. **Activate** any highly relevant archived skills
5. **If nothing found**, search GitHub via `github-research-installer`
6. **Proceed** with the task using the newly loaded skill

## Key Reminders

- **The archive has 78+ skills** — don't skip this step
- **GitHub has thousands more** — if the archive is empty for your use case, search there
- **Librarian is your friend** for thorough archive searches
- **Always check before declaring "no skill available"**
- **Log every activation** so the user knows what's happening
- **Don't activate everything** — only what's genuinely relevant

## Validation Checklist

- [ ] Archive index was consulted (direct or via librarian) before declaring "no skill available"
- [ ] GitHub was searched via `github-research-installer` if archive had no matches
- [ ] Activated skill is relevant to the current task (not a false positive)
- [ ] Skill file was loaded via `skill` tool and its protocol followed
- [ ] Activation was logged for transparency
- [ ] Skill is not a duplicate of an already-active skill
