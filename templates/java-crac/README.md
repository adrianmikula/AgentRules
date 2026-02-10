# Java CRaC Template

Java Spring Boot template with CRaC (Coordinated Restore at Checkpoint) support for **sub-second application startup**.

## Why CRaC?

Traditional JVM applications have slow startup times (2-5 seconds) due to:
- Class loading
- JIT compilation
- Framework initialization

CRaC allows you to:
1. **Start the application once** and create a checkpoint
2. **Restore from checkpoint** in milliseconds on subsequent runs

## Performance Comparison

| Metric | Standard JVM | CRaC |
|--------|-------------|------|
| Cold Start | 2-5s | 2-5s |
| Restored Start | N/A | **< 100ms** |
| Memory | Baseline | ~20% more |

## Requirements

- **Java 21** with CRaC support (Azul Zulu, Oracle GraalVM, or Eclipse Adoptium)
- **Linux** (CRaC requires Linux kernel features)

### Recommended JDK Distributions

- [Azul Zulu JDK 21 with CRaC](https://www.azul.com/downloads/?version=jdk-21-lts&os=linux&architecture=x86-64-bit&package=jdk-crac&hw=&hdr=&os=&utm_source=website&utm_medium=logo&utm_campaign=&utm_content)
- [Oracle GraalVM with CRaC](https://www.graalvm.org/)
- [Eclipse Adoptium with CRaC](https://adoptium.net/)

## Quick Start

```bash
# Install Java 21 with CRaC
mise install java 21-temurin-crac

# Build
./gradlew build

# Run fast tests
./gradlew fastTest

# Create checkpoint
java -XX:CRaCCheckpointTo=/tmp/cr -jar build/libs/*.jar

# Restore from checkpoint (milliseconds!)
java -XX:CRaCRestoreFrom=/tmp/cr -jar build/libs/*.jar
```

## Docker

```bash
# Build with checkpoint
docker build -t java-crac:dev .

# Run (will create checkpoint on first run)
docker run -p 8080:8080 java-crac:dev

# Subsequent runs restore from checkpoint
docker run -p 8080:8080 java-crac:prod
```

## Commands

| Command | Description |
|---------|-------------|
| `./gradlew compileJava` | Compile sources |
| `./gradlew fastTest` | Run fast tests (no Spring context) |
| `./gradlew fullTest` | Run all tests |
| `./gradlew build` | Build JAR |
| `./gradlew bootRun` | Run with bootRun |

## Project Structure

```
java-crac/
├── src/
│   ├── main/java/
│   │   └── com/example/app/
│   │       ├── JavaCracApplication.java  # CRaC Resource
│   │       ├── controller/
│   │       │   └── UserController.java
│   │       └── domain/
│   │           └── User.java
│   └── fast/java/
│       └── com/example/fast/
│           └── FastTests.java           # Unit tests (no Spring)
├── build.gradle
├── Dockerfile
└── mise.toml
```

## CRaC Workflow

### 1. Development Loop

```bash
# Make code change
./gradlew compileJava  # < 5s
./gradlew fastTest    # < 2s
```

### 2. Create Checkpoint

```bash
java -XX:CRaCCheckpointTo=/tmp/cr -jar build/libs/app.jar &
PID=$!
sleep 5  # Wait for app to start
jcmd $PID JDK.checkpoint
wait $PID
```

### 3. Production Restore

```bash
java -XX:CRaCRestoreFrom=/tmp/cr -jar build/libs/app.jar
# Startup: < 100ms!
```

## Performance Targets

| Metric | Target | Typical |
|--------|--------|---------|
| Fast Tests | < 5s | 1-2s |
| Compile | < 10s | 3-5s |
| CRaC Restore | < 100ms | 50-100ms |

## Limitations

- CRaC requires Linux (checkpoints use `fork()` and `ptrace`)
- Increased memory footprint (~20%)
- Not all libraries are checkpoint-safe
- Requires JDK with CRaC support
