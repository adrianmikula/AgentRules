# Roblox-TS + Knit Boilerplate - Commands Reference

## Quick Reference

| Command | Description | Time | When to Run |
|---------|-------------|------|-------------|
| `mise run lint` | Selene Lua linter | < 1s | Every code change |
| `mise run lint-fix` | Auto-fix lint issues | < 1s | After lint errors |
| `mise run typecheck` | TypeScript check | 2-5s | Before committing |
| `mise run compile` | Compile TS to Lua | 3-5s | Before testing |
| `mise run test-fast` | Fast unit tests | 2-5s | **Every iteration** |
| `mise run test-full` | All tests | 5-10s | CI only |
| `mise run test-contract` | Contract tests | 2-5s | API changes |
| `mise run dev` | Run Rojo server | instant | Development |
| `mise run build` | Build place file | 5-10s | Before publishing |
| `mise run package` | Package for Roblox | 5-10s | Distribution |
| `mise run format` | Lua formatter | < 1s | Before committing |

## Using mise-en-place (Recommended)

This project uses [mise-en-place](https://mise.jdx.dev/) to catalogue commands. Agents can easily discover and run whitelisted commands.

### List available commands:
```bash
mise tasks
```

### Run a command:
```bash
mise run lint
mise run typecheck
mise run test-fast
```

## Commands Detail

### 1. Lint (Fastest Feedback)
```bash
mise run lint
# or: selene src/ tests/
```

Runs Selene Lua linter on source and test files.

### 2. Lint Fix
```bash
mise run lint-fix
# or: selene src/ tests/ --fix
```

Auto-fixes Selene lint issues.

### 3. Type Check
```bash
mise run typecheck
# or: rbx-tsc --noEmit
```

Runs TypeScript type checking without generating Lua.

### 4. Compile
```bash
mise run compile
# or: rbx-tsc
```

Compiles TypeScript to Lua. **Required before running tests.**

### 5. Fast Test (Primary Command)
```bash
mise run test-fast
# or: jest --testPathPattern=tests/unit --no-coverage
```

Runs unit tests only. **This is the command agents should run after every change.**

### 6. Full Test Suite
```bash
mise run test-full
# or: jest --no-coverage
```

Runs all tests including contract tests.

### 7. Contract Tests
```bash
mise run test-contract
# or: jest --testPathPattern=tests/contract
```

Runs contract tests only.

### 8. Development Run
```bash
mise run dev
# or: rojo serve
```

Runs Rojo development server for live reloading.

### 9. Build
```bash
mise run build
# or: rojo build --output build.rbxlx
```

Builds Roblox place file.

### 10. Package
```bash
mise run package
# or: npm run package
```

Packages for Roblox distribution.

### 11. Format
```bash
mise run format
# or: stylua src/ --check
```

Checks Lua formatting.

## Prerequisites

Install mise-en-place:
```bash
curl https://mise.run | sh
```

Then install dependencies:
```bash
mise install
npm install
```

## Project Structure

```
roblox-ts-boilerplate/
├── src/
│   ├── init.client.ts    # Client entry point
│   ├── init.server.ts    # Server entry point
│   └── tests/
│       └── unit/         # Unit tests
├── tests/
│   ├── unit/            # Jest unit tests
│   └── contract/        # Contract tests
├── package.json
├── tsconfig.json
├── selene.toml         # Selene configuration
├── jest.config.js      # Jest configuration
├── Makefile
└── mise.toml          # Command catalogue
```

## Development Workflow

### Initial Setup
```bash
mise install
npm install
mise run compile
```

### Every Code Change
```bash
mise run lint
mise run typecheck
mise run compile
mise run test-fast
```

### Testing in Roblox
```bash
mise run dev
# Open Roblox Studio and connect to Rojo
```

## Agent Rules

1. **Always run `mise run lint && mise run typecheck` after code changes**
2. **Run `mise run compile` before testing**
3. **Run `mise run test-fast` for quick feedback**
4. **Use `mise run dev` for in-Studio testing**
5. **Never run full test suite unless necessary**

## mise.toml Configuration

Commands are catalogued in [`mise.toml`](mise.toml):

```toml
[tools]
node = "20"
lua = "5.4"

[scripts]
lint = "selene src/ tests/"
lint-fix = "selene src/ tests/ --fix"
typecheck = "rbx-tsc --noEmit"
compile = "rbx-tsc"
test-fast = "jest --testPathPattern=tests/unit --no-coverage"
test-full = "jest --no-coverage"
test-contract = "jest --testPathPattern=tests/contract"
dev = "rojo serve"
build = "rojo build --output build.rbxlx"
package = "npm run package"
clean = "rm -rf out node_modules/.cache"
install = "npm install"
install-dev = "npm install"
format = "stylua src/ --check"
```

## package.json Scripts

```json
{
  "scripts": {
    "lint": "selene src/",
    "lint:fix": "selene src/ --fix",
    "typecheck": "rbx-tsc --noEmit",
    "compile": "rbx-tsc",
    "test:fast": "jest --testPathPattern=tests/unit --no-coverage",
    "test:full": "jest --no-coverage",
    "test:contract": "jest --testPathPattern=tests/contract",
    "dev": "rojo serve",
    "build": "rojo build --output build.rbxlx",
    "package": "rbxtsc && rojo build --output out.rbxlx",
    "format": "stylua src/ --check",
    "format:fix": "stylua src/"
  }
}
```
