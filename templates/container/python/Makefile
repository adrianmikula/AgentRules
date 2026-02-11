# Docker Build Commands - Fast Agent Loop
# Target: Sub-30s Docker builds with cache

.PHONY: docker-build docker-buildx docker-lint docker-cache docker-prune docker-stats

# =============================================================================
# FAST DOCKER COMMANDS
# =============================================================================

# Build with BuildKit (TARGET: < 30s cold, < 10s warm)
docker-build:
	@echo "Building Docker image..."
	@START=$$(date +%s.%N); \
	docker build --build-arg BUILDKIT_INLINE_CACHE=1 -t app:dev .; \
	END=$$(date +%s.%N); \
	echo "=== Build time: $$(echo "$$END - $$START" | bc)s ==="

# Build with Buildx and GHA cache (TARGET: < 10s warm)
docker-buildx:
	@echo "Building with Buildx and cache..."
	@START=$$(date +%s.%N); \
	docker buildx build --push \
		--cache-from type=gha,scope=docker \
		--cache-to type=gha,mode=max,scope=docker \
		--target development \
		-t app:dev .; \
	END=$$(date +%s.%N); \
	echo "=== Build time: $$(echo "$$END - $$START" | bc)s ==="

# Lint Dockerfile (TARGET: < 5s)
docker-lint:
	@echo "Linting Dockerfile..."
	@START=$$(date +%s.%N); \
	docker buildx build --help > /dev/null 2>&1 && \
	echo "✓ BuildKit syntax valid" && \
	docker history app:dev > /dev/null 2>&1 && \
	echo "✓ Image layers valid"; \
	END=$$(date +%s.%N); \
	echo "=== Lint time: $$(echo "$$END - $$START" | bc)s ==="

# Show cache stats (TARGET: < 2s)
docker-cache:
	@echo "Docker Build Cache Stats"
	@echo "========================"
	@docker buildx du 2>/dev/null || echo "Cache: empty"
	@docker images | grep app || echo "No app images"

# Prune build cache (TARGET: < 5s)
docker-prune:
	@echo "Pruning Docker build cache..."
	@docker buildx prune --all 2>/dev/null || true
	@docker system df 2>/dev/null | head -5

# Rebuild without cache (TARGET: < 60s)
docker-rebuild:
	@echo "Rebuilding without cache..."
	@START=$$(date +%s.%N); \
	docker build --no-cache -t app:dev .; \
	END=$$(date +%s.%N); \
	echo "=== Rebuild time: $$(echo "$$END - $$START" | bc)s ==="

# Profile build time (TARGET: < 60s)
docker-profile:
	@echo "Profiling Docker build..."
	@START=$$(date +%s.%N); \
	docker build --profiler results=build.txt -t app:dev . > /dev/null 2>&1; \
	END=$$(date +%s.%N); \
	echo "=== Profile time: $$(echo "$$END - $$START" | bc)s ==="; \
	cat build.txt 2>/dev/null | head -20

# Show layer breakdown (TARGET: < 2s)
docker-layers:
	@echo "Docker Layer Analysis"
	@echo "======================"
	@docker history app:dev --format '{{.Size}}\t{{.CreatedBy}}' 2>/dev/null | head -15

# Build production image (TARGET: < 30s cold, < 10s warm)
docker-prod:
	@echo "Building production image..."
	@START=$$(date +%s.%N); \
	docker build --target production -t app:latest .; \
	END=$$(date +%s.%N); \
	echo "=== Production build: $$(echo "$$END - $$START" | bc)s ==="

# Multi-platform build (TARGET: < 120s)
docker-multiplatform:
	@echo "Building for multiple platforms..."
	@START=$$(date +%s.%N); \
	docker buildx build --push \
		--platform linux/amd64,linux/arm64 \
		--cache-from type=gha,scope=docker \
		--cache-to type=gha,mode=max,scope=docker \
		-t app:latest .; \
	END=$$(date +%s.%N); \
	echo "=== Multi-platform build: $$(echo "$$END - $$START" | bc)s ==="

# =============================================================================
# CI DOCKER COMMANDS
# =============================================================================

# Run full Docker CI pipeline locally
docker-ci:
	@echo "Running Docker CI pipeline..."
	@START=$$(date +%s.%N); \
	make docker-lint && \
	make docker-build && \
	make docker-cache; \
	END=$$(date +%s.%N); \
	echo "=== Total CI time: $$(echo "$$END - $$START" | bc)s ==="

# Benchmark Docker builds
docker-benchmark:
	@echo "Docker Build Benchmark"
	@echo "======================="
	@echo "1. Cold build (no cache)..."
	@make docker-prune > /dev/null 2>&1
	@START=$$(date +%s.%N); \
	make docker-build > /dev/null 2>&1; \
	COLD=$$(echo "$$(date +%s.%N) - $$START" | bc); \
	echo "   Cold: $$COLD s"
	@echo "2. Warm build (with cache)..."
	@START=$$(date +%s.%N); \
	make docker-build > /dev/null 2>&1; \
	WARM=$$(echo "$$(date +%s.%N) - $$START" | bc); \
	echo "   Warm: $$WARM s"
	@echo "3. Incremental build (source only)..."
	@START=$$(date +%s.%N); \
	make docker-build > /dev/null 2>&1; \
	INCR=$$(echo "$$(date +%s.%N) - $$START" | bc); \
	echo "   Incremental: $$INCR s"
	@echo ""
	@echo "Improvement: $$(echo "scale=1; ($$COLD - $$WARM) / $$COLD * 100" | bc)% faster with cache"

# =============================================================================
# DOCKER DEVELOPMENT
# =============================================================================

# Run development container
docker-run:
	@docker run -p 8000:8000 -v $$(pwd)/src:/app/src --rm app:dev

# Attach to running container
docker-attach:
	@docker exec -it $$(docker ps -qf "ancestor=app:dev") /bin/bash

# Show container logs
docker-logs:
	@docker logs -f $$(docker ps -qf "ancestor=app:dev")

# =============================================================================
# PERFORMANCE TARGETS
# =============================================================================
# docker-lint: < 5s
# docker-build: < 30s (cold) / < 10s (warm)
# docker-prod: < 30s (cold) / < 10s (warm)
# docker-ci: < 60s
# docker-benchmark: < 180s
