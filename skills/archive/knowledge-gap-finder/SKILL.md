---
name: knowledge-gap-finder
description: "Scan Aleph nodes to identify isolated silos and missing critical information, suggest new scraping/research tasks."
triggers: cosa manca, analisi aleph, punti ciechi, knowledge gap, missing info, blind spots
---
# Knowledge Gap Finder

## When to Use
- "Cosa manca?", "analisi aleph", "punti ciechi"
- Knowledge completeness analysis

## Protocol

### 1. Scan Aleph Nodes
Query CodeMEM for all nodes related to the target topic.

### 2. Identify Gaps
- **Silos**: Isolated nodes with no connections
- **Missing links**: Nodes that should be connected but aren't
- **Incomplete chains**: Partial information flows
- **Stale data**: Nodes not updated in >30 days

### 3. Suggest Actions
For each gap found:
- Recommend a specific scraping or research task
- Prioritize by impact (critical vs nice-to-have)
- Estimate effort (quick win vs deep dive)

### 4. Output
Gap analysis report with prioritized action items.
