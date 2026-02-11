# Go Boilerplate - Commands Reference

## Quick Reference

| Command | Description | Time | When to Run |
|---------|-------------|------|-------------|
| `mise run lint` | Go vet lint | < 1s | Every code change |
| `mise run test-fast` | Fast unit/contract tests | 2-5s | **Every iteration** |
| `mise run test-full` | All tests | 10-30s | CI only |
| `mise run build` | Build binary | 2-5s | Before deploy |
| `mise run dev` | Run dev server | instant | Development |

## Using mise-en-place (Recommended)

This project uses [mise-en-place](https://mise.jdx.dev/) to catalogue commands. Agents can easily discover and run whitelisted commands.

### List available commands:
```bash
mise tasks
```

### Run a command:
```bash
mise run lint
mise run test-fast
mise run build
```

## Commands Detail

### 1. Lint (Fastest Feedback)
```bash
mise run lint
# or: go vet ./...
```

Runs Go vet on all packages. Catches common errors instantly.

### 2. Fast Test (Primary Command)
```bash
mise run test-fast
# or: go test -v -run 'Test(Home|Health|Users|User|Count|Schema)' ./tests/unit ./tests/contract
```

Runs unit and contract tests. **This is the command agents should run after every change.**

**Test scope:**
- `tests/unit/` - Unit tests
- `tests/contract/` - API contract tests

### 3. Full Test Suite (CI Only)
```bash
mise run test-full
# or: go test -v ./tests/...
```

Runs all tests including integration tests. **Never run locally during iteration.**

### 4. Build
```bash
mise run build
# or: go build -o bin/app main.go
```

Builds the Go binary.

### 5. Development Run
```bash
mise run dev
# or: go run main.go
```

Runs the application. Go's compile is fast, so this is nearly instant.

## Prerequisites

Install mise-en-place:
```bash
curl https://mise.run | sh
```

Then install Go and dependencies:
```bash
mise install
go mod download
```

## Project Structure

```
go-boilerplate/
├── main.go            # Entry point
├── main_test.go       # Contract tests
├── go.mod             # Go module
├── go.sum             # Dependencies
├── bin/               # Built binaries
└── tests/
    ├── unit/          # Unit tests
    └── contract/      # API contract tests
```

## Agent Rules

1. **Always run `mise run lint && mise run test-fast` after code changes**
2. **Run `mise run build` before deploying**
3. **Go compiles fast, so `mise run dev` is suitable for local development**
4. **Never run `mise run test-full` locally**

## mise.toml Configuration

Commands are catalogued in [`mise.toml`](mise.toml):

```toml
[tools]
go = "1.21"

[scripts]
lint = "go vet ./..."
test-fast = "go test -v -run 'Test(Home|Health|Users|User|Count|Schema)' ./tests/unit ./tests/contract"
test-full = "go test -v ./tests/..."
build = "go build -o bin/app main.go"
dev = "go run main.go"
```
