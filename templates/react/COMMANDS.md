# React Boilerplate - Commands Reference

## Quick Reference

| Command | Description | Time | When to Run |
|---------|-------------|------|-------------|
| `mise run lint` | ESLint check | 1-2s | Every code change |
| `mise run lint-fix` | Auto-fix lint issues | 1-2s | After lint errors |
| `mise run typecheck` | TypeScript check | 2-5s | Before committing |
| `mise run test-fast` | Fast unit/contract tests | 3-5s | **Every iteration** |
| `mise run test-full` | All tests | 10-30s | CI only |
| `mise run dev` | Run dev server | instant | Development |
| `mise run build` | Build for production | 10-30s | Before deploy |

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
# or: npm run lint
```

Runs ESLint on source files.

### 2. Lint Fix
```bash
mise run lint-fix
# or: npm run lint:fix
```

Auto-fixes ESLint issues.

### 3. Type Check
```bash
mise run typecheck
# or: npm run typecheck
```

Runs TypeScript type checking.

### 4. Fast Test (Primary Command)
```bash
mise run test-fast
# or: npm run test:fast
```

Runs unit and contract tests. **This is the command agents should run after every change.**

### 5. Full Test Suite (CI Only)
```bash
mise run test-full
# or: npm run test:full
```

Runs all tests including integration tests. **Never run locally during iteration.**

### 6. Development Run
```bash
mise run dev
# or: npm run dev
```

Runs Vite development server.

### 7. Build
```bash
mise run build
# or: npm run build
```

Builds for production.

## Prerequisites

Install mise-en-place:
```bash
curl https://mise.run | sh
```

Then install Node.js and dependencies:
```bash
mise install
npm install
```

## Project Structure

```
react-boilerplate/
├── src/
│   ├── App.tsx        # Main component
│   └── main.tsx       # Entry point
├── tests/
│   ├── unit/          # Unit tests
│   └── contract/      # Component contract tests
├── package.json
├── tsconfig.json
├── vite.config.ts
└── mise.toml         # Command catalogue
```

## Agent Rules

1. **Always run `mise run lint && mise run test-fast` after code changes**
2. **Run `mise run typecheck` before committing**
3. **Use `mise run dev` for local development**
4. **Never run `mise run test-full` locally**

## mise.toml Configuration

Commands are catalogued in [`mise.toml`](mise.toml):

```toml
[tools]
node = "20"

[scripts]
lint = "npm run lint"
lint-fix = "npm run lint:fix"
typecheck = "npm run typecheck"
test-fast = "npm run test:fast"
test-full = "npm run test:full"
dev = "npm run dev"
build = "npm run build"
```

## package.json Scripts

```json
{
  "scripts": {
    "lint": "eslint . --ext ts,tsx",
    "lint:fix": "eslint . --ext ts,tsx --fix",
    "typecheck": "tsc --noEmit",
    "test:fast": "jest --testPathPattern='tests/(unit|contract)'",
    "test:full": "jest",
    "dev": "vite",
    "build": "tsc && vite build"
  }
}
```
