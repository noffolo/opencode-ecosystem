---
name: pydantic-data-validator
description: "Create Pydantic schemas for scraper output with string normalization, type conversion, and deduplication."
triggers: valida output, schema dati, pulisci csv, formato json, pydantic, data validation, clean data
---
# Pydantic Data Validator

## When to Use
- "Valida output", "schema dati", "pulisci csv", "formato json"
- Any data cleaning/validation task

## Protocol

### 1. Schema Creation
Analyze raw scraper output and create a Pydantic BaseModel:
```python
from pydantic import BaseModel, field_validator, Field

class ScrapedItem(BaseModel):
    title: str
    price: float
    url: HttpUrl
```

### 2. Validators
- **String normalization**: trim whitespace, lowercase, strip special chars
- **Type conversion**: `"10.50€"` → `float(10.50)`, date parsing
- **Deduplication**: based on URL or ID field

### 3. Output
Return cleaned, validated objects ready for database insertion.
Report validation errors with field-level details.
