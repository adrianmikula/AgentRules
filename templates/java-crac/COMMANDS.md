# Java CRaC Boilerplate - Commands Reference

## Quick Reference

| Command | Description | Time | When to Run |
|---------|-------------|------|-------------|
| `mise run compile` | Compile all Java sources | 10-30s | Before tests |
| `mise run test-fast` | Fast unit tests | 5-15s | **Every iteration** |
| `mise run test-full` | Full test suite | 2-5min | CI only |
| `mise run build` | Build JAR | 30-60s | Before deploy |
| `mise run dev` | Run dev server | 30-60s | Development |
| `mise run crac-checkpoint` | Create CRaC checkpoint | 10-30s | Setup once |
| `mise run crac-restore` | Restore from checkpoint | **< 100ms** | Fast restart |

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

### 2. Fast Test (Primary Command)
```bash
mise run test-fast
# or: ./gradlew fastTest --no-daemon
```

Runs fast unit tests only. **This is the command agents should run after every change.**

### 3. Full Test Suite (CI Only)
```bash
mise run test-full
# or: ./gradlew fullTest --no-daemon
```

Runs all tests including integration tests. **Never run locally during iteration.**

### 4. Build
```bash
mise run build
# or: ./gradlew build --no-daemon
```

Builds the JAR with CRaC support.

### 5. Development Run
```bash
mise run dev
# or: ./gradlew bootRun --no-daemon
```

Runs the Spring Boot application with CRaC support.

### 6. CRaC Checkpoint
```bash
mise run crac-checkpoint
# or: java -XX:CRaCCheckpointTo=/tmp/cr -jar build/libs/*.jar
```

Creates a CRaC checkpoint of the running application. This takes time but only needs to be done once.

### 7. CRaC Restore (Fast Restart)
```bash
mise run crac-restore
# or: java -XX:CRaCRestoreFrom=/tmp/cr -jar build/libs/*.jar
```

Restores from checkpoint. **This is the magic - < 100ms startup!**

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
mise run compile
```

## Project Structure

```
java-crac-boilerplate/
├── src/
│   ├── main/           # Spring application
│   └── fast/           # Plain Java for fast iteration
├── build.gradle        # Gradle build config
├── gradle.properties   # Gradle optimization settings
└── mise.toml          # Command catalogue
```

## CRaC Workflow

### Initial Setup (One Time)
```bash
# Build and run
mise run build
mise run dev

# In another terminal, create checkpoint
mise run crac-checkpoint

# Stop the running application (Ctrl+C)
```

### Fast Restart (After Code Changes)
```bash
# Just restore from checkpoint - super fast!
mise run crac-restore
```

### After Code Changes (Not Using CRaC)
```bash
mise run compile
mise run test-fast
mise run build
mise run dev
```

## Agent Rules

1. **After initial setup: use `mise run crac-restore` for instant feedback**
2. **Before committing: run `mise run compile && mise run test-fast`**
3. **Never run `mise run test-full` locally**
4. **If CRaC fails, fall back to `mise run dev`**

## mise.toml Configuration

Commands are catalogued in [`mise.toml`](mise.toml):

```toml
[tools]
java = "21"

[scripts]
compile = "./gradlew compileJava --no-daemon"
test-fast = "./gradlew fastTest --no-daemon"
test-full = "./gradlew fullTest --no-daemon"
build = "./gradlew build --no-daemon"
dev = "./gradlew bootRun --no-daemon"
crac-checkpoint = "java -XX:CRaCCheckpointTo=/tmp/cr -jar build/libs/*.jar"
crac-restore = "java -XX:CRaCRestoreFrom=/tmp/cr -jar build/libs/*.jar"
```

This allows agents to easily discover and whitelist commands.
