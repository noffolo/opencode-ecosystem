---
name: m2-docker-optimizer
description: "Create multi-stage Dockerfiles optimized for Apple Silicon arm64 with slim images, layer caching, and pyc suppression."
triggers: dockerfile, build immagine, container, arm64, Apple Silicon, docker optimize, M2
---
# M2 Docker Optimizer

## When to Use
- "Dockerfile", "build immagine", "container", "arm64"
- Docker optimization for Apple Silicon

## Protocol

### 1. Multi-Stage Build
```dockerfile
FROM python:3.12-slim AS builder
# Build dependencies

FROM python:3.12-slim AS runtime
# Copy only runtime artifacts
```

### 2. Apple Silicon Optimization
- Use `--platform=linux/arm64` explicitly
- Base images: `slim` variants only
- Layer caching: copy `requirements.txt` before source code

### 3. Environment Variables
```dockerfile
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
```

### 4. Size Optimization
- Remove apt cache after install
- Use `--no-install-recommends`
- Clean pip cache: `pip cache purge`
