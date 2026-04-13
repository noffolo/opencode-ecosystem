---
name: async-throttle-controller
description: "Manage async concurrency with asyncio.Semaphore, optimize for Mac M2 Pro (15 concurrent tasks), exponential backoff on 503/429."
triggers: velocizza scraper, troppe connessioni, limita task, async concurrency, semaphore, rate limit, backoff
---
# Async Throttle Controller

## When to Use
- "Velocizza scraper", "troppe connessioni", "limita task"
- Async concurrency management

## Protocol

### 1. Semaphore-Based Concurrency
```python
import asyncio
semaphore = asyncio.Semaphore(15)  # Mac M2 Pro optimized
```

### 2. Dynamic Task Optimization
- Default: 15 concurrent tasks (Mac M2 Pro)
- Scale down if RAM < 4GB free
- Scale up to 25 if CPU < 50% and RAM > 8GB free

### 3. Exponential Backoff
On 503/429 errors:
- Retry with backoff: `delay = base_delay * (2 ** attempt)`
- Max retries: 5
- Jitter: `delay += random.uniform(0, 1)`

### 4. Monitoring
Track active connections, error rates, and memory usage.
Alert when approaching system limits.
