# Java IntelliJ Plugin Boilerplate - Commands Reference

## Quick Reference

| Command | Description | Time | When to Run |
|---------|-------------|------|-------------|
| `mise run compile` | Compile all Java sources | 10-30s | Before tests |
| `mise run lint` | Checkstyle lint | 5-10s | Before committing |
| `mise run test-fast` | Fast unit tests | 5-15s | **Every iteration** |
| `mise run build` | Build plugin JAR | 30-60s | Before deploy |
| `mise run runIde` | Run test IDE | 60-120s | Development |
| `mise run verifyPlugin` | Verify plugin | 30-60s | Before commit |
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
mise run test-fast
mise run build
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

### 3. Fast Test (Primary Command)
```bash
mise run test-fast
# or: ./gradlew fastTest --no-daemon
```

Runs fast unit tests only. **This is the command agents should run after every change.**

### 4. Build Plugin
```bash
mise run build
# or: ./gradlew buildPlugin --no-daemon
```

Builds the IntelliJ plugin JAR.

### 5. Run Test IDE
```bash
mise run runIde
# or: ./gradlew runIde --no-daemon
```

Runs a test instance of IntelliJ IDEA with the plugin loaded. Useful for development.

### 6. Verify Plugin
```mise run verifyPlugin
# or: ./gradlew verifyPlugin --no-daemon
```

Verifies the plugin configuration and dependencies.

### 7. Clean
```bash
mise run clean
# or: ./gradlew clean
```

Removes all build artifacts.

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
java-intellij-boilerplate/
├── src/
│   ├── main/           # IntelliJ plugin code
│   └── fast/           # Plain Java for fast iteration
├── build.gradle        # Gradle build config
├── gradle.properties   # Gradle optimization settings
├── settings.gradle
└── mise.toml          # Command catalogue
```

## IntelliJ Platform Development

### Running the Plugin
```bash
mise run runIde
```

This will open a new IntelliJ IDEA instance with your plugin installed.

### Building for Distribution
```bash
mise run build
mise run verifyPlugin
```

### Development Workflow
```bash
mise run compile
mise run test-fast
# Make code changes
mise run compile
mise run test-fast
# When ready to test UI:
mise run runIde
```

## Agent Rules

1. **Always run `mise run compile && mise run test-fast` after code changes**
2. **Run `mise run build` before committing**
3. **Use `mise run runIde` for UI testing**
4. **Never run full test suite locally**

## mise.toml Configuration

Commands are catalogued in [`mise.toml`](mise.toml):

```toml
[tools]
java = "21"
gradle = "8.5"

[scripts]
compile = "./gradlew compileJava --no-daemon"
lint = "./gradlew checkstyleMain --quiet"
test-fast = "./gradlew fastTest --no-daemon"
build = "./gradlew buildPlugin --no-daemon"
build-zip = "./gradlew buildPlugin --no-daemon"
runIde = "./gradlew runIde --no-daemon"
verifyPlugin = "./gradlew verifyPlugin --no-daemon"
clean = "./gradlew clean"
```
