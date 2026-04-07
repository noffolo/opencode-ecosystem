# An OpenCode Ecosystem 🤖

Welcome to the advanced OpenCode ecosystem. This *dotfiles*-style repository transforms a vanilla OpenCode installation into a robust multi-agent architecture, equipped with long-term memory (CodeMEM), hundreds of active skills, cross-platform OOM (Out-of-Memory) guards, and autonomous pre-commit linters (QA-Gate).

## 🌟 What is it?
By default, OpenCode is a powerful but "amnesiac" tool, where every session starts from scratch. This ecosystem integrates the `oh-my-openagent` and `codemem` plugins to orchestrate 11 specialized agents (mixing Cloud and local Ollama models) and implements a "Dark Matter" ecosystem based on Bash for absolute stability.

### ✨ Core Features (Aligned with guiding principles)
1. **AST Memory and Observations**: Automatically saves architectural decisions made in `memory/topics/` files, making them explorable for future agents (integrable with the CodeMEM vector database via the MCP Stdio protocol). Essential scripts: `memory-observor`, `kairos.sh`, `autodream.sh`, `ultraplan`.
2. **QA-Gate (Anti-Slop Barrier)**: No agent can declare a task "completed" without first passing the Bash linter check for empty `try/catch` blocks and abandoned `# TODO:` comments in git staged files.
3. **Co-Change Analyzer**: A Git-intelligence script that warns agents if the file they are about to modify historically depends on other invisible files (e.g., "fileA is modified with fileB 80% of the time").
4. **RAM Profiler Daemon (Cross-Platform)**: A crontab daemon (`ram-guard-cron.sh`) that executes a native fallback for macOS (`vm_stat` and `sysctl`) or Linux/WSL (`free -b`). It kills orphaned `ollama` background activity if memory drops below 15%, saving your machine from lethal OOM crashes.
5. **File System Locking (`.omo/locks/`)**: A robust pure Bash system to prevent background agents from simultaneously overwriting the same file and corrupting its AST.
6. **800+ Auto-activating Skills**: A vast library of Anthropic-style workflows ranging from visual engineering to red-teaming, documentation, and GitHub research via the `skill-auto-activator` system.

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
git clone https://github.com/your-username/opencode-ecosystem.git ~/opencode-ecosystem
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
