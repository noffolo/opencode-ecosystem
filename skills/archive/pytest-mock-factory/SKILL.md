---
name: pytest-mock-factory
description: "Generate pytest unit tests with mock HTTP responses for scraper edge cases (empty tags, 404, malformed HTML)."
triggers: scrivi test, mock http, unit test, pytest, test scraper, mock response
---
# Pytest Mock Factory

## When to Use
- "Scrivi test", "mock http", "unit test"
- Testing scraper and data processing logic

## Protocol

### 1. Test Structure
```python
import pytest
from unittest.mock import patch, Mock
```

### 2. Mock HTTP Responses
Create realistic mock responses for target websites:
- Success (200) with expected HTML
- Empty response (200, no content)
- 404 Not Found
- 429 Rate Limited
- Malformed HTML

### 3. Edge Case Coverage
- Empty tags / missing elements
- Unexpected data types
- Unicode/special characters
- Pagination boundaries
- Timeout scenarios

### 4. Assertions
- Parser output matches expected schema
- Error handling returns graceful failures
- No unhandled exceptions
