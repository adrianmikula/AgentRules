# Java Spring Boilerplate - Commands Reference

## Quick Reference

| Command | Description | Time | When to Run |
|---------|-------------|------|-------------|
| `mise run compile` | Compile all Java sources | 10-30s | Before tests |
| `mise run fast-test` | Fast unit tests | 5-15s | **Every iteration** |
| `mise run build` | Build JAR | 30-60s | Before commit |
| `mise run test-full` | Full test suite | 2-5min | CI only |
| `mise run run` | Run Spring app | 30-60s | Development |
| `mise run clean` | Clean build artifacts | 5-10s | When stuck |

## Using mise-en-place (Recommended)

This project uses [mise-en-place](https://mise.jdx.dev/) to catalogue commands. Agents can easily discover and run whitelisted commands.

### List available commands:
```bash
mise tasks
```

### Run a command:
```bash
mise run compile
mise run fast-test
mise run build
```

## Commands Detail

### 1. Compile (Required Before Tests)
```bash
mise run compile
# or: ./gradlew compileJava compileFastJava
```

Compiles all Java sources. Required before running tests.

**Key optimizations:**
- Annotation processors disabled for fast compile
- Incremental compilation enabled

### 2. Fast Test (Primary Command)
```bash
mise run fast-test
# or: ./gradlew devFast
```

Runs fast unit tests only. **This is the command agents should run after every change.**

**Test scope:**
- `src/fast/` - Plain Java tests, no Spring context

**Excluded:**
- Full test suite with Spring context
- Integration tests

### 3. Build
```bash
mise run build
# or: ./gradlew bootJar
```

Builds the Spring Boot JAR with layered packaging.

### 4. Full Test Suite (CI Only)
```bash
mise run test-full
# or: ./gradlew testFull
```

Runs all tests including integration tests. **Never run locally during iteration.**

**Includes:**
- Fast tests
- Integration tests
- Spring context tests

**Expected time:** 2-5 minutes

### 5. Run Spring Application
```bash
mise run run
# or: ./gradlew bootRun
```

Runs the Spring Boot application. Useful for development but slow.

### 6. Clean
```bash
mise run clean
# or: ./gradlew clean
```

Removes all build artifacts.

## Prerequisites

Install mise-en-place:
```bash
# Using curl (Linux/macOS)
curl https://mise.run | sh

# Using winget (Windows)
winget install mise-en-place
```

Then install Java and build:
```bash
mise install
mise run install
```

## Project Structure

```
java-spring-boilerplate/
├── src/
│   ├── main/           # Spring application (slow to build)
│   └── fast/           # Plain Java for fast iteration
├── build.gradle        # Gradle build config
├── gradle.properties   # Gradle optimization settings
└── mise.toml          # Command catalogue
```

## Key Optimizations

### Fast Source Set
The `src/fast/` directory contains plain Java classes with no Spring dependencies:
- `FastUserService.java` - Business logic without DI
- `FastTests.java` - JUnit 5 tests without Spring context

### Annotation Processing Disabled
```gradle
tasks.named('compileJava').configure {
    options.annotationProcessorPaths = []
    options.compilerArgs << '-proc:none'
}
```

### Gradle Configuration Cache
```properties
org.gradle.configuration-cache=true
org.gradle.caching=true
org.gradle.parallel=true
```

## Agent Rules

1. **Always run `mise run compile` then `mise run fast-test` after code changes**
2. **Run `mise run build` before committing**
3. **Never run `mise run test-full` locally**
4. **If stuck, run `mise run clean` and retry**

## mise.toml Configuration

```toml
[tools]
java = "17"

[commands]
compile = "./gradlew compileJava compileFastJava --quiet"
fast-test = "./gradlew devFast"
build = "./gradlew bootJar --quiet"
test-full = "./gradlew testFull"
run = "./gradlew bootRun --quiet"
clean = "./gradlew clean"
install = "./gradlew build -x test --quiet"
```
