---
name: semantic-bridge-linker
description: "Find semantic connections between scraped data and existing Aleph nodes, generate link proposals with reasoning."
triggers: trova connessioni, link semantico, cross-reference, connect nodes, semantic link, knowledge bridge
---
# Semantic Bridge Linker

## When to Use
- "Trova connessioni", "link semantico", "cross-reference"
- Connecting knowledge across domains

## Protocol

### 1. Cross-Reference Scan
Compare scraped/extracted data against existing Aleph nodes.
Look for:
- Shared entities (same person, project, technology)
- Temporal connections (same time period)
- Causal relationships (A caused B)
- Thematic overlap (same domain, different sub-topic)

### 2. Link Proposal
For each connection found:
- **Source node** → **Target node**
- **Relationship type**: supports, contradicts, extends, references
- **Semantic reasoning**: Why these nodes are connected

### 3. Weight Update
Adjust connection weights based on:
- Context relevance (current task focus)
- Temporal freshness
- Source reliability

### 4. Output
List of proposed links with confidence scores.
