# Java Tomcat Boilerplate - Performance Metrics

## Expected Performance

| Command | Time | Status |
|---------|------|--------|
| `mvn compile` | 10-30s | Expected |
| `mvn test -Dtest=FastTests` | 5-15s | Expected |
| `mvn package` | 30-60s | Expected |
| `mvn test` | 2-5min | CI only |

## Performance by Principle

### 1. No Servlet Container in Inner Loop
Fast tests use plain Java without servlet API.

| Scenario | Time |
|----------|------|
| Fast test (no container) | 5-15s |
| Full test (with container) | 2-5min |

### 2. Tiered Testing

| Tier | Location | Framework | Time |
|------|----------|-----------|------|
| Fast | src/fast/ | None | 5-15s |
| Integration | src/test/ | Servlet | 2-5min |

### 3. Agent Iteration Cycle

```
1. Make code change
2. mvn compile          # 10-30s
3. mvn test -Dtest=FastTests   # 5-15s
Total: 15-45 seconds
```

## Optimization Summary

| Optimization | Impact |
|--------------|--------|
| No forked JVM | JVM reuse |
| Annotation processing disabled | Faster compile |
| Fast source set | No servlet API |
| Surefire forkCount=0 | No JVM spawn |

## Maven Configuration

```xml
<!-- pom.xml -->
<compilerArgs>
    <arg>-proc:none</arg>
</compilerArgs>

<plugin>
    <artifactId>maven-surefire-plugin</artifactId>
    <configuration>
        <forkCount>0</forkCount>
    </configuration>
</plugin>
```

## Expected Benchmarks

| Metric | Target | Expected |
|--------|--------|----------|
| Fast compile | < 30s | 10-30s |
| Fast test | < 15s | 5-15s |
| WAR build | < 60s | 30-60s |

## Comparison: With vs Without Tomcat

| Operation | Without Tomcat | With Tomcat |
|-----------|----------------|-------------|
| Compile | 10-30s | 10-30s |
| Test | 5-15s | 2-5min |
| Build | 30-60s | 30-60s |

**Key insight**: Tests are 8-20× faster without servlet container.

## Goals Met

| Goal | Target | Expected |
|------|--------|----------|
| Fast feedback | < 30s | 15-45s |
| No Tomcat in loop | Yes | src/fast/ |
| Tiered tests | Yes | fast/test |
| Command catalogue | Yes | mise.toml |
