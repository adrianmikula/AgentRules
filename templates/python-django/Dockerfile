# syntax=docker/dockerfile:1.5
# Dockerfile - Python Django with BuildKit optimization

# =============================================================================
# Stage 1: Builder - Install dependencies with uv
# =============================================================================
FROM python:3.12-slim AS builder

# Install uv (10-100x faster than pip)
RUN pip install --no-cache-dir uv

# Copy project files
WORKDIR /app

# Copy pyproject.toml first for dependency caching
COPY --link pyproject.toml .

# Install dependencies with uv (cached)
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-dev

# =============================================================================
# Stage 2: Development - With all dependencies
# =============================================================================
FROM python:3.12-slim AS development

# Install uv
RUN pip install --no-cache-dir uv

# Set working directory
WORKDIR /app

# Copy from builder (reuses cached dependencies)
COPY --from=builder /root/.cache/uv /root/.cache/uv
COPY --from=builder /app /app

# Install dev dependencies
RUN uv sync

# Expose port
EXPOSE 8000

# Entrypoint for development
ENTRYPOINT ["uv", "run", "uvicorn", "config.asgi:application", "--reload", "--host", "0.0.0.0", "--port", "8000"]

# =============================================================================
# Stage 3: Production - Minimal image
# =============================================================================
FROM python:3.12-slim AS production

# Install uv
RUN pip install --no-cache-dir uv

# Set working directory
WORKDIR /app

# Copy from builder (only production dependencies)
COPY --from=builder /root/.cache/uv /root/.cache/uv
COPY --from=builder /app /app

# Create non-root user
RUN groupadd --gid 1000 appgroup && \
    useradd --uid 1000 --gid appgroup --shell /bin/bash --create-home appuser

# Change ownership
RUN chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

# Expose port
EXPOSE 8000

# Entrypoint
ENTRYPOINT ["uv", "run", "python", "manage.py", "runserver", "0.0.0.0:8000"]

# =============================================================================
# Build Commands
# =============================================================================
#
# Build development image:
#   docker build --target development -t python-django:dev .
#
# Build production image:
#   docker build --target production -t python-django:latest .
#
# Build with cache mounts (requires Docker BuildKit):
#   DOCKER_BUILDKIT=1 docker build -t python-django:latest .
#
# Run development:
#   docker run -p 8000:8000 python-django:dev
#
# Run production:
#   docker run -p 8000:8000 python-django:latest
#
