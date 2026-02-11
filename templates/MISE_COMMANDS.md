# mise Command Catalogue Reference

This document provides a comprehensive reference for all `mise.toml` command configurations across all language templates. Agents should use `mise run <command>` for fast feedback loops.

## Table of Contents

- [Python FastAPI](#python-fastapi)
- [Python Django](#python-django)
- [Java Spring](#java-spring)
- [Java Tomcat](#java-tomcat)
- [Java CRaC](#java-crac)
- [Java CRaC Advanced](#java-crac-advanced)
- [Java IntelliJ Plugin](#java-intellij-plugin)
- [Go](#go)
- [Node.js](#nodejs)
- [React](#react)
- [Roblox-TS](#roblox-ts)

---

## Python FastAPI

**Location:** [`templates/python/mise.toml`](python/mise.toml)

```toml
[tools]
python = "3.12"

[commands]
# Fast feedback commands (agents should run these first)
lint = "ruff check src/ tests/unit/ tests/contract/"
lint-fix = "ruff check src/ tests/unit/ tests/contract/ --fix"
typecheck = "mypy src/"
fast-test = "pytest tests/unit tests/contract -v --tb=short"

# Development commands
dev = "python -m src.app.main"

# CI commands (slow, not for local iteration)
test-full = "pytest tests/ -v --tb=short"

# Utility commands
clean = "rm -rf .mypy_cache .pytest_cache __pycache__ src/**/__pycache__"
install = "uv sync"
install-dev = "uv sync --extra dev"
```

**Agent Workflow:**
1. `mise run lint` - Quick syntax/style check (~1s)
2. `mise run typecheck` - Type validation (~2s)
3. `mise run fast-test` - Unit + contract tests (~3s)
4. `mise run dev` - Start dev server

---

## Python Django

**Location:** [`templates/python-django/mise.toml`](python-django/mise.toml)

```toml
[tools]
python = "3.12"

[commands]
# Fast feedback commands
lint = "ruff check config/ apps/ tests/"
lint-fix = "ruff check config/ apps/ tests/ --fix"
typecheck = "mypy config/ apps/"
fast-test = "pytest tests/unit tests/contract -v --tb=short --no-header"
test-fast = "pytest tests/unit -v --tb=short --no-header"

# Development commands
dev = "python manage.py runserver"
migrate = "python manage.py migrate"
shell = "python manage.py shell"

# CI commands (slow)
test-full = "pytest tests/ -v --tb=short"
check = "python manage.py check"

# Utility commands
clean = "find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null; find . -type f -name '*.pyc' -delete"
install = "uv sync"
install-dev = "uv sync --extra dev"
```

**Agent Workflow:**
1. `mise run lint` - Quick syntax/style check (~1s)
2. `mise run typecheck` - Type validation (~2s)
3. `mise run fast-test` - Unit tests only (~2s)
4. `mise run dev` - Start dev server

---

## Java Spring

**Location:** [`templates/java-spring/mise.toml`](java-spring/mise.toml)

```toml
[tools]
java = "17"

[commands]
# Fast feedback commands
lint = "./gradlew checkstyleMain checkstyleTest --quiet 2>/dev/null || echo 'lint: skipped (not configured)'"
compile = "./gradlew compileJava compileFastJava --quiet"
typecheck = "./gradlew typecheck --quiet 2>/dev/null || echo 'typecheck: skipped'"
fast-test = "./gradlew devFast"
build = "./gradlew bootJar --quiet"

# CI commands (slow)
test-full = "./gradlew testFull"
run = "./gradlew bootRun --quiet"

# Utility commands
clean = "./gradlew clean"
install = "./gradlew build -x test --quiet"
```

**Agent Workflow:**
1. `mise run compile` - Quick compilation check (~5s)
2. `mise run fast-test` - Fast unit tests (~3s)
3. `mise run build` - Build JAR (~5s)
4. `mise run run` - Start dev server

---

## Java Tomcat

**Location:** [`templates/java-tomcat/mise.toml`](java-tomcat/mise.toml)

```toml
[tools]
java = "11"

[commands]
# Fast feedback commands
lint = "mvn validate --quiet 2>/dev/null || echo 'lint: skipped'"
compile = "mvn compile -q"
fast-test = "mvn test -Dtest=FastTests -DfailIfNoTests=false -q"
build = "mvn package -DskipTests -q"

# CI commands (slow)
test-full = "mvn test"
run = "mvn tomcat7:run"

# Utility commands
clean = "mvn clean"
install = "mvn package -DskipTests -q"
```

**Agent Workflow:**
1. `mise run compile` - Quick compilation check (~5s)
2. `mise run fast-test` - Fast unit tests (~3s)
3. `mise run build` - Build WAR (~5s)
4. `mise run run` - Start Tomcat

---

## Java CRaC

**Location:** [`templates/java-crac/mise.toml`](java-crac/mise.toml)

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

**Agent Workflow:**
1. `mise run compile` - Compile (~5s)
2. `mise run test-fast` - Fast tests (~3s)
3. `mise run build` - Build (~5s)
4. `mise run crac-checkpoint` - Create checkpoint
5. `mise run crac-restore` - Restore from checkpoint (~100ms)

---

## Java CRaC Advanced

**Location:** [`templates/java-crac-advanced/mise.toml`](java-crac-advanced/mise.toml)

```toml
[tools]
java = "21"
gradle = "8.5"

[scripts]
# Fast feedback commands
compile = "./gradlew compileJava --no-daemon"
compile-test = "./gradlew compileTestJava --no-daemon"
lint = "./gradlew checkstyleMain --quiet 2>/dev/null || echo 'lint: skipped'"
typecheck = "./gradlew typecheck --quiet 2>/dev/null || echo 'typecheck: skipped'"

# Fast test commands
test-fast = "./gradlew fastTest --no-daemon"
test-unit = "./gradlew test --tests 'com.example.unit.*' --no-daemon"
test-integration = "./gradlew test --tests 'com.example.integration.*' --no-daemon"

# CRaC commands
crac-warmup = "bash crac/warmup.sh"
crac-checkpoint = "java -XX:CRaCCheckpointTo=/tmp/cr -jar build/libs/*.jar"
crac-restore = "java -XX:CRaCRestoreFrom=/tmp/cr -jar build/libs/*.jar"
crac-predict = "python3 crac/predictive_test_selector.py"

# Build commands
build = "./gradlew build -x test --no-daemon"
build-native = "./gradlew nativeCompile --no-daemon"

# Development commands
dev = "./gradlew bootRun --no-daemon"
dev-native = "./gradlew nativeRun --no-daemon"

# Utility commands
clean = "./gradlew clean"
cache-warm = "./gradlew --build-cache --no-daemon"
```

**Agent Workflow:**
1. `mise run compile` - Quick compilation (~5s)
2. `mise run test-fast` - Fast tests (~3s)
3. `mise run crac-predict` - Predictive test selection (~1s)
4. `mise run build` - Build JAR (~5s)
5. `mise run crac-checkpoint` - Create checkpoint
6. `mise run crac-restore` - Restore (~100ms)

---

## Java IntelliJ Plugin

**Location:** [`templates/java-intellij/mise.toml`](java-intellij/mise.toml)

```toml
[tools]
java = "21"
gradle = "8.5"

[scripts]
# Fast feedback commands
compile = "./gradlew compileJava --no-daemon"
lint = "./gradlew checkstyleMain --quiet 2>/dev/null || echo 'lint: skipped'"
test-fast = "./gradlew fastTest --no-daemon"

# Build commands
build = "./gradlew buildPlugin --no-daemon"
build-zip = "./gradlew buildPlugin --no-daemon"

# Development commands
runIde = "./gradlew runIde --no-daemon"
verifyPlugin = "./gradlew verifyPlugin --no-daemon"

# Utility commands
clean = "./gradlew clean"
```

**Agent Workflow:**
1. `mise run compile` - Compile (~5s)
2. `mise run test-fast` - Fast tests (~3s)
3. `mise run build` - Build plugin (~5s)
4. `mise run runIde` - Run test IDE

---

## Go

**Location:** [`templates/go/mise.toml`](go/mise.toml)

```toml
[tools]
go = "1.21"

[scripts]
lint = "go vet ./..."
test-fast = "go test -v -run 'Test(Home|Health|Users|User|Count|Schema)' ./tests/unit ./tests/contract"
test-full = "go test -v ./tests/..."
build = "go build -o bin/app main.go"
dev = "go run main.go"
```

**Agent Workflow:**
1. `mise run lint` - Quick lint (~1s)
2. `mise run test-fast` - Fast tests (~2s)
3. `mise run build` - Build binary (~2s)
4. `mise run dev` - Run dev server

---

## Node.js

**Location:** [`templates/nodejs/mise.toml`](nodejs/mise.toml)

```toml
[tools]
node = "20"

[scripts]
lint = "npm run lint"
test-fast = "npm run test:fast"
test-full = "npm run test:full"
dev = "npm run dev"
start = "npm start"
```

**Agent Workflow:**
1. `mise run lint` - Quick lint (~1s)
2. `mise run test-fast` - Fast tests (~2s)
3. `mise run dev` - Start dev server

---

## React

**Location:** [`templates/react/mise.toml`](react/mise.toml)

```toml
[tools]
node = "20"

[scripts]
lint = "npm run lint"
lint-fix = "npm run lint:fix"
typecheck = "npm run typecheck"
test-fast = "npm run test:fast"
test-full = "npm run test:full"
dev = "npm run dev"
build = "npm run build"
```

**Agent Workflow:**
1. `mise run lint` - Quick lint (~2s)
2. `mise run typecheck` - Type check (~3s)
3. `mise run test-fast` - Fast tests (~3s)
4. `mise run dev` - Start dev server

---

## Roblox-TS

**Location:** [`templates/roblox-ts/mise.toml`](roblox-ts/mise.toml)

```toml
[tools]
node = "20"
lua = "5.4"

[scripts]
# Fast feedback commands
lint = "selene src/ tests/"
lint-fix = "selene src/ tests/ --fix"
typecheck = "rbx-tsc --noEmit"
compile = "rbx-tsc"
test-fast = "jest --testPathPattern=tests/unit --no-coverage"

# Full test commands
test-full = "jest --no-coverage"
test-contract = "jest --testPathPattern=tests/contract"

# Development commands
dev = "rojo serve"
build = "rojo build --output build.rbxlx"
package = "npm run package"

# Utility commands
clean = "rm -rf out node_modules/.cache"
install = "npm install"
install-dev = "npm install"
format = "stylua src/ --check"
```

**Agent Workflow:**
1. `mise run lint` - Quick lint (~1s)
2. `mise run typecheck` - Type check (~2s)
3. `mise run test-fast` - Fast tests (~2s)
4. `mise run compile` - Compile (~3s)
5. `mise run dev` - Start Rojo server

---

## Command Execution Times

| Template | lint | typecheck | compile | test-fast | build | dev |
|----------|------|-----------|---------|-----------|-------|-----|
| Python FastAPI | ~1s | ~2s | N/A | ~3s | N/A | instant |
| Python Django | ~1s | ~2s | N/A | ~2s | N/A | instant |
| Java Spring | ~2s | N/A | ~5s | ~3s | ~5s | ~3s |
| Java Tomcat | ~1s | N/A | ~5s | ~3s | ~5s | ~5s |
| Java CRaC | N/A | N/A | ~5s | ~3s | ~5s | ~5s |
| Java CRaC Advanced | ~2s | ~3s | ~5s | ~3s | ~5s | ~5s |
| Java IntelliJ | ~2s | N/A | ~5s | ~3s | ~5s | ~10s |
| Go | ~1s | N/A | ~2s | ~2s | ~2s | instant |
| Node.js | ~1s | N/A | N/A | ~2s | N/A | instant |
| React | ~2s | ~3s | N/A | ~3s | ~10s | instant |
| Roblox-TS | ~1s | ~2s | ~3s | ~2s | ~5s | instant |

---

## Agent Best Practices

1. **Always start with lint** - Catch syntax errors first
2. **Run fast-test before full-test** - Get quick feedback
3. **Use mise run for consistency** - Ensures same commands across environments
4. **Cache expensive operations** - Use `./gradlew --build-cache` for Java
5. **Leverage CRaC for fast startup** - Java templates can restore from checkpoint

---

## Mise Configuration Tips

### Adding New Commands

Add commands to the `[commands]` or `[scripts]` section:

```toml
[commands]
my-command = "echo hello"
```

### Running Commands

```bash
# Run a specific command
mise run lint

# Run with arguments
mise run test-fast -- --verbose

# List all available commands
mise tasks
```

### Environment Variables

Set environment variables in `mise.toml`:

```toml
[env]
JAVA_OPTS = "-Xmx2g"
NODE_ENV = "development"
```
