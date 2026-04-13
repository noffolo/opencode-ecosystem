---
name: docstring-auto-sync
description: "Analyze Python functions and generate Google Style docstrings, update README with params and usage examples."
triggers: documenta, spiega codice, readme, docstring, document code, auto-doc
---
# Docstring Auto-Sync

## When to Use
- "Documenta", "spiega codice", "readme"
- Code documentation tasks

## Protocol

### 1. Analyze Functions
Parse Python functions for:
- Parameters (names, types, defaults)
- Return types
- Exceptions raised
- Side effects

### 2. Generate Google Style Docstrings
```python
def scrape_url(url: str, timeout: int = 30) -> dict:
    """Scrape and parse content from a URL.

    Args:
        url: The target URL to scrape.
        timeout: Request timeout in seconds. Defaults to 30.

    Returns:
        dict: Parsed content with title, body, and metadata.

    Raises:
        requests.RequestException: If the request fails.
    """
```

### 3. README Update
Extract public API functions and add to README:
- Function signatures
- Parameter descriptions
- Usage examples

### 4. Agent Readability
Ensure all documentation is clear enough for other agents (Librarian, Oracle) to understand and use.
