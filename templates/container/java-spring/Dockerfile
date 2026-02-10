# Java Spring Boilerplate - Fast Docker Image
# Optimized for agentic development velocity

# Build stage
FROM eclipse-temurin:17-jdk-alpine AS builder

WORKDIR /build

# Copy Gradle wrapper and build
COPY gradle ./gradle
COPY gradlew ./
COPY build.gradle ./
COPY settings.gradle ./
COPY gradle.properties ./

# Copy source
COPY src/main ./src/main
COPY src/fast ./src/fast

# Build with Gradle
RUN chmod +x gradlew
RUN ./gradlew bootJar --no-daemon -x test

# Development stage - fast iteration
FROM eclipse-temurin:17-jdk-alpine AS dev

WORKDIR /app

# Copy only necessary files for dev
COPY --from=builder /build/gradle ./gradle
COPY --from=builder /build/gradlew ./
COPY --from=builder /build/build.gradle ./
COPY --from=builder /build/settings.gradle ./
COPY --from=builder /build/gradle.properties ./

# Copy source
COPY src/main ./src/main
COPY src/fast ./src/fast

# Fast test command
CMD ["./gradlew", "devFast", "--no-daemon"]

# Production stage - layered JAR
FROM eclipse-temurin:17-jre-alpine AS production

WORKDIR /app

# Copy built JAR with layered extraction
COPY --from=builder /build/build/libs/*.jar app.jar

# Expose port
EXPOSE 8080

# Run with Spring profiles
CMD ["java", "-jar", "app.jar", "--spring.profiles.active=production"]

# Multi-stage build targets
# Build dev: docker build --target dev -t app-spring:dev .
# Run dev: docker run -v $(pwd):/app -w /app app-spring:dev ./gradlew devFast --no-daemon
# Build prod: docker build --target production -t app-spring:prod .
# Run prod: docker run -p 8080:8080 app-spring:prod

# Agent loop example:
# docker build --target dev -t app-spring:dev .
# docker run -v $(pwd):/app -w /app app-spring:dev ./gradlew devFast --no-daemon
