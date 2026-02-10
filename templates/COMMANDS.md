# Agentic Dev Velocity Templates - Commands Reference

## Quick Reference

### Python Template ([`templates/python/`](templates/python/))

```bash
# Fast iteration (< 5s)
python -m ruff check src/                           # < 1s
python -m mypy src/                                 # < 2s
python -m pytest tests/unit tests/contract -v      # 0.04s

# Full test suite (CI only)
python -m pytest tests/ -v --cov=src/              # 30s+
```

### Java Spring Template ([`templates/java-spring/`](templates/java-spring/))

```bash
# Fast iteration (< 45s)
./gradlew compileJava compileFastJava --no-daemon  # 10-30s
./gradlew devFast --no-daemon                       # 5-15s

# Full test suite (CI only)
./gradlew testFull --no-daemon                      # 2-5min
```

### Java Tomcat Template ([`templates/java-tomcat/`](templates/java-tomcat/))

```bash
# Fast iteration (< 45s)
mvn compile -q -DskipTests                         # 10-30s
mvn test -Dtest=FastTests -DfailIfNoTests=false   # 5-15s

# Full test suite (CI only)
mvn test -q                                         # 2-5min
```

## Detailed Commands

### Python Commands

| Command | Description | Time | When |
|---------|-------------|------|------|
| `python -m ruff check src/ tests/` | Syntax and style lint | < 1s | Every change |
| `python -m ruff check src/ tests/ --fix` | Auto-fix lint issues | < 1s | After lint |
| `python -m mypy src/` | Type checking | < 2s | Before commit |
| `python -m pytest tests/unit tests/contract -v --tb=short` | Fast tests | **0.04s** | Every iteration |
| `python -m pytest tests/ -v --cov=src/` | Full tests | 30s+ | CI only |

### Python Docker Commands

```bash
# Build development image
docker build --target dev -t python-template:dev templates/python/

# Run tests in container
docker run -v $(pwd):/app -w /app python-template:dev \
  python -m pytest tests/unit tests/contract -v

# Build production image
docker build --target production -t python-template:prod templates/python/

# Run production container
docker run -p 8080:8080 python-template:prod
```

### Java Spring Commands

| Command | Description | Time | When |
|---------|-------------|------|------|
| `./gradlew compileJava compileFastJava` | Compile all sources | 10-30s | Before tests |
| `./gradlew devFast` | Fast tests only | 5-15s | Every iteration |
| `./gradlew bootJar` | Build JAR | 30-60s | Before deploy |
| `./gradlew testFull` | Full tests | 2-5min | CI only |

### Java Spring Docker Commands

```bash
# Build development image
docker build --target dev -t java-spring-template:dev templates/java-spring/

# Run tests in container
docker run -v $(pwd):/app -w /app java-spring-template:dev \
  ./gradlew devFast --no-daemon

# Build production image
docker build --target production -t java-spring-template:prod templates/java-spring/

# Run production container
docker run -p 8080:8080 java-spring-template:prod
```

### Java Tomcat Commands

| Command | Description | Time | When |
|---------|-------------|------|------|
| `mvn compile -q` | Compile all sources | 10-30s | Before tests |
| `mvn test -Dtest=FastTests` | Fast tests only | 5-15s | Every iteration |
| `mvn package -DskipTests -q` | Build WAR | 30-60s | Before deploy |
| `mvn test -q` | Full tests | 2-5min | CI only |

### Java Tomcat Docker Commands

```bash
# Build development image
docker build --target dev -t java-tomcat-template:dev templates/java-tomcat/

# Run tests in container
docker run -v $(pwd):/app -w /app java-tomcat-template:dev \
  mvn test -Dtest=FastTests -DfailIfNoTests=false

# Build production image
docker build --target production -t java-tomcat-template:prod templates/java-tomcat/

# Run production container
docker run -p 8080:8080 java-tomcat-template:prod
```

## GitHub CI Workflows

### Python CI Pipeline

```yaml
name: CI

on: [push, pull_request]

jobs:
  signal:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
      - run: pip install uv
      - run: uv sync --extra dev
      - run: uv run ruff check src/ tests/   # < 30s
      - run: uv run mypy src/              # < 30s
      - run: uv run pytest tests/unit tests/contract -v  # < 30s
```

### Java Spring CI Pipeline

```yaml
name: CI

on: [push, pull_request]

jobs:
  signal:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-java@v4
      - run: ./gradlew compileJava compileFastJava  # < 60s
      - run: ./gradlew devFast                    # < 60s
```

### Java Tomcat CI Pipeline

```yaml
name: CI

on: [push, pull_request]

jobs:
  signal:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-java@v4
      - run: mvn compile -q -DskipTests           # < 60s
      - run: mvn test -Dtest=FastTests -q        # < 60s
```

## mise-en-place Commands

### Install mise

```bash
# Linux/macOS
curl https://mise.run | sh

# Windows
winget install mise-en-place
```

### Run Commands with mise

```bash
# Python
mise run lint
mise run typecheck
mise run fast-test

# Java Spring
mise run compile
mise run fast-test
mise run build

# Java Tomcat
mise run compile
mise run fast-test
mise run build
```

## Performance Summary

| Template | Lint | TypeCheck | Fast Test | Full Test |
|----------|------|-----------|-----------|-----------|
| Python | < 1s | < 2s | **0.04s** | 30s+ |
| Java Spring | 10-30s | 10-30s | 5-15s | 2-5min |
| Java Tomcat | 10-30s | 10-30s | 5-15s | 2-5min |

## Agent Workflow Best Practices

1. **Make code change**
2. **Run lint** (`ruff` / `mvn checkstyle` / `./gradlew checkstyle`)
3. **Run fast tests** (unit + contract only)
4. **Commit** (if tests pass)
5. **CI runs full tests** (integration + e2e)

## Troubleshooting

### Python

```bash
# Dependencies not found
uv sync --extra dev

# Type checking errors
python -m mypy src/ --verbose

# Test failures
python -m pytest tests/unit tests/ -v --tb=long
```

### Java Spring

```bash
# Clean build
./gradlew clean
./gradlew compileJava

# Dependency issues
./gradlew --refresh-dependencies

# Test failures
./gradlew devFast --info
```

### Java Tomcat

```bash
# Clean build
mvn clean
mvn compile

# Dependency issues
mvn dependency:purge-local-repository
mvn compile

# Test failures
mvn test -Dtest=FastTests -e
```

## Quick Reference Card

```
┌─────────────────────────────────────────────────────────────┐
│                  AGENT LOOP QUICK REFERENCE                 │
├─────────────────────────────────────────────────────────────┤
│ Python                    │ Java Spring      │ Java Tomcat   │
├─────────────────────────────────────────────────────────────┤
│ ruff check src/          │ ./gradlew check │ mvn checkstyle│
│ mypy src/                │ ./gradlew check │ mvn checkstyle│
│ pytest tests/unit        │ ./gradlew       │ mvn test      │
│   tests/contract         │   devFast       │ -Dtest=Fast   │
├─────────────────────────────────────────────────────────────┤
│ Time: < 3s               │ Time: < 45s     │ Time: < 45s   │
│ Target: < 5s ✓           │ Target: < 30s   │ Target: < 30s │
└─────────────────────────────────────────────────────────────┘
```
