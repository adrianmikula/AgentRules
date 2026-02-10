# Java Tomcat Boilerplate - Commands Reference

## Quick Reference

| Command | Description | Time | When to Run |
|---------|-------------|------|-------------|
| `mise run compile` | Compile all Java sources | 10-30s | Before tests |
| `mise run fast-test` | Fast unit tests | 5-15s | **Every iteration** |
| `mise run build` | Build WAR | 30-60s | Before deploy |
| `mise run test-full` | Full test suite | 2-5min | CI only |
| `mise run run` | Run Tomcat | 30-60s | Development |
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
# or: mvn compile -q
```

Compiles all Java sources. Required before running tests.

**Key optimizations:**
- Annotation processors disabled
- No fork per compilation

### 2. Fast Test (Primary Command)
```bash
mise run fast-test
# or: mvn test -Dtest=FastTests -DfailIfNoTests=false -q
```

Runs fast unit tests only. **This is the command agents should run after every change.**

**Test scope:**
- `src/fast/` - Plain Java tests, no servlet API

**Excluded:**
- Full test suite with servlet API
- Integration tests

### 3. Build
```bash
mise run build
# or: mvn package -DskipTests -q
```

Builds the WAR file for deployment to Tomcat.

### 4. Full Test Suite (CI Only)
```bash
mise run test-full
# or: mvn test
```

Runs all tests including servlet tests. **Never run locally during iteration.**

**Expected time:** 2-5 minutes

### 5. Run Tomcat
```bash
mise run run
# or: mvn tomcat7:run
```

Runs embedded Tomcat server. Useful for development but slow.

### 6. Clean
```bash
mise run clean
# or: mvn clean
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
java-tomcat-boilerplate/
├── src/
│   ├── main/           # Tomcat application (slow to build)
│   │   ├── java/
│   │   └── webapp/
│   └── fast/           # Plain Java for fast iteration
├── pom.xml            # Maven build config
└── mise.toml          # Command catalogue
```

## Key Optimizations

### Fast Source Set
The `src/fast/` directory contains plain Java classes with no servlet dependencies:
- `FastUserService.java` - Business logic without servlet API
- `FastTests.java` - JUnit 5 tests without container

### Annotation Processing Disabled
```xml
<compilerArgs>
    <arg>-proc:none</arg>
</compilerArgs>
```

### No Forked JVM
```xml
<fork>false</fork>
<useIncrementalCompilation>false</useIncrementalCompilation>
```

## Agent Rules

1. **Always run `mise run compile` then `mise run fast-test` after code changes**
2. **Run `mise run build` before deploying**
3. **Never run `mise run test-full` locally**
4. **If stuck, run `mise run clean` and retry**

## mise.toml Configuration

```toml
[tools]
java = "11"

[commands]
compile = "mvn compile -q"
fast-test = "mvn test -Dtest=FastTests -DfailIfNoTests=false -q"
build = "mvn package -DskipTests -q"
test-full = "mvn test"
run = "mvn tomcat7:run"
clean = "mvn clean"
install = "mvn package -DskipTests -q"
```
