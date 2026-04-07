---
name: github-research-installer
description: "Search GitHub for skills, tools, plugins, and code patterns using the authenticated GitHub API. Download, validate, and install discovered resources. Versatile — works for skills, libraries, configs, and any GitHub-hosted content."
triggers: cerca su github, github search, trova skill online, installa da github, cerca risorsa github, github skill, github tool, cerca codice github, find on github, github install, github research
---

# GitHub Research & Installer

## When to Use
- No local skill matches the current task (checked active + archive)
- The user asks for something that likely exists on GitHub
- You need a tool, library, config template, or code pattern not available locally
- Researching how others solve a specific problem
- Finding and installing community skills or plugins

## Prerequisites

GitHub token is stored in `~/opencode-ecosystem/.env`:
```bash
source ~/opencode-ecosystem/.env
```

This gives 5000 API requests/hour (authenticated) vs 60/hour (unauthenticated).

## Protocol

### 1. Search GitHub

Use the GitHub Search API to find relevant content:

```bash
# Search for skills
curl -s -H "Authorization: token $GITHUB_TOKEN" \
  "https://api.github.com/search/code?q=SKILL.md+filename:SKILL.md+opencode+skill&per_page=10"

# Search for repos
curl -s -H "Authorization: token $GITHUB_TOKEN" \
  "https://api.github.com/search/repositories?q=opencode+skills&sort=stars&per_page=10"

# Search for specific topics
curl -s -H "Authorization: token $GITHUB_TOKEN" \
  "https://api.github.com/search/repositories?q=topic:opencode-skills&sort=stars&per_page=10"

# Search for code patterns
curl -s -H "Authorization: token $GITHUB_TOKEN" \
  "https://api.github.com/search/code?q=language:python+web+scraper+playwright&per_page=10"
```

**Useful search queries:**

| What you need | Query |
|---|---|
| OpenCode skills | `filename:SKILL.md opencode skill` |
| Skills by topic | `filename:SKILL.md go performance` |
| Repos with skills | `topic:opencode-skills` |
| Code examples | `language:go pprof memory profiling` |
| Config templates | `filename:docker-compose.yml postgres redis` |
| MCP servers | `filename:mcp_server.py OR mcp-server` |

### 2. Evaluate Results

For each result, check:

- **Stars/forks**: More stars = more battle-tested
- **Last updated**: Within the last year preferred
- **Author reputation**: Known orgs (microsoft, farmage, tercel) are safer
- **File structure**: Skills must have `SKILL.md` with valid frontmatter
- **No suspicious scripts**: Check for post-install hooks, eval statements, or network calls to unknown domains

### 3. Download

For skills, clone the repo or download the specific file:

```bash
# Clone a skill repo
cd ~/opencode-ecosystem/skills-staging
git clone --depth 1 https://github.com/username/repo.git

# Or download a single raw file
curl -s -H "Authorization: token $GITHUB_TOKEN" \
  "https://raw.githubusercontent.com/username/repo/main/skills/my-skill/SKILL.md" \
  -o /tmp/downloaded-skill.md
```

### 4. Validate (Security Gate)

Before installing anything, run these checks:

```bash
python3 << 'PYEOF'
import re, os

skill_file = "/tmp/downloaded-skill.md"  # or wherever you saved it

with open(skill_file) as f:
    content = f.read()

# 1. Check frontmatter exists
m = re.match(r'^---\n(.*?)\n---', content, re.DOTALL)
if not m:
    print("FAIL: no YAML frontmatter")
    exit(1)

fm = m.group(1)

# 2. Check required fields
for field in ['name', 'description', 'triggers']:
    if field + ':' not in fm:
        print(f"FAIL: missing '{field}' in frontmatter")
        exit(1)

# 3. Check for suspicious patterns
suspicious = [
    r'eval\(',           # eval() calls
    r'exec\(',           # exec() calls
    r'os\.system\(',     # shell execution
    r'subprocess\.call', # subprocess calls
    r'curl.*\|.*sh',     # pipe to shell
    r'wget.*\|.*bash',   # pipe to bash
    r'__import__',       # dynamic imports
    r'base64\.decode',   # base64 decoding (obfuscation)
]

for pattern in suspicious:
    if re.search(pattern, content):
        print(f"WARNING: suspicious pattern found: {pattern}")
        # Don't exit — warn but let the agent decide

print("VALID: skill format is correct")
PYEOF
```

### 5. Install

If validation passes, install the skill:

```bash
# For a skill: copy to active directory
cp /tmp/downloaded-skill.md ~/.config/opencode/skill/<skill-name>/SKILL.md

# Or use the activate script if it's in a repo
~/opencode-ecosystem/skills/activate-skill <skill-name>
```

### 6. Report to User

Always tell the user what you found and installed:

```
[github-research-installer] found and installed "<skill-name>" from github.com/username/repo
  - Stars: X | Last updated: date
  - Validation: passed (no suspicious patterns)
  - Installed to: ~/.config/opencode/skill/<skill-name>/
```

## What You Can Search For

This skill is not limited to skills. Use it for:

| Category | Example Queries |
|---|---|
| **Skills** | `filename:SKILL.md react testing` |
| **Libraries** | `language:go http client retry` |
| **Configs** | `filename:.golangci.yml best practices` |
| **Dockerfiles** | `filename:Dockerfile python slim multi-stage` |
| **CI/CD** | `filename:github-actions.yml go test build` |
| **MCP Servers** | `mcp server filesystem` |
| **Dotfiles** | `filename:.zshrc macos developer` |
| **Templates** | `filename:docker-compose.yml microservices` |

## Validation Checklist

- [ ] Local skills (active + archive) checked first — GitHub is the fallback
- [ ] GitHub search query is specific and targeted
- [ ] Results evaluated for quality (stars, recency, author)
- [ ] Security validation passed (no suspicious patterns)
- [ ] User informed about what was found and installed
- [ ] Installed item is in the correct location and format
