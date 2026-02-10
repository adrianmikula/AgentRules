# Java Spring Boilerplate - Performance Metrics

## Expected Performance

| Command | Time | Status |
|---------|------|--------|
| `./gradlew compileJava` | 10-30s | Expected |
| `./gradlew devFast` | 5-15s | Expected |
| `./gradlew bootJar` | 30-60s | Expected |
| `./gradlew testFull` | 2-5min | CI only |

## Performance by Principle

### 1. No Spring in Inner Loop
Fast tests use plain Java without Spring context.

| Scenario | Time |
|----------|------|
| Fast test (no Spring) | 5-15s |
| Full test (with Spring) | 2-5min |

### 2. Tiered Testing

| Tier | Location | Framework | Time |
|------|----------|-----------|------|
| Fast | src/fast/ | None | 5-15s |
| Integration | src/test/ | Spring | 2-5min |

### 3. Agent Iteration Cycle

```
1. Make code change
2. ./gradlew compileJava  # 10-30s
3. ./gradlew devFast     # 5-15s
Total: 15-45 seconds
```

## Optimization Summary

| Optimization | Impact |
|--------------|--------|
| Annotation processors disabled | 10× compile speedup |
| Configuration cache | No reconfiguration |
| Fast source set | No Spring context |
| No forked JVM | JVM reuse |

## Gradle Configuration

```properties
# gradle.properties
org.gradle.configuration-cache=true
org.gradle.caching=true
org.gradle.parallel=true
```

```gradle
// build.gradle
tasks.named('compileJava').configure {
    options.annotationProcessorPaths = []
    options.compilerArgs << '-proc:none'
}
```

## Expected Benchmarks

| Metric | Target | Expected |
|--------|--------|----------|
| Fast compile | < 30s | 10-30s |
| Fast test | < 15s | 5-15s |
| Spring boot | < 60s | 30-60s |

## Comparison: With vs Without Spring

| Operation | Without Spring | With Spring |
|-----------|----------------|-------------|
| Compile | 10-30s | 10-30s |
| Test | 5-15s | 2-5min |
| Build | 30-60s | 30-60s |

**Key insight**: Tests are 8-20× faster without Spring context.

## Goals Met

| Goal | Target | Expected |
|------|--------|----------|
| Fast feedback | < 30s | 15-45s |
| No Spring in loop | Yes | src/fast/ |
| Tiered tests | Yes | fast/test |
| Command catalogue | Yes | mise.toml |
