# Python Django Boilerplate - Commands Reference

## Quick Reference

| Command | Description | Time | When to Run |
|---------|-------------|------|-------------|
| `mise run lint` | Fast syntax/lint check | < 1s | Every code change |
| `mise run lint-fix` | Auto-fix lint issues | < 1s | After lint errors |
| `mise run typecheck` | MyPy type checking | < 2s | Before committing |
| `mise run fast-test` | Unit tests | **2-3s** | **Every iteration** |
| `mise run dev` | Run Django dev server | N/A | Development |
| `mise run migrate` | Run database migrations | N/A | After model changes |
| `mise run shell` | Django shell | N/A | Debugging |
| `mise run test-full` | All tests | 30s+ | CI only |
| `mise run clean` | Clean cache files | N/A | When stuck |

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

## Commands Detail

### 1. Lint (Fastest Feedback)
```bash
mise run lint
# or: ruff check config/ apps/ tests/
```

Runs Ruff linter on config, apps, and test files. Catches syntax errors and style issues instantly.

### 2. Lint Fix
```bash
mise run lint-fix
# or: ruff check config/ apps/ tests/ --fix
```

Auto-fixes lint issues (whitespace, import sorting, etc.).

### 3. Type Check
```bash
mise run typecheck
# or: mypy config/ apps/
```

Runs MyPy incremental type checking. Validates type correctness without running code.

### 4. Fast Test (Primary Command)
```bash
mise run fast-test
# or: pytest tests/unit tests/contract -v --tb=short --no-header
```

Runs unit and contract tests only. **This is the command agents should run after every change.**

**Test scope:**
- `tests/unit/` - Pure function tests, no database
- `tests/contract/` - API/schema validation tests

**Excluded:**
- `tests/integration/` - Database, network, file I/O

### 5. Development Run
```bash
mise run dev
# or: python manage.py runserver
```

Runs the Django development server.

### 6. Database Migrations
```bash
mise run migrate
# or: python manage.py migrate
```

Applies pending database migrations.

### 7. Django Shell
```bash
mise run shell
# or: python manage.py shell
```

Opens Django shell for debugging.

### 8. Full Test Suite (CI Only)
```bash
mise run test-full
# or: pytest tests/ -v --tb=short
```

Runs all tests including integration tests. **Never run locally during iteration.**

### 9. Clean
```bash
mise run clean
# or: find . -type d -name __pycache__ -exec rm -rf {} +
```

Removes cache directories.

### 10. Install
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

## Project Structure

```
python-django-boilerplate/
├── apps/
│   └── core/           # Django app
├── config/             # Django settings
├── tests/
│   ├── unit/          # Pure unit tests
│   ├── contract/       # API contract tests
│   └── integration/   # DB/integration tests
├── manage.py
├── pyproject.toml
└── mise.toml          # Command catalogue
```

## Agent Rules

1. **Always run `mise run fast-test` after code changes**
2. **Run `mise run lint` before committing**
3. **If lint fails, run `mise run lint-fix`**
4. **Run `mise run migrate` after model changes**
5. **Never run `mise run test-full` locally**
6. **If stuck, run `mise run clean` and retry**

## mise.toml Configuration

Commands are catalogued in [`mise.toml`](mise.toml):

```toml
[tools]
python = "3.12"

[commands]
lint = "ruff check config/ apps/ tests/"
lint-fix = "ruff check config/ apps/ tests/ --fix"
typecheck = "mypy config/ apps/"
fast-test = "pytest tests/unit tests/contract -v --tb=short --no-header"
test-fast = "pytest tests/unit -v --tb=short --no-header"
dev = "python manage.py runserver"
migrate = "python manage.py migrate"
shell = "python manage.py shell"
test-full = "pytest tests/ -v --tb=short"
check = "python manage.py check"
clean = "find . -type d -name __pycache__ -exec rm -rf {} +"
install = "uv sync"
install-dev = "uv sync --extra dev"
```

This allows agents to easily discover and whitelist commands.
