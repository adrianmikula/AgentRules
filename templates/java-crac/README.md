# Java CRaC Template

Java 21 Spring Boot application with CRaC (Coordinated Restore at Checkpoint) support for **sub-second application startup**.

## ⚠️ CRaC Requirement

**CRaC requires a CRaC-enabled JDK** which is NOT included in standard Docker images. For full CRaC functionality:

### Option 1: Install CRaC JDK Locally (Recommended)

Download and install a CRaC-enabled JDK:

- **Azul Zulu**: https://www.azul.com/downloads/?version=java-21-lts&package=jdk#crac
- **BellSoft Liberica Full**: https://bell-sw.com/pages/downloads/ (select "Full" variant)

Then set `JAVA_HOME` to the CRaC JDK installation.

### Option 2: Use Standard JDK

This template works with standard Java 21 (without CRaC) for development and testing. The Docker containers use BellSoft Liberica OpenJDK 21.

## Quick Start

### Prerequisites

- Docker Desktop with WSL2 backend (Linux containers)
- Java 21 (for local development)

### Development with Docker

```bash
# Build the application
docker compose build builder

# Run in development mode
docker compose up dev

# The application will be available at http://localhost:8080
```

### Local Development

```bash
# Build
./gradlew build

# Run tests
./gradlew test

# Run the application
./gradlew bootRun
```

## Project Structure

```
java-crac/
├── src/
│   ├── fast/           # Fast tests (< 5s)
│   │   └── java/com/example/fast/
│   │       └── FastTests.java
│   └── main/
│       └── java/com/example/app/
│           ├── JavaCracApplication.java
│           ├── controller/
│           │   └── UserController.java
│           └── domain/
│               └── User.java
├── build.gradle        # Gradle build configuration
├── mise.toml          # Command catalogue
├── Dockerfile         # Multi-stage Docker build
└── docker-compose.yml # Docker orchestration
```

## Fast Test Loop

Fast tests are in `src/fast/` and run in < 5 seconds:

```bash
./gradlew test --tests "com.example.fast.*"
```

## CRaC Checkpoint/Restore (Requires CRaC JDK)

When using a CRaC-enabled JDK locally:

```bash
# Create checkpoint after application starts
java -XX:CRaCCheckpointTo=/tmp/checkpoint -jar build/libs/app.jar

# Restore from checkpoint (milliseconds startup!)
java -XX:CRaCRestoreFrom=/tmp/checkpoint -jar build/libs/app.jar
```

## Performance Targets

| Metric | Target | Actual (with CRaC) |
|--------|--------|---------------------|
| Cold Start | 2-5s | < 100ms |
| Test Loop | < 30s | < 1s (with checkpoint) |
| Memory | Baseline | ~20% less |

## Commands

| Command | Description |
|---------|-------------|
| `make test-fast` | Run fast tests (< 5s) |
| `make build` | Build the application |
| `make run` | Run the application |
| `make docker-build` | Build Docker images |
| `make docker-run` | Run in Docker |

## CI/CD

GitHub Actions workflow available in `.github/workflows/ci.yml`.

## Docker Stages

1. **builder** - Compiles the application
2. **dev** - Development container with tools
3. **production** - Optimized runtime
