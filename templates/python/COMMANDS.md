# Python Boilerplate - Commands Reference

## Verified Commands (All Tested ✓)

| Command | Description | Time | When to Run |
|---------|-------------|------|-------------|
| `mise run lint` | Fast syntax/lint check | < 1s | Every code change |
| `mise run lint-fix` | Auto-fix lint issues | < 1s | After lint errors |
| `mise run typecheck` | MyPy type checking | < 2s | Before committing |
| `mise run fast-test` | Unit + contract tests | **0.04s** | **Every iteration** |
| `mise run dev` | Run main application | N/A | Development |
| `mise run test-full` | All tests + coverage | 30s+ | CI only |
| `mise run clean` | Clean cache files | N/A | When stuck |

## Test Results

```
8 passed in 0.04s
```

✓ All unit tests passing  
✓ All contract tests passing  
✓ Lint auto-fix working

## Using mise-en-place (Recommended)

This project uses [mise-en-place](https://mise.jdx.dev/) to catalogue commands. Agents can easily discover and run whitelisted commands.

### List available commands:
```bash
mise tasks
```

### Run a command:
```bash
mise run lint
mise run fast-test
mise run typecheck
```

## Alternative: Using uv directly

### Install dependencies:
```bash
uv sync
uv sync --extra dev
```

### Run commands:
```bash
uv run pytest tests/unit tests/contract -v --tb=short
uv run ruff check src/ tests/unit/ tests/contract/
uv run mypy src/
```

## Commands Detail

### 1. Lint (Fastest Feedback)
```bash
mise run lint
# or: uv run ruff check src/ tests/unit/ tests/contract/
```

Runs Ruff linter on source and test files. Catches syntax errors and style issues instantly.

**Expected output:**
```
src/app/main.py: ok
src/app/models.py: ok
tests/unit/test_models.py: ok
tests/contract/test_api.py: ok
```

### 2. Lint Fix
```bash
mise run lint-fix
# or: uv run ruff check src/ tests/unit/ tests/contract/ --fix
```

Auto-fixes lint issues (whitespace, import sorting, etc.).

### 3. Type Check
```bash
mise run typecheck
# or: uv run mypy src/
```

Runs MyPy incremental type checking. Validates type correctness without running code.

**Expected output:**
```
Success: no issues found in 4 source files
```

### 4. Fast Test (Primary Command)
```bash
mise run fast-test
# or: uv run pytest tests/unit tests/contract -v --tb=short
```

Runs unit and contract tests only. **This is the command agents should run after every change.**

**Test scope:**
- `tests/unit/` - Pure function tests, no fixtures
- `tests/contract/` - API/schema validation tests

**Excluded:**
- `tests/integration/` - Database, network, file I/O

**Verified output:**
```
tests/unit/test_models.py::TestUserModel::test_user_creation PASSED      [ 12%]
tests/unit/test_models.py::TestUserModel::test_user_defaults PASSED      [ 25%]
tests/unit/test_models.py::TestUserModel::test_create_default_user PASSED [ 37%]
tests/unit/test_models.py::TestUserModel::test_user_to_dict PASSED       [ 50%]
tests/contract/test_api.py::TestAPIContract::test_user_schema_matches_api_contract PASSED [ 62%]
tests/contract/test_api.py::TestAPIContract::test_user_required_fields PASSED [ 75%]
tests/contract/test_api.py::TestAPIContract::test_user_optional_fields PASSED [ 87%]
tests/contract/test_api.py::TestAPIContract::test_user_email_nullable PASSED [100%]

============================== 8 passed in 0.04s ==============================
```

### 5. Development Run
```bash
mise run dev
# or: uv run python -m src.app.main
```

Runs the main application. Uses lazy imports for fast startup.

### 6. Full Test Suite (CI Only)
```bash
mise run test-full
# or: uv run pytest tests/ -v --tb=short
```

Runs all tests including integration tests. **Never run locally during iteration.**

**Includes:**
- Unit tests
- Contract tests
- Integration tests (database, network, file I/O)

**Expected time:** 30+ seconds

### 7. Clean
```bash
mise run clean
# or: rm -rf .mypy_cache .pytest_cache __pycache__ src/**/__pycache__
```

Removes cache directories.

### 8. Install
```bash
mise run install
# or: uv sync

mise run install-dev
# or: uv sync --extra dev
```

Install dependencies.

## Prerequisites

Install mise-en-place:
```bash
# Using curl (Linux/macOS)
curl https://mise.run | sh

# Using winget (Windows)
winget install mise-en-place
```

Then install Python and dependencies:
```bash
mise install
mise run install-dev
```

## Agent Rules

1. **Always run `mise run fast-test` after code changes**
2. **Run `mise run lint` before committing**
3. **If lint fails, run `mise run lint-fix`**
4. **Never run `mise run test-full` locally**
5. **If stuck, run `mise run clean` and retry**

## mise.toml Configuration

Commands are catalogued in [`mise.toml`](mise.toml):

```toml
[tools]
python = "3.12"

[commands]
lint = "ruff check src/ tests/unit/ tests/contract/"
lint-fix = "ruff check src/ tests/unit/ tests/contract/ --fix"
typecheck = "mypy src/"
fast-test = "pytest tests/unit tests/contract -v --tb=short"
dev = "python -m src.app.main"
test-full = "pytest tests/ -v --tb=short"
clean = "rm -rf .mypy_cache .pytest_cache __pycache__ src/**/__pycache__"
install = "uv sync"
install-dev = "uv sync --extra dev"
```

This allows agents to easily discover and whitelist commands.
