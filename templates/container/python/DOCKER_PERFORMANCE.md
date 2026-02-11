# Docker Build Performance - Agentic Dev Velocity
# Guide to achieving sub-30s Docker builds with advanced caching

## Performance Matrix

| Strategy | Cold Build | Warm Build | Cache Size |
|----------|------------|------------|------------|
| No cache | ~60s | ~60s | - |
| BuildKit only | ~50s | ~20s | ~100MB |
| + GHA cache | ~50s | **< 10s** | ~500MB |
| + Layer mounts | ~50s | **< 5s** | ~500MB |
| + Registry cache | ~40s | **< 5s** | ~1GB |

## Cache Strategies

### 1. GitHub Actions Cache (GHA)

```yaml
- name: Build with GHA cache
  uses: docker/build-push-action@v6
  with:
    cache-from: type=gha,scope=docker
    cache-to: type=gha,mode=max,scope=docker
```

**Benefits:**
- ~10x faster warm builds
- Shared across workflow runs
- Automatic cleanup

### 2. Registry Cache

```yaml
- name: Build with registry cache
  uses: docker/build-push-action@v6
  with:
    cache-from: type=registry,ref=ghcr.io/user/repo:cache
    cache-to: type=registry,ref=ghcr.io/user/repo:cache,mode=max
```

**Benefits:**
- Persistent across branches
- Shareable between repositories
- Works offline after first push

### 3. Inline Cache

```dockerfile
# syntax=docker/dockerfile:1.6
FROM python:3.13-slim AS builder
ARG BUILDKIT_INLINE_CACHE=1
```

```yaml
- name: Build with inline cache
  uses: docker/build-push-action@v6
  with:
    build-args: BUILDKIT_INLINE_CACHE=1
```

**Benefits:**
- No external cache storage needed
- Self-contained image
- Works with any registry

### 4. Cache Mounts

```dockerfile
RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update && apt-get install -y gcc
```

```dockerfile
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install uv
```

**Benefits:**
- Persists package manager caches
- Dramatically speeds up dependency installation
- Works across all builds

## Layer Optimization

### Optimal Layer Order

```dockerfile
# 1. System dependencies (rarely change)
RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update && apt-get install -y gcc

# 2. Language dependencies (change occasionally)
COPY pyproject.toml uv.lock ./
RUN uv pip install --system --no-dev -r pyproject.toml

# 3. Source code (changes frequently)
COPY src/ ./src/
```

### Layer Invalidation

```dockerfile
# Bad: Invalidates all layers on every copy
COPY . .
RUN pip install -r requirements.txt

# Good: Cache dependency layer
COPY requirements.txt ./
RUN pip install -r requirements.txt
COPY . .
```

## Multi-Stage Build Optimization

```dockerfile
# syntax=docker/dockerfile:1.6

# Builder stage - heavy lifting
FROM python:3.13-slim AS builder
COPY requirements.txt ./
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --no-cache-dir -r requirements.txt

# Development stage - fast rebuilds
FROM python:3.13-slim AS development
COPY --from=builder /root/.cache/pip /root/.cache/pip
COPY src/ ./src/
CMD ["python", "src/main.py"]

# Production stage - minimal image
FROM python:3.13-slim AS production
COPY --from=builder /root/.cache/pip /root/.cache/pip
COPY --from=builder /app/dist/app ./app
CMD ["./app"]
```

## CI Pipeline Optimization

### Parallel Jobs

```yaml
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: hadolint/hadolint-action@v3
        with:
          dockerfile: Dockerfile
  
  build:
    runs-on: ubuntu-latest
    needs: lint
    steps:
      - uses: docker/build-push-action@v6
        with:
          cache-from: type=gha,scope=docker
          cache-to: type=gha,mode=max,scope=docker
```

### Cache Priority

1. **GHA cache** - Fastest for repeated builds
2. **Registry cache** - Best for cross-branch sharing
3. **Inline cache** - Simplest for single-image projects

## Local Development Commands

```bash
# Build with BuildKit (default in Docker 23+)
docker build -t app:dev .

# Build with cache mounts
docker build --mount=type=cache,target=/root/.cache/pip -t app:dev .

# Buildx with caching
docker buildx build --push \
  --cache-from type=gha,scope=docker \
  --cache-to type=gha,mode=max,scope=docker \
  -t app:latest .

# Inspect cache
docker buildx du

# Clear build cache
docker buildx prune --all
```

## Performance Targets

| Stage | Target | With Optimizations |
|-------|--------|-------------------|
| Docker lint | < 5s | ~3s |
| Docker build (dev) | < 30s | **< 10s** |
| Docker build (prod) | < 60s | **< 15s** |
| Full CI pipeline | < 2min | **< 1min** |

## Troubleshooting

### Cache Misses

```bash
# Check what's being rebuilt
docker buildx build --progress=plain .

# Clear and rebuild
docker buildx prune --all
docker buildx build --no-cache .
```

### Large Cache

```bash
# Check cache size
docker buildx du

# Prune unused cache
docker buildx prune --keep-storage 1GB
```

### Slow Builds

```bash
# Profile build time
docker buildx build --profiler results=build.txt .

# Check layer sizes
docker history <image>
```

## Best Practices Summary

1. **Use BuildKit** - Enable with `# syntax=docker/dockerfile:1.6`
2. **Cache mount dependencies** - apt, pip, uv caches
3. **Order layers** - Dependencies before source
4. **Multi-stage builds** - Separate builder from runtime
5. **GHA cache** - Use for CI builds
6. **Registry cache** - Use for cross-branch sharing
7. **Inline cache** - Use for single-image projects
8. **Parallel jobs** - Lint and build in parallel
9. **Cache isolation** - Use scopes for different targets
10. **Monitor cache** - Use `docker buildx du` regularly
