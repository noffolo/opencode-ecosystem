---
name: atomic-thought-distiller
description: "Reduce complex texts to atomic knowledge units (max 280 chars) with 3-5 hierarchical tags, formatted for vector DB injection."
triggers: riassumi per aleph, sintesi atomica, nota breve, distill knowledge, atomic note, summarize
---
# Atomic Thought Distiller

## When to Use
- "Riassumi per aleph", "sintesi atomica", "nota breve"
- Knowledge distillation

## Protocol

### 1. Extract Core Idea
Reduce complex text to its essential meaning.
Maximum 280 characters per atom.

### 2. Hierarchical Tagging
Extract 3-5 tags in hierarchical format:
```
#Python -> #Scraping -> #Bypass
#AI -> #LLM -> #ContextWindow
```

### 3. Vector DB Format
Format output for direct injection:
```json
{
  "content": "atom text",
  "tags": ["#Python", "#Scraping", "#Bypass"],
  "source": "original reference",
  "timestamp": "ISO-8601"
}
```

### 4. Quality Check
- Is the atom self-contained? (understandable without context)
- Are tags specific enough? (not too broad)
- Is the source traceable?
