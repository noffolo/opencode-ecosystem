# LLM Orchestration Anti-Patterns & Pragmatic Architecture

**Date Sedimented:** 2026-04-06
**Source Context:** Analysis of `opencode-swarm` vs. OhMyOpenCode (OMO) constraints.

This document contains critical architectural laws for designing LLM workflows, derived from failure testing "ambitious" multi-agent plans. **Always consult these principles before designing complex agentic systems.**

## 1. The "Zero-Trust" Execution Law
- **Fallacy:** Believing an LLM will consistently follow a prompt instruction like *"You MUST run tests before completing a task"* in a long, complex context window. (The "Lost in the Middle" syndrome).
- **Pragmatic Reality:** Prompt-based moral gates fail. 
- **Design Rule:** Enforce constraints physically outside the LLM's control. Use **Filesystem Contracts** (e.g., Git pre-commit hooks, mandatory lockfiles) or **Hard API Rejections** (Middleware that crashes if preconditions aren't met). The LLM must be physically blocked from proceeding if it hallucinates completion.

## 2. The Asynchronous Delusion
- **Fallacy:** Designing architectures where an LLM agent spawns or manages long-running asynchronous processes (like 30-second heartbeats or daemon monitoring) between tool calls.
- **Pragmatic Reality:** LLM execution is stateless, synchronous, and ephemeral. Tool calls block, and agents sleep between turns.
- **Design Rule:** Offload all time-based, asynchronous, or state-monitoring tasks to **external host daemons** (e.g., `cron`, `tmux`, `systemd`, or independent bash loops). The LLM only reads/writes static state files (e.g., updating a timestamp in a file that a daemon reads).

## 3. Context Compaction & Baseline-Relative QA
- **Fallacy:** Feeding raw, unbounded data (like a 10,000-line JSONL ledger, full `git log` history, or 500 legacy lint warnings) into the context window so the LLM has "complete information".
- **Pragmatic Reality:** Token bloat destroys instruction adherence and skyrockets latency/costs. 
- **Design Rule (QA):** Quality gates must be **Baseline-Relative**. Only evaluate the *delta* (e.g., "Did warnings increase?") and scan strictly within the `git diff` boundaries. Never force an agent to fix legacy slop to pass a gate.
- **Design Rule (State):** Never read raw ledgers. Always use deterministic scripts (Bash/Python) to parse logs and output a **Compacted Summary** (e.g., "Tasks remaining: 2. Last event: Error on line 42") before injecting it into the context window.

## 4. The Brittle Parsing Trap
- **Fallacy:** Using LLMs or raw Bash (`grep`/`awk`) to parse complex, unstructured data formats like unified `git diffs` or ASTs.
- **Pragmatic Reality:** Whitespace changes, context lines, and file renames break regex instantly.
- **Design Rule:** Use robust, deterministic programming languages and standard libraries (e.g., Python's `unidiff`, `tree-sitter`, or `lsp_symbols`) to extract exact line numbers and structural data before feeding it to the LLM or a QA gate.