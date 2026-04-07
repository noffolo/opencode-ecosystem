# An OpenCode Ecosystem 🤖

Welcome to the advanced OpenCode ecosystem. This *dotfiles*-style repository transforms a vanilla OpenCode installation into a robust multi-agent architecture, equipped with long-term memory (CodeMEM), hundreds of active skills, cross-platform OOM (Out-of-Memory) guards, and autonomous pre-commit linters (QA-Gate).

## 🌟 What is it?
By default, OpenCode is a powerful but "amnesiac" tool, where every session starts from scratch. This ecosystem integrates the `oh-my-openagent` and `codemem` plugins to orchestrate 11 specialized agents (mixing Cloud and local Ollama models) and implements a "Dark Matter" ecosystem based on Bash for absolute stability.

---

## 🧠 The Memory Flow (Cognitive Architecture)
This ecosystem never forgets. Instead of isolated sessions, it uses a 4-stage background cognitive flow:

1. **`memory-observor` (The Scribe)**: While you work, this skill captures architectural decisions, bugs, and code patterns, saving them to a raw `observations.log`.
2. **`kairos.sh` (The Scout)**: Running silently every 30 minutes via cron, Kairos scans your git staging area for unresolved `# TODO:` comments, empty `catch` blocks, and prepares conventional commit summaries. It feeds its findings back into the raw log.
3. **`autodream.sh` (The Consolidator)**: When OpenCode is idle, this daemon wakes up, reads the raw logs, verifies that the referenced files still exist, and consolidates them into topic-specific Markdown files (`topics/*.md`).
4. **`strict_write.py` & `memory-index-reader` (The Librarian)**: The final step updates the master `MEMORY.md` index file, ensuring every pointer is strictly validated. The next time you open a project, OpenCode reads this file and instantly knows the entire history of your architecture.

---

## 🕵️ Multi-Agent Routing (The Brains)
You don't just talk to one LLM. OhMyOpenCode routes your requests to 11 specialized sub-agents based on the task domain:

- **`oracle` (Google Gemini 3.1 Pro)**: The heavy lifter. Used for complex architecture design, security reviews, and root-cause debugging. It sits in the cloud and requires zero local RAM.
- **`explore` (Local Qwen 2.5 Coder 7B)**: The codebase scout. It runs context-aware AST greps locally to map out your project structure without sending your code to the cloud.
- **`librarian` (Local Mistral Nemo 12B)**: The researcher. When you mention an external library, it searches remote GitHub repos and official docs to bring back exact implementation patterns.
- **`ultrabrain` (Local Deepseek R1 14B)**: The strategist. Used exclusively for genuinely hard, logic-heavy tasks and deep planning (via the `/ultraplan` command).

---

## ⚔️ The Arsenal (Commands & Skills)
The true power of this repository lies in its `skill/` directory. You have over 20 active, highly specialized workflows at your fingertips. 

### Planning & Architecture
- **`/ultraplan`**: Deep planning protocol. Generates a massive 5-file architecture strategy (`overview.md`, `plan.md`, `hypotheses/*.md`, `tasks/*.md`, `state.json`) exploring at least 3 different technical approaches before writing any code.
- **`/code-forge-plan`**: Breaks down feature specs into granular TDD steps and progress tracking.
- **`/context-compressor`**: Analyzes open files and creates a lightweight `CONTEXT_MAP.md` (exports, env vars, state) to save tokens and RAM.
- **`/dba-architect`**: Database expert that generates optimized SQL, Prisma/TypeORM migrations, and analyzes slow queries with strict security constraints.

### Quality & Debugging
- **`/qa-gate`**: The Anti-Slop Barrier. Runs before committing. If your staged files contain empty `catch(e) {}` blocks, `console.log` leftovers, or orphaned `# TODO:` comments, it blocks the completion and forces the agent to fix them.
- **`/code-forge-fix`**: Surgical debugging. Traces upstream root-causes, confirms document updates, and applies TDD fixes (supports `--repos` for parallel bug fixing across microservices).
- **`/workaholic-auto-review`**: Automatically reviews the last output for hallucinations and syntax errors, auto-correcting issues before releasing the code.
- **`/security-red-team`**: An adversarial ghost reviewer. It doesn't fix your code; it generates malicious inputs and writes failing test cases to *prove* your vulnerabilities exist.

### Code Mastery
- **`/git-atomic-committer`**: Analyzes massive git diffs and automatically splits them into atomic, logical Conventional Commits linked to task IDs.
- **`/code-translator`**: Translates code across languages (e.g., Python to TypeScript) using In-Context Learning from a project demonstration file to perfectly mimic your local architectural style.
- **`/benchmark-profiler`**: Compares code performance between versions using `hyperfine` or `pprof`, generating detailed before/after metric reports.
- **`/farmage-golang-pro`**: Specialized Go engineer enforcing idiomatic patterns (goroutines, generics, gRPC, strict error handling).

### Ecosystem Expansion
- **`/skill-auto-activator`**: Automatically discovers and activates archived skills that match your current task without user intervention.
- **`/github-research-installer`**: Searches the global GitHub API for new OpenCode skills, tools, and code patterns, downloading and installing them on the fly.
- **`/meta-skill-to-craft-skills`**: Analyzes your workflow and writes *new* `.md` skills following the standardized schema, effectively making the ecosystem self-replicating.

---

### ✨ Core Features (Platform & Stability)
1. **Co-Change Analyzer**: A Git-intelligence script (`co-change-analyzer.sh`) that warns agents if the file they are about to modify historically depends on other invisible files (e.g., "fileA is modified with fileB 80% of the time").
2. **RAM Profiler Daemon (Cross-Platform)**: A crontab daemon (`ram-guard-cron.sh`) that executes a native fallback for macOS (`vm_stat` and `sysctl`) or Linux/WSL (`free -b`). It kills orphaned `ollama` background activity if memory drops below 15%, saving your machine from lethal OOM crashes.
3. **File System Locking (`.omo/locks/`)**: A robust pure Bash system to prevent background agents from simultaneously overwriting the same file and corrupting its AST.

---

## 💻 Requirements (Hardware and Software)

### Hardware Requirements
- **RAM**: At least **16 GB of unified/system RAM** (necessary to sustain local Ollama models and orchestration). For smooth performance, 32GB is recommended.
- **Disk Space**: Approximately **20 GB free** (primarily for model weights like `deepseek-r1:14b` and `mistral-nemo:12b`).
- **Operating System**: macOS (Apple Silicon recommended), Linux, or Windows (via **WSL2** / Git Bash).

### Software Requirements (Core Toolchain)
Before running the installer, ensure the following are installed on your system:
- `opencode` (CLI)
- `bun` (Runtime required for oh-my-openagent)
- `node` (Node.js 18+, for the ES Module framework of RAM Guard and MCP)
- `pnpm` (Package manager for the CodeMEM monorepo)
- `ollama` (With local models pre-downloaded, e.g., `ollama pull qwen2.5-coder:7b`)
- `git`

---

## 🛠️ Automated Installation (Cross-Platform)

The ecosystem includes a robust installer that works on macOS and Linux (including Windows WSL2).
The installer handles:
1. Autodiscovery and **downloading of external dependencies** (such as cloning and auto-building `oh-my-openagent` in `~/.config/opencode/plugins/`).
2. Scaffolding the `ram-guard` ESM plugin.
3. Symlinking the configurations, your `memory/` directory, and your `skill/` directory.

```bash
git clone https://github.com/noffolo/opencode-ecosystem.git ~/opencode-ecosystem
cd ~/opencode-ecosystem
./install.sh
```

### Post-Installation (IMPORTANT)
1. **API Keys**: The script will create a clean template in `~/.config/opencode/opencode.json`. **You must manually open it** and insert your real tokens (e.g., for Gemini or Anthropic).
2. **CodeMEM Repo**: Because CodeMEM might be a private or closed-source repository, the installer creates a placeholder. If you have access to the real source code, ensure it is placed in `~/.config/opencode/plugins/codemem` and run `pnpm install && pnpm exec tsc --build`.

---

## ⚠️ Iron Laws of the Architecture
If you modify this ecosystem in the future, remember these documented rules:
- **Never** force models that are not downloaded into `oh-my-openagent.json`; the orchestrator will crash on spawn. Always use `ollama list` first.
- **Never** use `npm install` for CodeMEM: it is a monorepo protected by `pnpm` (workspace).
- RAM Guard is an **ES Module**: if you try to import it with `require()`, it will fail irreparably. (The installer already initializes it with `"type": "module"`).
- Do not debug CodeMEM (MCP Stdio Server) with a bare shell, as it will auto-exit. Test it only via formatted JSON-RPC payloads.

---

## 🏆 Credits and Original Sources

This ecosystem is an aggregate (chimera) of exceptional open-source plugins and modules, woven together with custom logic:

- **Orchestrator Core (`oh-my-openagent`)**: Originally developed and maintained by [@code-yeongyu](https://github.com/code-yeongyu/oh-my-openagent). Thanks to the creator for the asynchronous agent architecture (Prometheus, Sisyphus, Metis).
- **CodeMEM (Long-Term Memory)**: Inspired by semantic and contextual memory implementations via the Model Context Protocol (MCP) for tool-calling and AST vector tracking.
- **Anthropic-Style Skills**: The concept of Markdown-format skills with YAML frontmatter draws inspiration from the prompting and knowledge retrieval best practices of Anthropic labs.
- **Swarm Assimilation (Dark Matter)**: Native architectures inspired by the rigid pre-commit workflows of Swarm frameworks, adapted into pure Bash (e.g., `qa-gate.sh` and `co-change-analyzer.sh`) to avoid causing bottlenecks in the underlying Javascript infrastructure.

---
Happy hyper-productive coding! 🚀
