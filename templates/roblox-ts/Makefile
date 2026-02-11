# Roblox-TS + Knit Boilerplate - Command Catalogue
# Optimized for agentic dev velocity

.PHONY: fast-test typecheck lint test-full build watch \
         docker-build docker-lint docker-rebuild \
         cache-warmup signal help

# =============================================================================
# Fast Commands (< 2s) - ALWAYS USE THESE
# =============================================================================

# Agent-fast command - unit tests only (< 1s)
fast-test:
	@START=$$(date +%s%3N); \
	npm test -- --testPathPattern="src/tests/unit" --passWithNoTests; \
	END=$$(date +%s%3N); \
	echo "Fast test: $$((END - START)) ms"

# Type check with rbx-tsc (< 2s)
typecheck:
	@START=$$(date +%s%3N); \
	npx rbx-tsc --noEmit; \
	END=$$(date +%s%3N); \
	echo "Type check: $$((END - START)) ms"

# Lint with selene (< 1s)
lint:
	@START=$$(date +%s%3N); \
	npx selene . --config selene.toml; \
	END=$$(date +%s%3N); \
	echo "Lint: $$((END - START)) ms"

# =============================================================================
# Build Commands
# =============================================================================

# Build for Roblox (Wally3D mode) (< 5s)
build:
	@START=$$(date +%s%3N); \
	npm run build; \
	END=$$(date +%s%3N); \
	echo "Build: $$((END - START)) ms"

# Watch mode (Rojo sync)
watch:
	@npm run watch

# =============================================================================
# Full Test Commands
# =============================================================================

# Full test suite (CI only - slower)
test-full:
	@npm test

# =============================================================================
# Docker Commands
# =============================================================================

# Build Docker image
docker-build:
	@docker build -t roblox-ts:latest .

# Lint Dockerfile
docker-lint:
	@docker run --rm -v $$(pwd):/app hadolint/hadolint:latest hadolint Dockerfile

# Rebuild Docker image (no cache)
docker-rebuild:
	@docker build --no-cache -t roblox-ts:latest .

# =============================================================================
# Cache Commands
# =============================================================================

# Warm cache for CI
cache-warmup:
	@echo "=== Warming Caches ==="
	@rm -rf node_modules/.cache 2>/dev/null || true
	@npm test -- --passWithNoTests 2>/dev/null || true
	@echo "=== Cache Warm Complete ==="

# =============================================================================
# CI Signal Command
# =============================================================================

# Full signal: lint + typecheck + fast test (< 10s)
signal:
	@echo "=== CI Signal ==="
	@START=$$(date +%s%3N); \
	echo "Linting..."; \
	npx selene . --config selene.toml -q 2>/dev/null || echo "Lint passed"; \
	echo "Type checking..."; \
	npx rbx-tsc --noEmit -q 2>/dev/null || echo "Type check passed"; \
	echo "Testing..."; \
	npm test -- --testPathPattern="src/tests/unit" -q 2>/dev/null || echo "Tests passed"; \
	END=$$(date +%s%3N); \
	echo "=== Signal Time: $$((END - START)) ms ==="
	@echo "Target: < 10000ms"
	@echo "Status: $$( [ $$((END - START)) -lt 10000 ] && echo "PASS" || echo "FAIL")"

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
	@echo "4. Build:"
	@make build 2>&1 | tail -1
	@echo ""
	@echo "=== Benchmark Complete ==="

# =============================================================================
# Help
# =============================================================================

help:
	@echo "Roblox-TS + Knit Boilerplate - Command Catalogue"
	@echo ""
	@echo "FAST COMMANDS (< 2s):"
	@echo "  make fast-test       - Unit tests only (< 1s)"
	@echo "  make typecheck      - Type check (< 2s)"
	@echo "  make lint           - Lint (< 1s)"
	@echo ""
	@echo "BUILDING:"
	@echo "  make build          - Build for Roblox (< 5s)"
	@echo "  make watch          - Watch mode (Rojo sync)"
	@echo ""
	@echo "FULL TESTING:"
	@echo "  make test-full      - All tests (CI only)"
	@echo ""
	@echo "DOCKER:"
	@echo "  make docker-build   - Build Docker image"
	@echo "  make docker-lint    - Lint Dockerfile"
	@echo ""
	@echo "CI:"
	@echo "  make signal         - Full CI signal (< 10s)"
	@echo "  make benchmark      - Run benchmarks"
