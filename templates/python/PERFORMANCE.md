# Python Boilerplate - Performance Metrics

## Tested Results ✓

| Command | Time | Status |
|---------|------|--------|
| `mise run lint` | < 1s | ✓ Working |
| `mise run lint-fix` | < 1s | ✓ Working |
| `mise run typecheck` | < 2s | ✓ Working |
| `mise run fast-test` | **0.04s** | ✓ **8 tests passed** |
| `mise run test-full` | 30s+ | CI only |

## Test Output

```
============================= 8 passed in 0.04s ==============================
tests/unit/test_models.py::TestUserModel::test_user_creation PASSED      [ 12%]
tests/unit/test_models.py::TestUserModel::test_user_defaults PASSED      [ 25%]
tests/unit/test_models.py::TestUserModel::test_create_default_user PASSED [ 37%]
tests/unit/test_models.py::TestUserModel::test_user_to_dict PASSED       [ 50%]
tests/contract/test_api.py::TestAPIContract::test_user_schema_matches_api_contract PASSED [ 62%]
tests/contract/test_api.py::TestAPIContract::test_user_required_fields PASSED [ 75%]
tests/contract/test_api.py::TestAPIContract::test_user_optional_fields PASSED [ 87%]
tests/contract/test_api.py::TestAPIContract::test_user_email_nullable PASSED [100%]
```

## Performance by Principle

### 1. No Framework in Loop
Python has no framework boot time - pure Python execution.

| Scenario | Time |
|----------|------|
| Fast test | 0.04s |
| Full test | 30s+ |

### 2. Tiered Testing

| Tier | Tests | Time |
|------|-------|------|
| Unit | test_models.py | < 0.01s |
| Contract | test_api.py | < 0.01s |
| Integration | (CI only) | 30s+ |

### 3. Agent Iteration Cycle

```
1. Make code change
2. mise run lint          # < 1s
3. mise run fast-test    # 0.04s
Total: ~1 second
```

## Benchmark Configuration

- **Python**: 3.12
- **uv**: 0.7.19
- **pytest**: 9.0.2
- **ruff**: 0.15.0
- **mypy**: 1.19.1
- **Tests**: 8 passed, 0 failed

## Optimization Summary

| Optimization | Impact |
|--------------|--------|
| uv (package manager) | 10× faster than pip |
| ruff (linter) | Instant feedback |
| mypy --incremental | Cached type checks |
| pytest --no-cov | No coverage overhead |
| Lazy imports | No module-side effects |

## Goals Met

| Goal | Target | Actual |
|------|--------|--------|
| Fast feedback | < 5s | 0.04s |
| Single command | Yes | `mise run fast-test` |
| Tiered tests | Yes | unit/contract/integration |
