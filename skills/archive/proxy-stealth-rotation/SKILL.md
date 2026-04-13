---
name: proxy-stealth-rotation
description: "Configure Playwright/httpx middleware with rotating headers, user-agent randomization, jitter delays, and auto-proxy switching on blocks."
triggers: 403 forbidden, captcha, evita ban, user-agent, proxy rotation, stealth mode, anti-bot
---
# Proxy & Stealth Rotation

## When to Use
- "403 Forbidden", "captcha", "evita ban", "user-agent"
- Anti-bot detection bypass

## Protocol

### 1. Header Rotation Middleware
Configure middleware (Playwright or httpx) that rotates headers on every request:
- Random User-Agent from mobile/desktop pool
- Rotating Accept-Language, Accept-Encoding
- Varying Connection and Cache-Control headers

### 2. Session Management
- Persistent cookies for logged-in sessions
- Isolated cookies for anonymous browsing
- Cookie jar rotation every N requests

### 3. Human-like Timing
- Random jitter delay between 1s and 5s
- Exponential backoff on rate limits
- Simulated mouse movements (Playwright)

### 4. Auto-Recovery
On block detection (403/captcha):
- Switch to next proxy in pool
- Rotate entire header set
- Log the incident for pattern analysis
