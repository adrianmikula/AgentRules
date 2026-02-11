# Node.js Boilerplate - Commands Reference

## Quick Reference

| Command | Description | Time | When to Run |
|---------|-------------|------|-------------|
| `mise run lint` | ESLint check | < 1s | Every code change |
| `mise run test-fast` | Fast unit/contract tests | 2-5s | **Every iteration** |
| `mise run test-full` | All tests | 10-30s | CI only |
| `mise run dev` | Run dev server | instant | Development |
| `mise run start` | Start production | N/A | Production |

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
mise run dev
```

## Commands Detail

### 1. Lint (Fastest Feedback)
```bash
mise run lint
# or: npm run lint
```

Runs ESLint on source files.

### 2. Fast Test (Primary Command)
```bash
mise run test-fast
# or: npm run test:fast
```

Runs unit and contract tests. **This is the command agents should run after every change.**

### 3. Full Test Suite (CI Only)
```bash
mise run test-full
# or: npm run test:full
```

Runs all tests including integration tests. **Never run locally during iteration.**

### 4. Development Run
```bash
mise run dev
# or: npm run dev
```

Runs the development server.

### 5. Production Start
```bash
mise run start
# or: npm start
```

Starts the production server.

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
nodejs-boilerplate/
├── index.js            # Entry point
├── package.json        # Dependencies and scripts
├── jest.config.js      # Jest configuration
└── tests/
    ├── unit/          # Unit tests
    └── contract/      # API contract tests
```

## Agent Rules

1. **Always run `mise run lint && mise run test-fast` after code changes**
2. **Use `mise run dev` for local development**
3. **Never run `mise run test-full` locally**

## mise.toml Configuration

Commands are catalogued in [`mise.toml`](mise.toml):

```toml
[tools]
node = "20"

[scripts]
lint = "npm run lint"
test-fast = "npm run test:fast"
test-full = "npm run test:full"
dev = "npm run dev"
start = "npm start"
```

## package.json Scripts

```json
{
  "scripts": {
    "lint": "eslint .",
    "lint:fix": "eslint . --fix",
    "test:fast": "jest --testPathPattern='tests/(unit|contract)'",
    "test:full": "jest",
    "dev": "node index.js",
    "start": "node index.js"
  }
}
```
