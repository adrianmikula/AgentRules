# Java CRaC Advanced Boilerplate - Commands Reference

## Quick Reference

| Command | Description | Time | When to Run |
|---------|-------------|------|-------------|
| `mise run compile` | Compile all Java sources | 10-30s | Before tests |
| `mise run lint` | Checkstyle lint | 5-10s | Before committing |
| `mise run typecheck` | Type checking | 5-10s | Before committing |
| `mise run test-fast` | Fast unit tests | 5-15s | **Every iteration** |
| `mise run test-unit` | Unit tests only | 5-15s | Unit changes |
| `mise run test-integration` | Integration tests | 30-60s | Integration changes |
| `mise run build` | Build JAR | 30-60s | Before deploy |
| `mise run build-native` | Build native image | 2-5min | Production |
| `mise run dev` | Run dev server | 30-60s | Development |
| `mise run crac-warmup` | Warm up for CRaC | 30-60s | Setup once |
| `mise run crac-checkpoint` | Create CRaC checkpoint | 10-30s | Setup once |
| `mise run crac-restore` | Restore from checkpoint | **< 100ms** | Fast restart |
| `mise run crac-predict` | Predictive test selection | < 1s | Smart testing |

## Using mise-en-place (Recommended)

This project uses [mise-en-place](https://mise.jdx.dev/) to catalogue commands. Agents can easily discover and run whitelisted commands.

### List available commands:
```bash
mise tasks
```

### Run a command:
```bash
mise run compile
mise run test-fast
mise run crac-restore
```

## Commands Detail

### 1. Compile (Required Before Tests)
```bash
mise run compile
# or: ./gradlew compileJava --no-daemon
```

Compiles all Java sources. Required before running tests.

### 2. Lint
```bash
mise run lint
# or: ./gradlew checkstyleMain --quiet
```

Runs Checkstyle linting.

### 3. Type Check
```bash
mise run typecheck
# or: ./gradlew typecheck --quiet
```

Runs type checking.

### 4. Fast Test (Primary Command)
```bash
mise run test-fast
# or: ./gradlew fastTest --no-daemon
```

Runs fast unit tests. **This is the command agents should run after every change.**

### 5. Unit Tests Only
```bash
mise run test-unit
# or: ./gradlew test --tests 'com.example.unit.*' --no-daemon
```

Runs only unit tests.

### 6. Integration Tests Only
```bash
mise run test-integration
# or: ./gradlew test --tests 'com.example.integration.*' --no-daemon
```

Runs only integration tests.

### 7. Predictive Test Selection
```bash
mise run crac-predict
# or: python3 crac/predictive_test_selector.py
```

Runs predictive test selection based on code changes. Smart testing!

### 8. Build
```bash
mise run build
# or: ./gradlew build -x test --no-daemon
```

Builds the JAR with CRaC support.

### 9. Build Native Image
```bash
mise run build-native
# or: ./gradlew nativeCompile --no-daemon
```

Builds GraalVM native image for instant cold starts.

### 10. Development Run
```bash
mise run dev
# or: ./gradlew bootRun --no-daemon
```

Runs the Spring Boot application.

### 11. CRaC Warmup
```bash
mise run crac-warmup
# or: bash crac/warmup.sh
```

Warms up the JVM for optimal CRaC checkpoint.

### 12. CRaC Checkpoint
```bash
mise run crac-checkpoint
# or: java -XX:CRaCCheckpointTo=/tmp/cr -jar build/libs/*.jar
```

Creates a CRaC checkpoint.

### 13. CRaC Restore (Fast Restart)
```bash
mise run crac-restore
# or: java -XX:CRaCRestoreFrom=/tmp/cr -jar build/libs/*.jar
```

Restores from checkpoint. **< 100ms startup!**

### 14. Cache Warmup
```bash
mise run cache-warm
# or: ./gradlew --build-cache --no-daemon
```

Warms Gradle build cache.

## Prerequisites

Install mise-en-place:
```bash
curl https://mise.run | sh
```

Then install Java and build:
```bash
mise install
mise run compile
```

## Project Structure

```
java-crac-advanced-boilerplate/
├── src/
│   ├── main/           # Spring application
│   └── fast/           # Plain Java for fast iteration
├── crac/
│   ├── warmup.sh       # JVM warmup script
│   └── predictive_test_selector.py  # Smart test selection
├── build.gradle        # Gradle build config
├── gradle.properties   # Gradle optimization settings
└── mise.toml          # Command catalogue
```

## Advanced Workflows

### Predictive Testing
```bash
# Run only relevant tests based on code changes
mise run crac-predict
```

### Native + CRaC (Fastest Cold Start)
```bash
mise run build-native
mise run crac-warmup
mise run crac-checkpoint
mise run crac-restore  # < 100ms!
```

## Agent Rules

1. **Use `mise run compile && mise run test-fast` for quick feedback**
2. **Use `mise run crac-predict` for smart test selection**
3. **Use `mise run crac-restore` for instant restart**
4. **Use `mise run build-native` for production builds**
5. **Never run `mise run test-full` locally**

## mise.toml Configuration

Commands are catalogued in [`mise.toml`](mise.toml):

```toml
[tools]
java = "21"
gradle = "8.5"

[scripts]
compile = "./gradlew compileJava --no-daemon"
compile-test = "./gradlew compileTestJava --no-daemon"
lint = "./gradlew checkstyleMain --quiet"
typecheck = "./gradlew typecheck --quiet"
test-fast = "./gradlew fastTest --no-daemon"
test-unit = "./gradlew test --tests 'com.example.unit.*' --no-daemon"
test-integration = "./gradlew test --tests 'com.example.integration.*' --no-daemon"
crac-warmup = "bash crac/warmup.sh"
crac-checkpoint = "java -XX:CRaCCheckpointTo=/tmp/cr -jar build/libs/*.jar"
crac-restore = "java -XX:CRaCRestoreFrom=/tmp/cr -jar build/libs/*.jar"
crac-predict = "python3 crac/predictive_test_selector.py"
build = "./gradlew build -x test --no-daemon"
build-native = "./gradlew nativeCompile --no-daemon"
dev = "./gradlew bootRun --no-daemon"
dev-native = "./gradlew nativeRun --no-daemon"
clean = "./gradlew clean"
cache-warm = "./gradlew --build-cache --no-daemon"
```
