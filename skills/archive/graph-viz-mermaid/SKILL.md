---
name: graph-viz-mermaid
description: "Generate Mermaid.js graph TD visualizations of knowledge graphs with color-coded nodes for raw data vs synthesized nodes."
triggers: mostra grafo, visualizza aleph, disegna mappa, mermaid, graph visualization, knowledge map
---
# Graph Viz Mermaid

## When to Use
- "Mostra grafo", "visualizza aleph", "disegna mappa"
- Knowledge graph visualization

## Protocol

### 1. Generate Mermaid Graph
```mermaid
graph TD
    A[Parent Node] --> B[Child Node]
    B --> C[Related Node]
```

### 2. Color Coding
- 🔵 **Blue nodes**: Raw data (from Scraper)
- 🟢 **Green nodes**: Synthesized knowledge (Aleph Core)
- 🟡 **Yellow nodes**: Pending validation
- 🔴 **Red nodes**: Conflicting/outdated info

### 3. Relationship Labels
Label all edges with descriptive relationships:
- `-->|extends|`
- `-->|contradicts|`
- `-->|references|`
- `-->|depends_on|`

### 4. Output
Complete Mermaid.js code ready for rendering.
Include a legend explaining color scheme.
