# Agentic Dev Velocity Templates - Performance Matrix

## Performance Grid

| Language | Runtime | Lint | Compile | Fast Test | Full Test | CI Signal | Docker Build | Installer |
|----------|---------|------|---------|-----------|-----------|-----------|---------------|-----------|
| **Python** | uv + FastAPI | 0.5s | N/A | **0.07s** | 30s | ~2s | < 30s | AppImage: 20s / DEB: 5s |
| **React** | Vite + Node | 1s | 3s | 2.6s | 30s | ~10s | < 30s | N/A |
| **Go** | Go 1.21 | 0.5s | 2s | **0.8s** | 15s | ~5s | < 30s | AppImage: 30s |
| **Node.js** | Node 20 + pnpm | 1s | N/A | 3s | 30s | ~10s | < 30s | N/A |
| **Java** | Spring Boot 3 | 5s | 15s | 15s | 3min | ~60s | < 60s | AppImage: 120s |
| **Java** | Tomcat 10 | 5s | 15s | 15s | 3min | ~60s | < 60s | N/A |
| **Java** | CRaC 21 (Linux) | 5s | 15s | 4s (cold) | N/A | ~60s | < 60s | N/A |

## KPI Definitions

| KPI | Definition | Target |
|-----|-----------|--------|
| **Lint** | Static analysis check | < 2s |
| **Compile** | Source → Binary | < 30s |
| **Fast Test** | Unit tests only (no framework boot) | < 5s |
| **Full Test** | All tests (unit + integration + contract) | < 5min |
| **CI Signal** | Lint + Compile + Fast Test in CI | < 60s |
| **Docker Build** | Multi-stage build with cache | < 60s |
| **Installer** | Platform-specific package build | < 120s |

## Performance Tiers

### Tier 1: Sub-10s Feedback (Best for Agents)

| Template | Signal | Fast Test | CI Signal |
|----------|--------|-----------|-----------|
| Python | 0.5s + 0.07s | **0.07s** | ~2s |
| Go | 0.5s + 2s | **0.8s** | ~5s |

### Tier 2: Sub-60s Feedback

| Template | Compile | Fast Test | CI Signal |
|----------|---------|-----------|-----------|
| Java Spring | 15s | 15s | ~60s |
| Java Tomcat | 15s | 15s | ~60s |
| React | 3s | 2.6s | ~10s |
| Node.js | N/A | 3s | ~10s |

### Tier 3: Special Purpose

| Template | Startup | Cold Start | Use Case |
|----------|---------|------------|----------|
| Java CRaC | 15s compile | **< 100ms** (restored) | Serverless |

## Docker Performance Matrix

| Template | Builder | Dev | Production | Cache Hit |
|----------|---------|-----|------------|-----------|
| Python | 30s | 10s | 10s | < 5s |
| Java Spring | 60s | 30s | 30s | < 15s |
| Java Tomcat | 60s | 30s | 30s | < 15s |
| Go | 30s | 10s | 10s | < 5s |
| Node.js | 30s | 10s | 10s | < 5s |

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

| Goal | Target | Best Achievable | Template |
|------|--------|-----------------|----------|
| Fast feedback | < 5s | **0.07s** | Python |
| CI signal | < 60s | **~2s** | Python |
| Docker build | < 60s | **< 5s** | Python/Go (warm) |
| Installer | < 120s | **~5s** | Python DEB |
| Cold start | < 100ms | **< 100ms** | Java CRaC |

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

# Go
go test ./...           # 0.8s
make signal             # ~5s
make build-appimage     # ~30s
```

---

**Last Updated**: February 2026
**Optimization Level**: 2026 Best Practices (uv, sccache, BuildKit, CRaC)
