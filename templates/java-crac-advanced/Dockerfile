# Dockerfile - Advanced Java CRaC with BuildKit Optimization
# Implements Alibaba, Google, Microsoft techniques for fast builds

# syntax=docker/dockerfile:1.5
# Enable BuildKit features

# =============================================================================
# Stage 1: Builder - Multi-stage with cache mounts
# =============================================================================
FROM eclipse-temurin:21-jdk-alpine AS builder

# Install build tools
RUN apk add --no-cache bash curl findutils

# Set working directory
WORKDIR /workspace

# Copy source with dependency caching
COPY --link build.gradle gradle.properties ./
COPY --link src ./src

# Create Gradle wrapper
RUN if [ ! -f gradlew ]; then \
    curl -sL https://services.gradle.org/distributions/gradle-8.5-bin.zip -o /tmp/gradle.zip && \
    unzip -q /tmp/gradle.zip -d /opt && \
    rm /tmp/gradle.zip; \
    fi

# Build with Gradle (cached dependencies)
RUN --mount=type=cache,target=/root/.gradle/caches \
    --mount=type=cache,target=/root/.gradle/wrapper \
    ./gradlew bootJar -x test --no-daemon

# =============================================================================
# Stage 2: Runtime - Minimal image with CRaC support
# =============================================================================
FROM eclipse-temurin:21-jre-alpine AS runtime

# Install CRaC and runtime tools
RUN apk add --no-cache \
    bash \
    curl \
    # Required for CRaC
    libc6-compat

# Create non-root user
RUN addgroup -g 1000 appgroup && \
    adduser -u 1000 -G appgroup -s /bin/sh -D appuser

# Working directory
WORKDIR /workspace

# Copy built artifact
COPY --from=builder /workspace/build/libs/*.jar app.jar

# Health check
HEALTHCHECK --interval=10s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8080/actuator/health || exit 1

# Expose port
EXPOSE 8080

# Run as non-root user
USER appuser

# CRaC environment variables
ENV CRAC_CHECKPOINT_TIMEOUT=5000
ENV CRAC_RESTORE_TIMEOUT=100

# Entrypoint
ENTRYPOINT ["java", "-XX:CRaCRestoreFrom=/workspace/checkpoints", "-jar", "/workspace/app.jar"]

# =============================================================================
# Stage 3: Checkpoint - For instant restore
# =============================================================================
FROM runtime AS checkpoint

# Create checkpoint directory
RUN mkdir -p /workspace/checkpoints

# Entrypoint that creates checkpoint
ENTRYPOINT ["java", "-XX:CRaCCheckpointTo=/workspace/checkpoints", "-jar", "/workspace/app.jar"]

# =============================================================================
# Development Stage - With all build tools
# =============================================================================
FROM eclipse-temurin:21-jdk-alpine AS dev

# Install development tools
RUN apk add --no-cache \
    bash \
    curl \
    git \
    vim \
    nano \
    htop \
    # Gradle
    unzip

# Working directory
WORKDIR /workspace

# Copy Gradle files first for caching
COPY --link build.gradle gradle.properties ./

# Copy source
COPY --link src ./src

# Create Gradle wrapper if needed
RUN if [ ! -f gradlew ]; then \
    curl -sL https://services.gradle.org/distributions/gradle-8.5-bin.zip -o /tmp/gradle.zip && \
    unzip -q /tmp/gradle.zip -d /opt && \
    ln -sf /opt/gradle-8.5/bin/gradle /usr/local/bin/gradle && \
    rm /tmp/gradle.zip; \
    fi

# Mount caches
VOLUME ["/root/.gradle/caches", "/root/.gradle/wrapper"]

# Development entrypoint
ENTRYPOINT ["/bin/bash"]

# =============================================================================
# Build Commands Reference
# =============================================================================
# 
# Build production image:
#   docker build -t java-crac-advanced:latest .
#
# Build with cache mounts (requires Docker BuildKit):
#   DOCKER_BUILDKIT=1 docker build \
#     --build-arg BUILDKIT_INLINE_CACHE=1 \
#     -t java-crac-advanced:latest .
#
# Build multi-platform:
#   docker buildx build \
#     --platform linux/amd64,linux/arm64 \
#     -t java-crac-advanced:latest \
#     --push .
#
# Create checkpoint image:
#   docker build --target checkpoint -t java-crac-checkpoint:latest .
#
# Development image:
#   docker build --target dev -t java-crac-dev:latest .
#
# Run with checkpoint:
#   docker run -p 8080:8080 \
#     -v $(pwd)/checkpoints:/workspace/checkpoints \
#     java-crac-advanced:latest
#
