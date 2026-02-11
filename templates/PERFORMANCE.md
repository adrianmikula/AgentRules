# Agentic Dev Velocity Templates - Performance Matrix

## Performance Grid

| Language | Runtime | Lint | Compile | Fast Test | CI Signal | Docker Warm Build | Docker Lint | Hot Reload | Installer |
|----------|---------|------|---------|-----------|-----------|--------------------|-------------|------------|-----------|
| **Python** | uv + FastAPI | 0.5s | N/A | **0.07s** | ~2s | **< 10s** | ~3s | < 1s | AppImage: 20s / DEB: 5s |
| **React** | Vite + Node | 1s | 3s | 2.6s | ~10s | **< 10s** | ~3s | < 1s | N/A |
| **Go** | Go 1.21 | 0.5s | 2s | **0.8s** | ~5s | **< 5s** | ~3s | < 1s | AppImage: 30s |
| **Node.js** | Node 20 + pnpm | 1s | N/A | 3s | ~10s | **< 5s** | ~3s | < 1s | N/A |
| **Java** | Spring Boot 3 | 5s | 15s | 15s | ~60s | **< 15s** | ~3s | < 5s | AppImage: 120s |
| **Java** | Tomcat 10 | 5s | 15s | 15s | ~60s | **< 15s** | ~3s | < 5s | N/A |
| **Java** | CRaC 21 (Linux) | 5s | 15s | 4s | ~60s | **< 15s** | ~3s | **< 100ms** | N/A |

## KPI Definitions

| KPI | Definition | Target |
|-----|-----------|--------|
| **Lint** | Static analysis check | < 2s |
| **Compile** | Source → Binary | < 30s |
| **Fast Test** | Unit tests only (no framework boot) | < 5s |
| **CI Signal** | Lint + Compile + Fast Test in CI | < 60s |
| **Docker Warm Build** | Multi-stage build with GHA cache | < 30s |
| **Docker Lint** | Dockerfile validation | < 5s |
| **Hot Reload** | Live code reloading | < 2s |
| **Installer** | Platform-specific package build | < 120s |

## Performance Tiers

### Tier 1: Sub-10s Feedback (Best for Agents)

| Template | Signal | Fast Test | CI Signal |
|----------|--------|-----------|-----------|
| Python | 0.5s + 0.07s | **0.07s** | ~2s |
| Go | 0.5s + 2s | **0.8s** | ~5s |

### Tier 2: Sub-60s Feedback

| Template | Compile | Recompile | Fast Test | Hot Reload | CI Signal |
|----------|---------|-----------|-----------|------------|-----------|
| Java Spring | 15s | < 5s | 15s | < 5s | ~60s |
| Java Tomcat | 15s | < 5s | 15s | < 5s | ~60s |
| React | 3s | < 1s | 2.6s | **< 1s** | ~10s |
| Node.js | N/A | N/A | 3s | **< 1s** | ~10s |

### Tier 3: Special Purpose

| Template | Startup | Cold Start | Hot Reload | Use Case |
|----------|---------|------------|------------|----------|
| Java CRaC | 15s compile | **< 100ms** (restored) | **< 100ms** | Serverless |
| Python FastAPI | 2s | N/A | **< 1s** | Web APIs |
| React Vite | 3s | N/A | **< 1s** | Frontend |
| Go Echo | 1s | N/A | **< 1s** | APIs |
| Node Express | 1s | N/A | **< 1s** | APIs |

## Docker Performance Matrix

| Template | Docker Warm Build | Docker Lint | Cache Size |
|----------|--------------------|-------------|------------|
| Python | **< 10s** | ~3s | ~500MB |
| Java Spring | **< 15s** | ~3s | ~1GB |
| Java Tomcat | **< 15s** | ~3s | ~1GB |
| Go | **< 5s** | ~3s | ~300MB |
| Node.js | **< 5s** | ~3s | ~300MB |

## Docker Cache Strategy Comparison

| Strategy | Build Time (Cold) | Build Time (Warm) | Cache Persistence | Setup |
|----------|-------------------|-------------------|-------------------|-------|
| No cache | ~60s | ~60s | - | None |
| BuildKit only | ~50s | ~20s | Session | Built-in |
| GHA cache | ~50s | **< 10s** | GitHub | `cache-from: type=gha` |
| Registry cache | ~40s | **< 10s** | Registry | `cache-from: type=registry` |
| Inline cache | ~50s | ~15s | Image | `BUILDKIT_INLINE_CACHE=1` |

## Advanced Docker Optimizations

| Optimization | Benefit | Implementation |
|--------------|---------|---------------|
| Cache mounts | ~5-10x dependency install | `--mount=type=cache,target=/var/cache/apt` |
| GHA cache | ~6x faster warm builds | `type=gha,scope=docker` |
| Registry cache | Cross-branch sharing | `type=registry,ref=...` |
| Inline cache | Self-contained | `BUILDKIT_INLINE_CACHE=1` |
| Layer ordering | Better cache hits | Dependencies → Source |
| Multi-stage | Smaller images | Builder → Dev → Prod |
| Parallel jobs | Faster CI | Lint + Build in parallel |

## Docker Build Targets

| Command | Description | Target |
|---------|-------------|--------|
| `docker-lint` | Dockerfile validation | < 5s |
| `docker-build` | Warm build with GHA cache | < 30s |
| `docker-rebuild` | Cold build without cache | < 60s |

## Installer Performance

| Template | AppImage | DEB | RPM | Size |
|----------|----------|-----|-----|------|
| Python | 20s | 5s | N/A | ~50MB / ~10KB |
| Java Spring | 120s | N/A | N/A | ~100MB |
| Go | 30s | N/A | N/A | ~20MB |

## CI Pipeline Performance

### Parallel Job Execution

| Template | Signal | Confidence | Security | Total |
|----------|--------|------------|----------|-------|
| Python | ~2s | 1-2min | < 30s | < 2min |
| Java Spring | ~60s | 2-5min | < 60s | < 5min |
| Java Tomcat | ~60s | 2-5min | < 60s | < 5min |
| Go | ~5s | 1-2min | < 30s | < 2min |

### Cache Hit Performance

| Cache | Python | Java Spring | Java Tomcat |
|-------|--------|-------------|------------|
| Dependencies | ~1s (uv) | ~30s | ~30s |
| Build Artifacts | ~1s (sccache) | ~30s | ~30s |

## Optimization Summary

| Optimization | Python | Java | Go | Node.js |
|--------------|--------|------|-----|---------|
| uv package manager | ✓ 10-100x | N/A | N/A | N/A |
| sccache | N/A | ✓ | ✓ | N/A |
| BuildKit | ✓ | ✓ | ✓ | ✓ |
| Fast test source set | ✓ | ✓ | ✓ | ✓ |
| No forked JVM | N/A | ✓ | N/A | N/A |
| Annotation processors disabled | N/A | ✓ | N/A | N/A |

## Template Comparison

### Fastest Iteration

1. **Python** - 0.07s feedback (uv + pytest)
2. **Go** - 0.8s feedback (go test)
3. **React** - 2.6s feedback (vitest)

### Fastest CI Signal

1. **Python** - ~2s (uv cache + parallel jobs)
2. **Go** - ~5s (go mod + sccache)
3. **React/Node.js** - ~10s (pnpm + vitest/jest)

### Fastest Docker Build

1. **Python** - < 5s (warm cache)
2. **Go** - < 5s (warm cache)
3. **Node.js** - < 5s (warm cache)
4. **Java Spring/Tomcat** - < 15s (warm cache)

### Fastest Installer Build

1. **Python DEB** - ~5s (equivs-style, no source)
2. **Python AppImage** - ~20s (PyInstaller)
3. **Go AppImage** - ~30s (static binary)
4. **Java Spring AppImage** - ~120s (GraalVM)

## Recommendations

| Use Case | Best Template | Key Advantage |
|----------|--------------|---------------|
| Agent iteration | Python | 0.07s feedback |
| Web frontend | React | Vite + Hot Module Replacement |
| API backend | Go | Static typing + speed |
| Enterprise | Java Spring | Ecosystem + tooling |
| Serverless | Java CRaC | < 100ms cold start |
| CLI tool | Go | Single binary + cross-platform |

## Performance Goals Achievement

| Goal | Target | Best |
|------|--------|------|
| Fast feedback | < 5s | **0.07s** |
| CI signal | < 60s | **~2s** |
| Docker Warm Build | < 30s | **< 5s** |
| Docker Lint | < 5s | **~3s** |
| Hot Reload | < 2s | **< 1s** |
| Installer | < 120s | **~5s** |
| Cold start | < 100ms | **< 100ms** |

## Hot Reload Performance

| Template | Tool | Hot Reload Time | Mechanism |
|----------|------|-----------------|----------|
| Python | uvicorn --reload | **< 1s** | File watcher |
| React | Vite HMR | **< 1s** | WebSocket |
| Go | air | **< 1s** | File watcher |
| Node.js | nodemon | **< 1s** | File watcher |
| Java Spring | spring-boot-devtools | < 5s | Class reload |
| Java Tomcat | JRebel | < 5s | Class reload |
| Java CRaC | CRaC restore | **< 100ms** | Checkpoint |

## Recompile Performance

| Template | Full Compile | Incremental |
|----------|--------------|-------------|
| Go | ~2s | **< 0.5s** |
| Java Spring | ~15s | **< 5s** |
| Java Tomcat | ~15s | **< 5s** |
| React | ~3s | **< 1s** |

## Quick Reference Commands

```bash
# Python (fastest)
make fast-test          # 0.07s
make signal             # ~2s
make build-appimage     # ~20s
make build-deb          # ~5s

# Java Spring
./gradlew devFast       # ~15s
make signal             # ~60s

# Docker
make docker-lint        # ~3s
make docker-build       # < 10s (warm)
make docker-rebuild     # ~30s (no cache)
```
# Go
go test ./...           # 0.8s
make signal             # ~5s
make build-appimage     # ~30s
```

---

**Last Updated**: February 2026
**Optimization Level**: 2026 Best Practices (uv, sccache, BuildKit, CRaC)
