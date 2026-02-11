# syntax=docker/dockerfile:1.6
# Optimized Docker Build - Agentic Dev Velocity
# Features: BuildKit, layer caching, dependency cache mounts, multi-stage

# =============================================================================
# COMMON BUILD ARGUMENTS
# =============================================================================
ARG PYTHON_VERSION=3.13
ARG UV_VERSION=0.5

# =============================================================================
# BUILDER STAGE - Install dependencies with cache mounts
# =============================================================================
FROM --platform=$BUILDPLATFORM python:${PYTHON_VERSION}-slim AS builder

# Install build dependencies (cached via BuildKit mount)
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    musl-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy only dependency files first for better layer caching
COPY pyproject.toml uv.lock ./

# Install dependencies with pip cache mount
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --no-cache-dir uv==${UV_VERSION} && \
    uv pip install --system --no-dev -r pyproject.toml

# Copy source code
COPY src/ ./src/

# =============================================================================
# DEVELOPMENT STAGE - Hot reload support
# =============================================================================
FROM python:${PYTHON_VERSION}-slim AS development

# Install development dependencies
COPY pyproject.toml uv.lock ./
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --no-cache-dir uv==${UV_VERSION} && \
    uv pip install --system -r pyproject.toml

WORKDIR /app
COPY src/ ./src/

# Expose default port
EXPOSE 8000

# Default command for development
CMD ["uv", "run", "uvicorn", "src.app.main:app", "--reload", "--host", "0.0.0.0", "--port", "8000"]

# =============================================================================
# PRODUCTION STAGE - Minimal image
# =============================================================================
FROM python:${PYTHON_VERSION}-slim AS production

# Install only runtime dependencies
COPY pyproject.toml uv.lock ./
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --no-cache-dir uv==${UV_VERSION} && \
    uv pip install --system --no-dev -r pyproject.toml

WORKDIR /app

# Copy only runtime dependencies (not dev)
COPY --from=builder /root/.cache/pip /root/.cache/pip
COPY src/ ./src/

# Create non-root user
RUN groupadd -r app && useradd -r -g app app
USER app

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')" || exit 1

# Expose default port
EXPOSE 8000

# Default command for production
CMD ["uv", "run", "uvicorn", "src.app.main:app", "--host", "0.0.0.0", "--port", "8000"]

# =============================================================================
# DOCKER BUILD OPTIMIZATIONS
# =============================================================================
# 1. Layer caching: COPY dependency files first, source last
# 2. Cache mounts: apt, pip, uv caches persisted across builds
# 3. Multi-stage: Builder → Development → Production
# 4. BuildKit inline cache: BUILDKIT_INLINE_CACHE=1
# 5. GitHub Actions cache: cache-from: type=gha,scope=docker
# 6. Parallel builds: --mount=type=cache,sharing=locked

# =============================================================================
# FAST DOCKER BUILD COMMANDS
# =============================================================================
# Build with cache (local)
# docker build --build-arg BUILDKIT_INLINE_CACHE=1 -t app:dev --target development .

# Build with GHA cache (CI)
# docker buildx build --push \
#   --cache-from type=gha,scope=docker \
#   --cache-to type=gha,mode=max,scope=docker \
#   --target production -t app:latest .

# Fast layer inspection
# docker buildx du (disk usage)
# docker history app:dev (layer breakdown)
