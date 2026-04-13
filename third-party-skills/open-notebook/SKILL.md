---
title: Open Notebook - Local AI Research Assistant
id: open-notebook
version: 1.0.0
author: opencode-ecosystem
mcp_servers:
  open_notebook:
    command: "uvx"
    args: ["open-notebook-mcp"]
    env:
      OPEN_NOTEBOOK_URL: "http://localhost:5055"
---

# Trigger:
- "Crea un nuovo notebook"
- "Salva questa ricerca in open-notebook"
- "Aggiungi questo link ai miei appunti"
- "Cerca nei miei notebook"
- "Cosa ho salvato riguardo a..."
- "Genera un podcast dalla mia ricerca"
- "Usa open notebook"
- "Apri open notebook"

# Instructions

You are equipped to interact with **Open Notebook**, a privacy-focused, local alternative to Google's Notebook LM. You connect to it using the embedded MCP server (`open_notebook`).

### 1. Backend Prerequisite (Auto-Wake)
For the MCP server to work, the Open Notebook backend must be running. If you try to use an MCP tool and it fails with "Connection refused" or similar, **DO NOT STOP AND ASK THE USER**. 
Instead, automatically run the wake-up script to turn on Docker and the backend:
```bash
~/.config/opencode/skill/open-notebook/auto-wake.sh
```
Wait for the script to finish (it will say ✅ Open Notebook è pronto all'uso!), and then retry your MCP tool call.

### 2. Capabilities via MCP
You can manage the user's research seamlessly. Use the `skill_mcp` tool (with `mcp_name: "open_notebook"`) to access the following capabilities (Tool names follow standard MCP discovery, usually `list_notebooks`, `create_notebook`, `add_source`, `search`, etc.):

- **Notebooks:** Create and list notebooks to organize research projects.
- **Sources:** Add URLs, texts, or files into specific notebooks.
- **Notes & Summaries:** Create written insights from the sources.
- **Search:** Query the user's saved knowledge base (vector and full-text search).
- **Chat/Podcast:** Trigger AI conversations or podcast generations based on the context of a notebook.

### 3. Intent & Workflow
When the user asks to save information or start a research project:
1. First, check if a relevant notebook exists using the list notebooks tool.
2. If it doesn't exist, create a new notebook.
3. Add the user's provided URLs, PDFs, or text snippets as `sources` to that notebook.
4. Inform the user that the content is safely stored in their local Open Notebook and ready for chatting or podcast generation.

### 4. Direct tool usage examples:
If you need to search:
```json
{
  "mcp_name": "open_notebook",
  "tool_name": "search_content",
  "arguments": {
    "query": "intelligenza artificiale"
  }
}
```
*(Note: Use exact tool names provided by the MCP server discovery).*