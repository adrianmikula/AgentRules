# Roblox-TS + Knit Boilerplate - Agentic Dev Velocity

## Optimized for Fast Feedback Loops

This template implements agentic dev velocity principles for Roblox-TS development:
- **Fast TypeScript → Lua compilation**
- **Parallel CI pipeline with Wally3D/no-opt builds**
- **Selene linting (Lua)**
- **Hot reload via Rojo**
- **Fast test source sets**

## Quick Commands

```bash
# Agent-fast - ALWAYS run this
make fast-test              # < 1s

# Type check (TS validation)
make typecheck              # < 2s

# Lint (Selene)
make lint                   # < 1s

# Build for Roblox (Wally3D mode)
make build                  # ~3-5s

# Full test suite (CI only)
make test-full             # ~10-15s

# Watch mode (Rojo sync)
make watch                 # Continuous sync

# Lint Docker
make docker-lint           # < 5s
```

## Project Structure

```
roblox-ts/
├── package.json            # npm + Rojo configuration
├── tsconfig.json          # TypeScript configuration
├── selene.toml            # Selene (Lua linter)
├── .github/
│   └── workflows/
│       └── ci.yml         # Parallel CI pipeline
├── Makefile               # Command catalogue
├── Dockerfile             # Build environment
├── src/
│   ├── client/
│   │   └── init.client.ts
│   ├── server/
│   │   └── init.server.ts
│   ├── shared/
│   │   └── types.ts
│   ├── services/          # Knit services
│   │   └── PlayerService.ts
│   ├── components/        # Roblox components
│   │   └── Button.ts
│   └── tests/
│       ├── unit/
│       │   └── MathUtils.spec.ts
│       └── integration/
│           └── Service.spec.ts
└── out/                   # Generated Lua (compiled)
```

## Performance Targets

| Metric | Target | Typical |
|--------|--------|---------|
| Fast Test | < 1s | **0.5-1s** |
| Type Check | < 2s | **1-2s** |
| Lint (Selene) | < 1s | **0.5-1s** |
| Build (Wally3D) | < 5s | **3-5s** |
| CI Signal | < 10s | **~8-10s** |
| Docker Build | < 30s | **< 30s** |
| Hot Reload | < 2s | **< 1s** |

## Test Tiers

| Tier | Location | Framework | Speed | Use |
|------|----------|-----------|-------|-----|
| Fast | `src/tests/unit/` | Jest | < 1s | Agent loop |
| Integration | `src/tests/integration/` | Jest | ~3-5s | CI |

## Configuration

### tsconfig.json (Fast Compile)

```json
{
  "compilerOptions": {
    "target": "ESNext",
    "module": "CommonJS",
    "strict": true,
    "noLib": true,
    "downlevelIteration": true,
    "declaration": false,
    "rootDir": "src",
    "outDir": "out",
    "typeRoots": [
      "node_modules/@rbxts",
      "node_modules/types"
    ],
    "types": [
      "roblox",
      "rbx-types"
    ]
  },
  "include": [
    "src/**/*"
  ],
  "exclude": [
    "node_modules",
    "out",
    "**/*.spec.ts"
  ]
}
```

### package.json

```json
{
  "name": "roblox-ts-knit",
  "version": "1.0.0",
  "scripts": {
    "build": "rbxtsc",
    "watch": "rbxtsc -w",
    "test": "jest",
    "test:watch": "jest --watch",
    "lint": "selene .",
    "typecheck": "rbxtsc --noEmit"
  },
  "devDependencies": {
    "@rbxts/compiler-types": "^4.0.0",
    "@rbxts/t": "^7.0.0",
    "@types/jest": "^29.5.0",
    "jest": "^29.7.0",
    "rbxts": "^4.0.0",
    "selene": "^1.12.0",
    "typescript": "^5.0.0"
  },
  "knit": {
    "services": [
      "src/services/**/*.ts"
    ],
    "components": [
      "src/components/**/*.ts"
    ]
  }
}
```

## Optimizations Applied

1. **Incremental TypeScript Compilation**: rbx-tsc with --incremental
2. **Parallel CI Jobs**: Lint, typecheck, test run in parallel
3. **Fast Test Source Set**: Unit tests only, no Roblox runtime
4. **Selene Linting**: Fast Lua linting
5. **Wally3D Mode**: Optimized for game server builds

## Requirements

- Node.js 18+
- Rojo (for Roblox studio sync)
- Roblox Studio
- selene (Lua linter)

## License

MIT
