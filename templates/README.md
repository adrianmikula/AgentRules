# Agentic Dev Velocity Templates

Boilerplate templates optimized for sub-10s agent iteration cycles across multiple languages and frameworks.

## Templates Overview

| Language | Framework | Path | Fast Test | CI Signal | Docker |
|----------|-----------|------|-----------|-----------|--------|
| Python | FastAPI + uv | [`templates/python/`](templates/python/) | **0.07s** | ~2s | ✓ |
| React | Vite + Node | [`templates/react/`](templates/react/) | 2.6s | ~10s | ✓ |
| Go | Go 1.21 | [`templates/go/`](templates/go/) | **0.8s** | ~5s | ✓ |
| Node.js | Node 20 + pnpm | [`templates/nodejs/`](templates/nodejs/) | 3s | ~10s | ✓ |
| Java | Spring Boot 3 | [`templates/java-spring/`](templates/java-spring/) | 15s | ~60s | ✓ |
| Java | Tomcat 10 | [`templates/java-tomcat/`](templates/java-tomcat/) | 15s | ~60s | ✓ |
| Java | CRaC 21 (Linux) | [`templates/java-crac/`](templates/java-crac/) | 4s | ~60s | ✓ |

## Quick Start

### Python (Fastest Iteration)
```bash
cd templates/python
make fast-test    # 0.07s
make signal       # ~2s (lint + typecheck + test)
make build-appimage  # ~20s
make build-deb     # ~5s
```

### Java Spring
```bash
cd templates/java-spring
./gradlew devFast   # ~15s
make signal          # ~60s
make build-appimage # ~120s
```

### Java Tomcat
```bash
cd templates/java-tomcat
mvn test -Dtest=FastTests  # ~15s
make signal                # ~60s
```

### Go
```bash
cd templates/go
go test ./...   # 0.8s
make signal     # ~5s
make build-appimage  # ~30s
```

## Core Principles

1. **No Framework in Inner Loop** - Fast tests don't boot the framework
2. **Tiered Testing** - Signal → Confidence → Contract → Full
3. **uv Package Manager** - 10-100x faster than pip (Python)
4. **sccache** - Shared compilation cache (Go, Java)
5. **Docker BuildKit** - Parallel builds with cache mounts
6. **Persistent Test Runners** - JVM reuse for Java tests

## Directory Structure

```
templates/
├── python/           # Python + FastAPI + uv
├── react/            # React + Vite + TypeScript
├── go/               # Go + Echo framework
├── nodejs/           # Node.js + Express + pnpm
├── java-spring/      # Java + Spring Boot + Gradle
├── java-tomcat/      # Java + Tomcat + Maven
├── java-crac/        # Java + CRaC JDK + Spring Boot
├── cicd/             # GitHub CI configurations
├── container/        # Docker build files
└── installer/        # Linux installer configs
```

## Performance Highlights

| Metric | Best Template | Time |
|--------|---------------|------|
| Fast Test | Python | 0.07s |
| CI Signal | Python | ~2s |
| Docker Build (warm) | Python/Go | < 5s |
| Installer Build | Python DEB | ~5s |
| Cold Start | Java CRaC | < 100ms |

## Key Optimizations

### Python
- `uv` for package management (parallel resolution, built-in caching)
- `ruff` for linting (10x faster than flake8)
- PyInstaller with parallel workers for AppImage

### Java
- Annotation processors disabled in fast builds
- No forked JVM (JVM reuse)
- Fast source set for tests (no Spring context)

### Go
- `sccache` for compilation caching
- Go 1.21 with faster compiler
- Static binary for AppImage

### Docker
- Multi-stage builds
- BuildKit with cache mounts
- Remote cache to GitHub Actions

## CI/CD Pipeline

Each template includes a GitHub Actions workflow with:

```yaml
jobs:
  signal:       # < 60s (target: < 10s)
  confidence:   # Integration tests (parallel)
  contract:     # API contract tests (parallel)
  security:     # Vulnerability scans
  docker:       # Build and push (after signal)
  installer:    # Build installers (after docker)
```

## Linux Installers

| Template | AppImage | DEB | RPM |
|----------|----------|-----|-----|
| Python | ✓ (20s) | ✓ (5s) | - |
| Java Spring | ✓ (120s) | - | - |
| Go | ✓ (30s) | - | - |

## Requirements

| Tool | Version | Purpose |
|------|---------|---------|
| uv | Latest | Python package manager |
| mise | Latest | Runtime version manager |
| Docker | Latest | Container builds |
| GitHub CLI | Latest | CI workflows |

## Benchmark Commands

```bash
# Run all benchmarks
make benchmark

# Individual benchmarks
make fast-test    # Signal test only
make lint          # Lint only
make typecheck     # Type check only
```

## Related Documentation

- [EFFICIENCY.md](../EFFICIENCY.md) - Agentic dev velocity principles
- [TESTING.md](../TESTING.md) - Tiered testing strategy
- [CODING.md](../CODING.md) - Coding standards
- [DEVOPS.md](../DEVOPS.md) - DevOps practices

## License

MIT
