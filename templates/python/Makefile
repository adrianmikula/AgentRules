# Python Boilerplate - Command Catalogue
# Single entrypoint for all agent operations

.PHONY: fast-test typecheck lint test-full dev clean

# Agent-fast command (seconds) - ALWAYS run this
fast-test:
	@echo "Running fast unit + contract tests..."
	@pytest tests/unit tests/contract -v --no-cov --tb=short

# Type check only (instant feedback)
typecheck:
	@mypy src/ --no-error-summary

# Lint (fast syntax check)
lint:
	@ruff check src/ tests/unit/ tests/contract/

# Full test suite (CI only - slow)
test-full:
	@pytest tests/ -v --tb=short

# Development server
dev:
	@python -m src.app.main

# Clean cache files
clean:
	@rm -rf .mypy_cache .pytest_cache __pycache__ src/**/__pycache__
