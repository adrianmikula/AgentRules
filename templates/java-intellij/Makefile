# IntelliJ Plugin - Command Catalogue
# Optimized for sub-10s agentic feedback loop

.PHONY: fast-test compile signal build build-plugin clean dev

# =============================================================================
# FAST AGENT LOOP (Target: < 10s)
# =============================================================================

# Ultra-fast test (TARGET: < 10s)
fast-test:
	@echo "Running fast unit tests..."
	@START=$$(date +%s.%N); \
	./gradlew testFast -q 2>/dev/null | tail -10; \
	END=$$(date +%s.%N); \
	echo "=== Test time: $$(echo "$$END - $$START" | bc)s ==="

# Fast signal (TARGET: < 15s) - compile + fast-test
signal: compile fast-test
	@echo "=== Signal pipeline complete (< 15s) ==="

# =============================================================================
# BUILD COMMANDS
# =============================================================================

# Fast compilation (TARGET: < 15s)
compile:
	@echo "Compiling IntelliJ Plugin..."
	@START=$$(date +%s.%N); \
	./gradlew compileJava -q 2>/dev/null; \
	END=$$(date +%s.%N); \
	echo "=== Compile time: $$(echo "$$END - $$START" | bc)s ==="

# Full plugin build (TARGET: < 60s)
build:
	@echo "Building IntelliJ Plugin..."
	@START=$$(date +%s.%N); \
	./gradlew buildPlugin -q 2>/dev/null; \
	END=$$(date +%s.%N); \
	echo "=== Plugin built: build/distributions/*.zip ==="; \
	echo "=== Build time: $$(echo "$$END - $$START" | bc)s ==="

# =============================================================================
# CI COMMANDS
# =============================================================================

# Full test suite (CI only - slow)
test-full:
	@echo "Running full test suite..."
	./gradlew test --continue

# =============================================================================
# DEV COMMANDS
# =============================================================================

# Development mode (requires IntelliJ)
dev:
	@echo "Run in IntelliJ IDEA with: Run → Edit Configurations → + → IntelliJ Platform Plugin"

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	./gradlew clean -q 2>/dev/null
	rm -rf build/ .gradle/ out/

# =============================================================================
# PERFORMANCE TARGETS
# =============================================================================
# fast-test: < 10s
# compile: < 15s
# signal: < 15s
# build: < 60s
# clean: < 5s
