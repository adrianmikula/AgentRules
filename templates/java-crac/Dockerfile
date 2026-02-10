# syntax=docker/dockerfile:1.4

# ============================================================
# STAGE 1: Builder - Build the application
# ============================================================
# NOTE: CRaC requires a CRaC-enabled JDK (Azul Zulu, BellSoft Liberica Full,
# or Oracle JDK). Standard Docker images don't include CRaC support.
# For sub-second startup, install a CRaC-enabled JDK locally:
# - Azul Zulu: https://www.azul.com/downloads/?version=java-21-lts&package=jdk#crac
# - BellSoft Liberica Full: https://bell-sw.com/pages/downloads/
FROM bellsoft/liberica-openjdk-alpine:21 AS builder

WORKDIR /app

# Copy build files
COPY build.gradle settings.gradle gradle.properties ./

# Copy source code
COPY src ./src

# Install Gradle and build
RUN apk add --no-cache unzip curl && \
    curl -fsSL https://services.gradle.org/distributions/gradle-8.5-bin.zip -o /tmp/gradle.zip && \
    unzip -q /tmp/gradle.zip -d /opt && \
    rm /tmp/gradle.zip && \
    /opt/gradle-8.5/bin/gradle build -x test --no-daemon --console=plain

# ============================================================
# STAGE 2: Development Container
# ============================================================
# Provides a Java 21 development environment.
# For CRaC checkpoint/restore, use a CRaC-enabled JDK locally.
FROM bellsoft/liberica-openjdk-alpine:21 AS dev

WORKDIR /app

# Install development tools
RUN apk add --no-cache curl jq bash

# Copy the built JAR
COPY --from=builder /app/build/libs/*.jar app.jar

# Expose application port
EXPOSE 8080

# Default: run the application
CMD ["java", "-jar", "/app/app.jar"]

# ============================================================
# STAGE 3: Production - Optimized runtime
# ============================================================
FROM bellsoft/liberica-openjdk-alpine:21 AS production

WORKDIR /app

# Install minimal runtime
RUN apk add --no-cache curl bash

# Copy the built JAR
COPY --from=builder /app/build/libs/*.jar app.jar

# Expose application port
EXPOSE 8080

# Run with optimizations for production
CMD ["java", "-XX:+ShowCodeDetailsInExceptionMessages", "-jar", "/app/app.jar"]
