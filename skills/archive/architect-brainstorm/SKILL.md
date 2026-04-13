---
name: architect-brainstorm
description: "Compare 3 architectural alternatives (Lean, Scalable, Experimental) with RAM impact analysis for Mac M2. Use when choosing between technologies or restructuring complex modules."
triggers: analizza architettura, scelta tech, refactoring pesante, architecture decision, tech comparison
---
# Architect Brainstorming

## When to Use
- Choosing between two or more technologies
- Restructuring a complex module
- Major architectural decisions

## Protocol

### 1. Analyze Existing Code
Query CodeMEM to identify bottlenecks, coupling issues, and performance constraints in the current codebase.

### 2. Propose 3 Alternatives

| Approach | Description | Trade-off |
|----------|-------------|-----------|
| **Lean** | Fastest to implement, lowest technical debt | May not scale indefinitely |
| **Scalable** | 2026 best practice, maximum performance | Higher initial complexity |
| **Experimental** | Leverages latest framework features (e.g., React Server Components) | Bleeding edge, potential instability |

### 3. RAM Impact Analysis
Calculate memory impact on Mac M2 (16GB):
- Estimate peak memory usage per approach
- Flag potential memory leak patterns
- Recommend garbage collection strategies

### 4. Output
Comparative table: Complexity vs Maintainability vs Performance.
Include explicit RAM footprint estimates.
