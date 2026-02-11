# syntax=docker/dockerfile:1.6
# IntelliJ Plugin Docker Build - Agentic Dev Velocity

# =============================================================================
# BUILDER STAGE
# =============================================================================
FROM eclipse-temurin:21-jdk-alpine AS builder

WORKDIR /app

# Copy build files first for better layer caching
COPY build.gradle settings.gradle gradle.properties ./

# Copy source code
COPY src/ ./src/

# =============================================================================
# DEVELOPMENT STAGE
# =============================================================================
FROM eclipse-temurin:21-jdk-alpine AS development

# Install development tools
RUN apk add --no-cache bash curl vim

WORKDIR /app

# Copy dependency cache
COPY --from=builder /root/.gradle /root/.gradle

# Copy source and build files
COPY build.gradle settings.gradle gradle.properties ./
COPY src/ ./src/

EXPOSE 8110

CMD ["./gradlew", "devFast", "--no-daemon"]

# =============================================================================
# PRODUCTION STAGE
# =============================================================================
FROM eclipse-temurin:21-jre-alpine AS production

WORKDIR /app

# Create non-root user
RUN addgroup -S plugin && adduser -S plugin -G plugin
USER plugin

# Copy built artifact
COPY --from=builder /app/build/distributions/*.zip /plugin.zip

EXPOSE 8110

CMD ["unzip", "-q", "/plugin.zip"]

# =============================================================================
# BUILD COMMANDS
# =============================================================================
# Build development image
# docker build --target development -t plugin:dev .

# Build production image
# docker build --target production -t plugin:latest .

# Build with cache
# docker build --build-arg BUILDKIT_INLINE_CACHE=1 -t plugin:latest .
