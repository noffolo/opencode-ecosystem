---
name: assimilate-knowledge
description: "Standardizes learning from an external GitHub repository by cloning, setting up daily syncs, extracting concepts, and generating new skills."
triggers: assimilate knowledge, learn from repo, ingest repository, study external source, clone and learn
---

# Assimilate Knowledge

## When to Use
- When the user asks to learn or assimilate a new GitHub repository.
- When you need to ingest external documentation and keep it updated automatically.
- When extracting reusable patterns from an external codebase into OpenCode skills.

## Protocol

### 1. Accept and Clone Repository
- Extract the `[repo-name]` from the provided repository URL.
- Ensure the target directory exists: `mkdir -p ~/.opencode/knowledge_base/`
- Clone the repository: `git clone <URL> ~/.opencode/knowledge_base/[repo-name]`

### 2. Setup Daily Sync (Cron Job)
- Create a sync script at `~/.opencode/knowledge_base/[repo-name]_sync.sh` with the following content:
  ```bash
  #!/bin/bash
  cd ~/.opencode/knowledge_base/[repo-name] || exit
  git pull
  ```
- Make the script executable: `chmod +x ~/.opencode/knowledge_base/[repo-name]_sync.sh`
- Add a cron job to run daily at 10:00 AM: 
  `bash -c '(crontab -l 2>/dev/null; echo "0 10 * * * ~/.opencode/knowledge_base/[repo-name]_sync.sh") | crontab -'`

### 3. Extract Core Concepts (Librarian Agents)
- Spawn `librarian` agents (via task creation or delegation) to read the markdown and documentation files within the cloned repository.
- Instruct the agents to extract core concepts, architectural decisions, and primary workflows.

### 4. Inject Concepts into Memory
- Compile the extracted concepts into a new file: `topics/[repo-name].md` inside the memory directory.
- Update the central memory index by linking the new topic file in `MEMORY.md` (use the `memory-index-reader` skill if available, or edit directly).

### 5. Generate New Skills (Explore Agent)
- Spawn an initial `explore` agent to analyze the codebase and identify 2-3 immediate, useful patterns.
- For each identified pattern, invoke the `meta-skill-to-craft-skills` skill to generate a new skill file.
- Ensure the generated skills are passed through the autonomous validation loop (deploy to temp, run bash simulation, PASS/FAIL check) before final deployment to the skills folder.

## Validation Checklist
- [ ] Repository is successfully cloned to `~/.opencode/knowledge_base/[repo-name]`.
- [ ] Cron job is installed and the sync script is executable.
- [ ] `topics/[repo-name].md` is created and populated with core concepts.
- [ ] `MEMORY.md` contains a valid link to the new topic file.
- [ ] 2-3 new skills have been drafted via `meta-skill-to-craft-skills` and submitted to the validation loop.