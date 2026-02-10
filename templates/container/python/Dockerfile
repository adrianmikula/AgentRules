# Python Boilerplate - Fast Docker Image
# Optimized for agentic development velocity

# Build stage - install dependencies
FROM python:3.12-slim-bookworm AS builder

WORKDIR /build

# Install uv (faster than pip)
RUN pip install --no-cache-dir uv

# Copy and install dependencies
COPY pyproject.toml ./
RUN uv pip install --system --no-cache . --extra dev

# Development stage - fast iteration
FROM python:3.12-slim-bookworm AS dev

WORKDIR /app

# Install uv
RUN pip install --no-cache-dir uv

# Copy only requirements for dev
COPY --from=builder /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

# Copy source
COPY src/ ./src/
COPY tests/ ./tests/
COPY pytest.ini ./
COPY conftest.py ./
COPY pyproject.toml ./

# Fast test command
CMD ["uv", "run", "pytest", "tests/unit", "tests/contract", "-v", "--tb=short"]

# Production stage - minimal image
FROM python:3.12-slim-bookworm AS production

WORKDIR /app

# Install uv
RUN pip install --no-cache-dir uv

# Copy only production dependencies
COPY --from=builder /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

# Copy source
COPY src/ ./src/
COPY pyproject.toml ./

# Run with uv
CMD ["uv", "run", "python", "-m", "src.app.main"]

# Multi-stage build targets
# Build: docker build --target dev -t app:dev .
# Run dev: docker run -v .:/app -w /app app:dev uv run pytest tests/unit -v
# Build prod: docker build --target production -t app:prod .
# Run prod: docker run app:prod

# Agent loop example:
# docker build --target dev -t app:dev .
# docker run -v $(pwd):/app -w /app app:dev uv run pytest tests/unit tests/contract -v --tb=short
