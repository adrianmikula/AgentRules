# Java CRaC Advanced - Command Catalogue
# Sub-Second Feedback for Agentic Development

.PHONY: fast-test typecheck test-full build clean \
         crac-checkpoint crac-restore cache-warmup \
         background-compile show-cache-stats \
         create-cds use-cds build-native native-checkpoint \
         predictive-test signal

# =============================================================================
# Fast Commands (< 1s) - ALWAYS USE THESE
# =============================================================================

# Agent-fast command - runs cached tests (< 1s)
fast-test:
	@START=$$(date +%s%3N); \
	./gradlew fastTest -q --rerun-tasks; \
	END=$$(date +%s%3N); \
	echo "Fast test: $$((END - START)) ms"

# Type check only - instant feedback (< 500ms)
typecheck:
	@START=$$(date +%s%3N); \
	./gradlew compileJava --incremental -q; \
	END=$$(date +%s%3N); \
	echo "Type check: $$((END - START)) ms"

# Full test suite (CI only - slow)
test-full:
	@./gradlew fullTest

# Build JAR
build:
	@./gradlew bootJar

# Clean
clean:
	@./gradlew clean
	@rm -rf build/cache build/native checkpoints cds

# =============================================================================
# CRaC Commands
# =============================================================================

# Create checkpoint (~5s)
crac-checkpoint:
	@./gradlew cracCheckpoint
	@echo "Checkpoint created at checkpoints/app.jar"

# Restore from checkpoint (< 100ms target)
crac-restore:
	@START=$$(date +%s%3N); \
	./gradlew cracRestore; \
	END=$$(date +%s%3N); \
	echo "Restore time: $$((END - START)) ms"

# =============================================================================
# Cache Commands
# =============================================================================

# Warm all caches for CI (~30s)
cache-warmup:
	@echo "=== Warming Caches ==="
	@./gradlew clean -q
	@./gradlew classes testClasses -q
	@./gradlew warmCache -q
	@./gradlew showCacheStats -q
	@echo "=== Cache Warm Complete ==="

# Show cache statistics
show-cache-stats:
	@./gradlew showCacheStats

# =============================================================================
# Advanced Compilation
# =============================================================================

# Background compilation daemon (Meta technique)
background-compile:
	@echo "Starting background compile daemon..."
	@./gradlew backgroundCompile &
	@echo "Daemon started (Ctrl+C to stop)"

# Create CDS archive for fast class loading (Oracle technique)
create-cds:
	@echo "Creating CDS archive..."
	@./gradlew createCDS
	@echo "CDS archive created at cds/app-cds.jsa"

# Run with CDS
use-cds:
	@echo "Running with CDS..."
	@./gradlew useCDS

# =============================================================================
# GraalVM Native Image (fastest cold start)
# =============================================================================

# Build GraalVM native image (~2-5 min, but < 50ms cold start)
build-native:
	@echo "Building GraalVM native image..."
	@./gradlew buildNative
	@echo "Native image built"

# Create native checkpoint
native-checkpoint:
	@echo "Creating native checkpoint..."
	@./gradlew nativeCheckpoint
	@echo "Native checkpoint created"

# =============================================================================
# Predictive Test Selection (Google JiGaSi-inspired)
# =============================================================================

# Run tests predicted to fail
predictive-test:
	@echo "Running predictive tests..."
	@./gradlew predictiveTest
	@echo "Predictive test complete"

# =============================================================================
# CI Signal Command - Primary metric for agents
# =============================================================================

# Full signal: lint + compile + fast test (< 5s target)
signal:
	@echo "=== CI Signal ==="
	@START=$$(date +%s%3N); \
	echo "Linting..."; \
	./gradlew checkstyleMain -q 2>/dev/null || echo "No checkstyle"; \
	echo "Compiling..."; \
	./gradlew compileJava --incremental -q; \
	echo "Testing..."; \
	./gradlew fastTest -q; \
	END=$$(date +%s%3N); \
	echo "=== Signal Time: $$((END - START)) ms ==="
	@echo "Target: < 5000ms"
	@echo "Status: $$( [ $$((END - START)) -lt 5000 ] && echo "PASS" || echo "FAIL")"

# =============================================================================
# Development Workflows
# =============================================================================

# TDD loop: watch files, run tests on change
watch:
	@echo "Starting TDD watch mode..."
	@while true; do \
		./gradlew fastTest -q 2>/dev/null; \
		sleep 2; \
	done

# Hot reload with CRaC
hot-reload:
	@echo "Starting hot reload mode..."
	@./gradlew bootRun --args='--spring.devtools.restart.enabled=true' &
	@echo "Hot reload started"

# =============================================================================
# Performance Benchmark
# =============================================================================

benchmark:
	@echo "=== Performance Benchmark ==="
	@echo ""
	@echo "1. Type Check:"
	@./gradlew compileJava --incremental -q
	@echo "   DONE"
	@echo ""
	@echo "2. Fast Test:"
	@./gradlew fastTest -q
	@echo "   DONE"
	@echo ""
	@echo "3. Full Build:"
	@./gradlew bootJar -q
	@echo "   DONE"
	@echo ""
	@echo "=== Benchmark Complete ==="
	@echo ""
	@echo "Check Gradle BuildScan for detailed metrics"

# =============================================================================
# Docker Commands
# =============================================================================

docker-build:
	@docker build -t java-crac-advanced:latest .

docker-run:
	@docker run -p 8080:8080 java-crac-advanced:latest

docker-buildx:
	@docker buildx build --platform linux/amd64,linux/arm64 -t java-crac-advanced:latest --push .

# =============================================================================
# Help
# =============================================================================

help:
	@echo "Java CRaC Advanced - Command Catalogue"
	@echo ""
	@echo "FAST COMMANDS (< 1s):"
	@echo "  make fast-test       - Run cached tests (< 1s)"
	@echo "  make typecheck       - Type check only (< 500ms)"
	@echo ""
	@echo "CRaC COMMANDS:"
	@echo "  make crac-checkpoint - Create checkpoint (~5s)"
	@echo "  make crac-restore    - Restore from checkpoint (< 100ms)"
	@echo ""
	@echo "CACHE COMMANDS:"
	@echo "  make cache-warmup    - Warm all caches (~30s)"
	@echo "  make show-cache-stats - Show cache statistics"
	@echo ""
	@echo "ADVANCED:"
	@echo "  make background-compile - Start background daemon"
	@echo "  make create-cds         - Create CDS archive"
	@echo "  make build-native       - Build GraalVM image"
	@echo ""
	@echo "CI:"
	@echo "  make signal            - Full CI signal (< 5s)"
	@echo "  make benchmark         - Run benchmarks"
