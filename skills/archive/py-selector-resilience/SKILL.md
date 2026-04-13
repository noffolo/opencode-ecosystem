---
name: py-selector-resilience
description: "Generate 3 fallback selector strategies (attribute-based, hierarchy-based, text-based) when CSS/XPath selectors fail during web scraping."
triggers: selettore rotto, cambio DOM, fix scraper, estrazione fallita, selector broken, DOM changed
---
# Python Selector Resilience

## When to Use
- "Selettore rotto", "cambio DOM", "fix scraper", "estrazione fallita"
- Any web scraping selector failure

## Protocol

### 1. Analyze the HTML Tree
When the primary selector (CSS/XPath) fails, parse the provided HTML to understand the current DOM structure.

### 2. Generate 3 Fallback Strategies

| Strategy | Approach | Example |
|----------|----------|---------|
| **Attribute-based** | Partial attribute matching | `[class*="product-title"]` |
| **Hierarchy-based** | Parent/sibling traversal | `parent > .target` or `sibling + .target` |
| **Text-based** | Anchor text matching | `//a[contains(text(), "Buy")]` |

### 3. Test & Save
- Test each fallback against the current HTML
- Save the winning strategy to CodeMEM to prevent future crashes on the same domain
