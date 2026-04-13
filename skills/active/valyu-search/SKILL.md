---
name: valyu-search
description: "Use Valyu (valyu.ai) to search the web, extract content from URLs, get AI-synthesized answers with citations, and run deep research tasks. Requires VALYU_API_KEY."
metadata:
  author: unicodeveloper
  source: https://github.com/openclaw/skills
  requires:
    bins: ["node"]
    env: ["VALYU_API_KEY"]
  primaryEnv: VALYU_API_KEY
  homepage: https://docs.valyu.ai
  category: search
  triggers: web search, research, news, fact-check, scrape URL, deep research, current events
---

# Valyu Search

Real-time web search, content extraction, AI-answered queries with citations, and async deep research — all via Valyu API. Compensates for frozen model knowledge with live data.

## When to Use

- "search the web", "web search", "look up", "find online", "find papers on..."
- "current news about...", "latest updates on..."
- "research [topic]", "what's happening with...", "deep research on..."
- "extract content from [URL]", "scrape this page", "get the text from..."
- "answer this with sources", "what does the research say about..."
- Fact-checking with citations needed
- Academic, medical, financial, or patent research

## Prerequisites

- API key from [valyu.ai](https://www.valyu.ai)
- Set `VALYU_API_KEY` environment variable

## Commands

### 1. Search API
```bash
node {baseDir}/scripts/valyu.mjs search web "<query>"
node {baseDir}/scripts/valyu.mjs search news "<query>"
node {baseDir}/scripts/valyu.mjs search finance "<query>"
node {baseDir}/scripts/valyu.mjs search paper "<query>"
node {baseDir}/scripts/valyu.mjs search patent "<query>"
```

**Search types**: `web`, `news`, `finance`, `paper`, `bio`, `patent`, `sec`, `economics`

### 2. Contents API
```bash
node {baseDir}/scripts/valyu.mjs contents "https://example.com" --summary
```

### 3. Answer API
```bash
node {baseDir}/scripts/valyu.mjs answer "What is quantum computing?" --fast
```

### 4. DeepResearch API
```bash
node {baseDir}/scripts/valyu.mjs deepresearch create "AI market trends" --model heavy --pdf
node {baseDir}/scripts/valyu.mjs deepresearch status <task-id>
```

| Mode | Duration | Use Case |
|------|----------|----------|
| `fast` | ~5 min | Quick answers |
| `standard` | ~10-20 min | Balanced research |
| `heavy` | ~90 min | In-depth analysis |

## Choosing the Right API

| Need | API |
|------|-----|
| Quick facts, current events | **Search** |
| Read/parse a specific URL | **Contents** |
| AI-synthesized answer with sources | **Answer** |
| In-depth analysis or report | **DeepResearch** |

## References

- [Valyu Docs](https://docs.valyu.ai)
- [Search API Reference](https://docs.valyu.ai/api-reference/endpoint/search)
- [Contents API Reference](https://docs.valyu.ai/api-reference/endpoint/contents)
- [Answer API Reference](https://docs.valyu.ai/api-reference/endpoint/answer)
- [DeepResearch Guide](https://docs.valyu.ai/guides/deepresearch)
