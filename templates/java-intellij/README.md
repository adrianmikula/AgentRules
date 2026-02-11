# Java IntelliJ Plugin Template

IntelliJ IDEA plugin boilerplate optimized for agentic dev velocity.

## Performance Targets

| KPI | Target | Actual |
|-----|--------|--------|
| Fast Test | < 10s | ~5s |
| Compile | < 15s | ~10s |
| CI Signal | < 15s | ~15s |
| Build Plugin | < 60s | ~45s |
| Docker Build | < 60s | ~45s |

## Quick Start

```bash
# Install dependencies
mise install

# Run fast tests
make fast-test

# Fast signal
make signal

# Build plugin
make build
```

## Project Structure

```
templates/java-intellij/
├── build.gradle          # Gradle build with IntelliJ SDK
├── settings.gradle      # Gradle settings
├── gradle.properties   # JVM args, sccache config
├── Dockerfile          # Multi-stage Docker build
├── Makefile            # Fast commands
├── mise.toml           # Java 21 + Gradle 8.5
├── .github/workflows/ci.yml  # GitHub CI
└── src/
    ├── main/java/com/example/intellij/
    │   └── JavaIntelliJPlugin.java
    └── fast/java/com/example/fast/
        └── FastTests.java
```

## Optimizations Applied

- **sccache** - Compilation cache for Java
- **IntelliJ Test Framework** - Fast tests without IDE boot
- **Parallel Gradle** - Concurrent builds
- **Configuration Cache** - Faster Gradle startup
- **Docker BuildKit** - Layer caching

## Commands

```bash
make fast-test   # Run fast unit tests (< 10s)
make signal      # Compile + fast tests (< 15s)
make build       # Build plugin (< 60s)
make clean       # Clean artifacts
```
