---
name: codemem-integrity-check
description: "Verify CodeMEM MCP server connectivity, attempt auto-restart on failure, run test query to validate index readability."
triggers: codemem rotto, check memoria, mcp error, memory check, integrity check, MCP server
---
# CodeMEM Integrity Check

## When to Use
- "Codemem rotto", "check memoria", "mcp error"
- Memory system health verification

## Protocol

### 1. Connection Check
Verify MCP server connectivity:
- Check if the process is running
- Test the MCP endpoint
- Verify vector database accessibility

### 2. Auto-Recovery
If connection fails:
- Attempt to restart via `node` or `uv run`
- Wait 5 seconds for initialization
- Retry connection

### 3. Index Validation
Run a test query to verify the index is readable:
- Simple semantic search
- Verify response format
- Check embedding dimension consistency

### 4. Report
Output health status:
- ✅ All systems operational
- ⚠️ Degraded (some features limited)
- ❌ Offline (manual intervention needed)
