# Java Spring Boilerplate - Command Catalogue

.PHONY: fast-test typecheck test-full build clean cache-warmup

# Agent-fast command (seconds) - ALWAYS run this
fast-test:
	@./gradlew devFast

# Type check only (instant feedback)
typecheck:
	@./gradlew compileJava --incremental --quiet

# Full test suite (CI only - slow)
test-full:
	@./gradlew testFull

# Build JAR
build:
	@./gradlew bootJar

# Clean
clean:
	@./gradlew clean

# Compile all sources
compile:
	@./gradlew compileJava compileFastJava

# Warm build cache for CI
cache-warmup:
	@./gradlew clean build -x test --no-daemon
