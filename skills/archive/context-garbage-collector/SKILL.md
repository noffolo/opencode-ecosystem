---
name: context-garbage-collector
description: "Unload inactive Ollama models, suggest Python gc.collect(), warn when free RAM drops below 2GB safety threshold."
triggers: pulisci ram, ollama lento, free memory, garbage collect, memory cleanup, unload model
---
# Context Garbage Collector

## When to Use
- "Pulisci ram", "ollama lento", "free memory"
- Memory optimization

## Protocol

### 1. Ollama Model Management
- List loaded models: `ollama list`
- Unload inactive models: `curl -X POST http://localhost:11434/api/generate -d '{"model": "model_name", "keep_alive": 0}'`
- Keep only the currently active model loaded

### 2. Python Memory Cleanup
```python
import gc
del large_variable
gc.collect()
```

### 3. RAM Threshold Monitoring
- Warning at < 4GB free
- Critical at < 2GB free
- Emergency: suggest killing non-essential processes

### 4. Docker Cleanup
```bash
docker system prune -f
docker image prune -f
```

### 5. Report
Output current memory state and actions taken.
