# Python Django Boilerplate - Agentic Dev Velocity

## Optimized for Fast Feedback Loops

This template implements agentic dev velocity principles for Django applications with:
- **uv** for 10-100x faster package management
- **pytest-django** with fast test source sets
- **GitHub Actions** with parallel jobs
- **Docker BuildKit** with cache mounts
- **Hot reload** with live code reloading

## Quick Commands

```bash
# Agent-fast (sub-second) - ALWAYS run this
make fast-test              # < 1s

# Type check (instant)
make typecheck              # < 500ms

# Lint (fast)
make lint                   # < 1s

# Full test suite (CI only - slow)
make test-full             # ~10-30s

# Run development server
make run                   # Hot reload enabled

# Build Docker image
make docker-build          # < 30s (warm)

# Lint Docker
make docker-lint           # < 5s

# Build DEB package
make build-deb             # < 5s
```

## Project Structure

```
django/
├── manage.py
├── pyproject.toml         # uv + tool configuration
├── pytest.ini            # pytest configuration
├── conftest.py           # pytest fixtures
├── .github/
│   └── workflows/
│       └── ci.yml        # Parallel CI pipeline
├── Dockerfile            # Multi-stage with BuildKit
├── Makefile              # Command catalogue
├── config/               # Django settings
│   ├── __init__.py
│   ├── settings.py
│   ├── urls.py
│   └── wsgi.py
├── apps/                  # Django apps
│   └── core/
│       ├── __init__.py
│       ├── models.py
│       ├── views.py
│       ├── urls.py
│       └── tests/
│           ├── __init__.py
│           ├── unit/
│           └── integration/
└── requirements.txt      # For compatibility
```

## Performance Targets

| Metric | Target | Typical |
|--------|--------|---------|
| Fast Test | < 1s | **0.5-1s** |
| Type Check | < 500ms | **200-500ms** |
| Lint | < 1s | **0.5-1s** |
| CI Signal | < 2s | **~2s** |
| Docker Warm Build | < 10s | **< 10s** |
| Docker Lint | < 5s | **~3s** |
| Hot Reload | < 1s | **< 500ms** |
| DEB Build | < 5s | **~5s** |

## Test Tiers

| Tier | Location | Framework | Speed | Use |
|------|----------|-----------|-------|-----|
| Fast | `apps/*/tests/unit/` | pytest | < 1s | Agent loop |
| Integration | `apps/*/tests/integration/` | pytest-django | ~5-10s | CI |
| Contract | `tests/contract/` | pytest + requests | ~10-30s | CI |

## Configuration

### uv (Fast Package Manager)

```bash
# Install dependencies
uv sync

# Add dependency
uv add django

# Add dev dependency
uv add --dev pytest-django

# Install from requirements.txt
uv pip install -r requirements.txt
```

### pytest.ini

```ini
[tool.pytest.ini_options]
DJANGO_SETTINGS_MODULE = config.settings
python_files = tests.py test_*.py *_test.py
addopts = -v --tb=short
testpaths = apps
```

### .github/workflows/ci.yml

```yaml
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: astral-sh/setup-uv@v4
      - run: uv sync
      - run: make lint

  typecheck:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: astral-sh/setup-uv@v4
      - run: uv sync
      - run: make typecheck

  fast-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: astral-sh/setup-uv@v4
      - run: uv sync
      - run: make fast-test
```

## Hot Reload

```bash
# Development with hot reload
make run

# Or directly
uvicorn config.asgi:app --reload --host 0.0.0.0 --port 8000
```

## Docker Optimization

```dockerfile
# syntax=docker/dockerfile:1.5
FROM python:3.12-slim AS builder

# Install uv
RUN pip install uv

# Copy files with cache mount
COPY --link pyproject.toml .
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-dev

# Production image
FROM python:3.12-slim AS runtime
COPY --from=builder /root/.cache/uv /root/.cache/uv
COPY --from=builder . .
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
```

## Performance Optimizations

1. **uv Package Manager**: 10-100x faster than pip
2. **Parallel CI Jobs**: Lint, typecheck, test run in parallel
3. **Fast Test Source Set**: Unit tests only, no DB
4. **Docker BuildKit**: Cache mounts for dependencies
5. **uvicorn with Reload**: Hot reload in < 500ms
6. **pyproject.toml**: Unified configuration

## Requirements

- Python 3.12+
- uv (installed via `pip install uv` or `curl -LsSf https://astral.sh/uv/install.sh | sh`)
- Docker (for containerized builds)

## License

MIT
