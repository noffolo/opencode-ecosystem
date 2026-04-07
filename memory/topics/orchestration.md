# Topic: Orchestration
## Facts
- oh-my-openagent gestisce 11 agents: oracle, explore, librarian, multimodal-looker, prometheus, metis, momus, atlas, sisyphus-junior, sisyphus, hephaestus
- Modelli remoti: `google/gemini-3.1-pro-preview` (oracle, multimodal-looker, sisyphus, deep category), `opencode/qwen3.6-plus-free` (prometheus, momus)
- Modelli locali: `ollama/qwen2.5-coder:7b` (explore, atlas, sisyphus-junior, hephaestus, unspecified-high), `ollama/mistral-nemo:12b` (metis, librarian, unspecified-low, writing), `ollama/deepseek-r1:14b` (ultrabrain, artistry), `ollama/gemma4:e4b` (visual-engineering), `ollama/qwen2.5-coder:3b` (quick)
- Concorrenza: default 3 task paralleli. Limiti provider: `google: 1`, `ollama: 2`. Limiti modelli locali specifici: `qwen2.5-coder:7b: 2`, `mistral-nemo:12b: 1`, `deepseek-r1:14b: 1`.

## File System Locking (Anti-Race Condition Protocol)
- Agents running in background (parallel mode) MUST acquire a lock before writing or editing a file.
- Acquire lock: `mkdir -p .omo/locks && set -C; echo $$ > ".omo/locks/$(basename $FILE).lock"` (use `set -C` to fail if file exists).
- If lock fails (exit code > 0), the agent MUST NOT edit the file. It must backoff or report busy.
- Release lock: `rm -f ".omo/locks/$(basename $FILE).lock"`.

## Last Updated
2026-04-07