---
name: browser-fingerprint-emul
description: "Mask navigator.webdriver, falsify hardware params (CPU cores, RAM, screen resolution), disable WebGL fingerprinting in Playwright."
triggers: bypass bot detection, headless check, stealth mode, fingerprint, webdriver mask, anti-detect
---
# Browser Fingerprint Emulator

## When to Use
- "Bypass bot detection", "headless check", "stealth mode"
- Anti-bot evasion

## Protocol

### 1. WebDriver Masking
Inject scripts before page load:
```javascript
Object.defineProperty(navigator, 'webdriver', { get: () => undefined });
```

### 2. Hardware Falsification
- CPU cores: set to 8
- System memory: set to 16GB (`navigator.deviceMemory`)
- Screen resolution: 1920x1080, 24-bit color depth
- Platform: "MacIntel"

### 3. WebGL Protection
- Disable WebGL fingerprinting via canvas noise
- Override `getParameter` for renderer strings
- Block font enumeration

### 4. Additional Evasions
- Override `chrome.runtime` presence
- Fake timezone to user's locale
- Randomize canvas fingerprint per session
