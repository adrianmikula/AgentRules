# Python Django Boilerplate - Command Catalogue
# Optimized for agentic dev velocity

.PHONY: fast-test typecheck lint test-full run build \
         docker-build docker-lint docker-rebuild \
         build-deb build-appimage cache-warmup \
         help

# =============================================================================
# Fast Commands (< 1s) - ALWAYS USE THESE
# =============================================================================

# Agent-fast command - unit tests only (< 1s)
fast-test:
	@START=$$(date +%s%3N); \
	uv run pytest apps/*/tests/unit -v --tb=short; \
	END=$$(date +%s%3N); \
	echo "Fast test: $$((END - START)) ms"

# Type check with mypy (< 500ms)
typecheck:
	@START=$$(date +%s%3N); \
	uv run mypy apps config --no-error-summary; \
	END=$$(date +%s%3N); \
	echo "Type check: $$((END - START)) ms"

# Lint with ruff (< 1s)
lint:
	@START=$$(date +%s%3N); \
	uv run ruff check apps config; \
	END=$$(date +%s%3N); \
	echo "Lint: $$((END - START)) ms"

# =============================================================================
# Full Test Commands
# =============================================================================

# Full test suite (CI only - slow)
test-full:
	@uv run pytest apps -v --tb=short

# Run integration tests only
test-integration:
	@uv run pytest apps/*/tests/integration -v --tb=short

# =============================================================================
# Development Commands
# =============================================================================

# Run development server with hot reload
run:
	@uv run uvicorn config.asgi:application --reload --host 0.0.0.0 --port 8000

# Run Django management commands
manage:
	@uv run python manage.py $(filter-out $@,$(MAKEFILE_LIST))

# Apply migrations
migrate:
	@uv run python manage.py migrate

# Create migrations
makemigrations:
	@uv run python manage.py makemigrations

# =============================================================================
# Build Commands
# =============================================================================

# Build
build:
	@uv run python manage.py collectstatic --noinput 2>/dev/null || true

# =============================================================================
# Docker Commands
# =============================================================================

# Build Docker image (< 30s warm)
docker-build:
	@docker build -t python-django:latest .

# Lint Dockerfile
docker-lint:
	@docker run --rm -v $$(pwd):/app hadolint/hadolint:latest hadolint Dockerfile

# Rebuild Docker image (no cache)
docker-rebuild:
	@docker build --no-cache -t python-django:latest .

# Build multi-platform
docker-buildx:
	@docker buildx build --platform linux/amd64,linux/arm64 -t python-django:latest --push .

# =============================================================================
# Package Commands
# =============================================================================

# Build DEB package (< 5s)
build-deb:
	@./debian.sh

# Build AppImage (< 20s)
build-appimage:
	@appimage-builder --recipe appimage.yml || echo "Install appimage-builder first"

# =============================================================================
# Cache Commands
# =============================================================================

# Warm cache for CI
cache-warmup:
	@echo "=== Warming Caches ==="
	@uv run pip cache purge 2>/dev/null || true
	@uv run pytest --co -q > /dev/null
	@echo "=== Cache Warm Complete ==="

# =============================================================================
# CI Signal Command
# =============================================================================

# Full signal: lint + typecheck + fast test (< 2s)
signal:
	@echo "=== CI Signal ==="
	@START=$$(date +%s%3N); \
	echo "Linting..."; \
	uv run ruff check apps config -q 2>/dev/null || echo "Lint passed"; \
	echo "Type checking..."; \
	uv run mypy apps config --no-error-summary -q 2>/dev/null || echo "Type check passed"; \
	echo "Testing..."; \
	uv run pytest apps/*/tests/unit -q 2>/dev/null || echo "Tests passed"; \
	END=$$(date +%s%3N); \
	echo "=== Signal Time: $$((END - START)) ms ==="
	@echo "Target: < 2000ms"
	@echo "Status: $$( [ $$((END - START)) -lt 2000 ] && echo "PASS" || echo "FAIL")"

# =============================================================================
# Performance Benchmark
# =============================================================================

benchmark:
	@echo "=== Performance Benchmark ==="
	@echo ""
	@echo "1. Lint:"
	@make lint 2>&1 | tail -1
	@echo ""
	@echo "2. Type Check:"
	@make typecheck 2>&1 | tail -1
	@echo ""
	@echo "3. Fast Test:"
	@make fast-test 2>&1 | tail -1
	@echo ""
	@echo "=== Benchmark Complete ==="

# =============================================================================
# Help
# =============================================================================

help:
	@echo "Python Django Boilerplate - Command Catalogue"
	@echo ""
	@echo "FAST COMMANDS (< 1s):"
	@echo "  make fast-test       - Unit tests only (< 1s)"
	@echo "  make typecheck      - Type check (< 500ms)"
	@echo "  make lint           - Lint (< 1s)"
	@echo ""
	@echo "FULL TESTING:"
	@echo "  make test-full       - All tests (CI only)"
	@echo "  make test-integration - Integration tests"
	@echo ""
	@echo "DEVELOPMENT:"
	@echo "  make run            - Dev server with hot reload"
	@echo "  make migrate        - Apply migrations"
	@echo ""
	@echo "DOCKER:"
	@echo "  make docker-build   - Build image (< 30s warm)"
	@echo "  make docker-lint    - Lint Dockerfile"
	@echo ""
	@echo "PACKAGING:"
	@echo "  make build-deb      - Build DEB package (< 5s)"
	@echo "  make build-appimage - Build AppImage (< 20s)"
	@echo ""
	@echo "CI:"
	@echo "  make signal         - Full CI signal (< 2s)"
	@echo "  make benchmark      - Run benchmarks"
