# syntax=docker/dockerfile:1.6
# Enable BuildKit advanced features

# =============================================================================
# BUILDER STAGE - Install dependencies with cache mounts
# =============================================================================
FROM --platform=$BUILDPLATFORM python:3.13-slim AS builder

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
    pip install --no-cache-dir uv && \
    uv pip install --system --no-dev -r pyproject.toml

# Copy source code
COPY src/ ./src/

# =============================================================================
# DEVELOPMENT STAGE - Hot reload support
# =============================================================================
FROM python:3.13-slim AS development

# Install development dependencies
COPY pyproject.toml uv.lock ./
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --no-cache-dir uv && \
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
FROM python:3.13-slim AS production

# Install only runtime dependencies
COPY pyproject.toml uv.lock ./
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --no-cache-dir uv && \
    uv pip install --system --no-dev -r pyproject.toml

# Copy source code
COPY --from=builder /app/src/ ./src/

# Create non-root user for security
RUN useradd --create-home --shell /bin/bash appuser && \
    chown -R appuser:appuser /app
USER appuser

WORKDIR /app

EXPOSE 8000

CMD ["uv", "run", "uvicorn", "src.app.main:app", "--host", "0.0.0.0", "--port", "8000"]
