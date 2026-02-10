# Python Boilerplate - Agentic Dev Velocity

## Structure

```
python-boilerplate/
├── src/
│   └── app/
│       ├── __init__.py
│       ├── main.py          # Fast entrypoint (lazy imports)
│       ├── models.py        # Pure Python models
│       └── services.py      # Business logic
├── tests/
│   ├── __init__.py
│   ├── unit/
│   │   └── test_models.py   # Fast unit tests (no fixtures)
│   ├── contract/
│   │   └── test_api.py      # API/schema checks
│   └── integration/
│       └── test_services.py # Slow tests (CI only)
├── pyproject.toml           # uv/pip config with tool configs
├── Makefile                # Command catalogue
├── .mypy.ini              # Fast incremental type checking
├── pytest.ini            # Minimal pytest config
└── .python-version       # For uv/pipx
```

## Key Optimizations Applied

### 1. Tiered Test Strategy

**Fast tests (agents run these):**
```bash
pytest tests/unit/ tests/contract/ -v --no-cov
```

**CI only (never locally):**
```bash
pytest tests/integration/ -v --cov
```

### 2. Lazy Imports (Kill Import-Time Side Effects)

```python
# main.py - Fast entrypoint
def main():
    # Lazy imports - only load when needed
    from .services import create_service, process_data
    from .models import User
    
    service = create_service()
    result = process_data(User(name="test"))
    return result

if __name__ == "__main__":
    main()
```

### 3. MyPy Incremental Type Checking

```ini
# .mypy.ini
[mypy]
python_version = "3.11"
incremental = True
cache_dir = .mypy_cache
follow_imports = silent
warn_return_any = True
```

### 4. Minimal Pytest Configuration

```ini
# pytest.ini
[pytest]
testpaths = tests/unit tests/contract
python_files = test_*.py
python_classes = Test*
python_functions = test_*
addopts = 
    -v
    --tb=short
    --no-header
filterwarnings =
    ignore::DeprecationWarning
```

## Commands

```bash
# Agent-fast command (seconds)
make fast-test

# Type check only (instant feedback)
make typecheck

# Lint (fast syntax check)
make lint

# Full test suite (CI only)
make test-full

# Development server (optional)
make dev
```

## Makefile (Command Catalogue)

```makefile
.PHONY: fast-test typecheck lint test-full dev

fast-test:
    @pytest tests/unit tests/contract -v --no-cov --tb=short

typecheck:
    @mypy src/ --no-error-summary

lint:
    @ruff check src/ tests/unit/ tests/contract/

test-full:
    @pytest tests/ -v --tb=short

dev:
    @python -m src.app.main
```

## Key Principles

1. **Never run full pytest locally** - Only `unit` + `contract` tiers
2. **Lazy imports** - No module-level DB/config/env reads
3. **Type checks as first signal** - Use `mypy --incremental`
4. **Minimal pytest plugins** - No coverage, asyncio, django in fast mode
5. **Single entrypoint** - One `make fast-test` for agents
