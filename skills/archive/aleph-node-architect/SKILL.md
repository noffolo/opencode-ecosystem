---
name: aleph-node-architect
description: "Analyze input to identify central entities, suggest graph placement (parent/related nodes), check CodeMEM for duplicates."
triggers: nuovo nodo, struttura aleph, collega pensiero, mappa concettuale, knowledge graph, entity node
---
# Aleph Node Architect

## When to Use
- "Nuovo nodo", "struttura aleph", "collega pensiero", "mappa concettuale"
- Adding knowledge to the Aleph graph

## Protocol

### 1. Identify Central Entity
Analyze input and extract the primary entity:
- Person, Project, Idea, Technology, Concept

### 2. Suggest Graph Placement
- **Parent Node**: Which category does this belong to?
- **Related Nodes**: What lateral connections exist?
- **Child Nodes**: What sub-concepts does this contain?

### 3. Duplicate Check
Query CodeMEM to verify no similar node already exists.
If found, merge instead of creating a duplicate.

### 4. Output
Node structure with:
- Entity name and type
- Parent category
- Suggested connections
- Confidence score for placement
