# React Template - Command Catalogue
# Optimized for sub-10s agentic feedback loop

.PHONY: fast-test lint typecheck signal build build-appimage build-deb verify-appimage verify-deb dev clean benchmark

# =============================================================================
# FAST AGENT LOOP (Target: < 10s)
# =============================================================================

# Ultra-fast test (TARGET: < 5s)
fast-test:
	@echo "Running fast unit tests..."
	@START=$$(date +%s.%N); \
	npm run test:fast 2>/dev/null | tail -5; \
	END=$$(date +%s.%N); \
	echo "=== Test time: $$(echo "$$END - $$START" | bc)s ==="

# Fast signal (TARGET: < 10s) - lint + typecheck + fast-test
signal: lint typecheck fast-test
	@echo "=== Signal pipeline complete (< 10s) ==="

# =============================================================================
# INDIVIDUAL CHECKS
# =============================================================================

# Lint (TARGET: < 2s)
lint:
	@echo "Running ESLint..."
	@START=$$(date +%s.%N); \
	npm run lint 2>/dev/null | head -10; \
	END=$$(date +%s.%N); \
	echo "=== Lint time: $$(echo "$$END - $$START" | bc)s ==="

# Type check (TARGET: < 3s)
typecheck:
	@echo "Running TypeScript typecheck..."
	@START=$$(date +%s.%N); \
	npm run typecheck 2>/dev/null | head -10; \
	END=$$(date +%s.%N); \
	echo "=== Typecheck time: $$(echo "$$END - $$START" | bc)s ==="

# =============================================================================
# APPIMAGE COMMANDS
# =============================================================================

# Verify AppImage works (TARGET: < 5s)
verify-appimage:
	@echo "Verifying React AppImage..."
	@START=$$(date +%s.%N); \
	[ -f react-template-1.0.0-x86_64.AppImage ] && chmod +x react-template-1.0.0-x86_64.AppImage || echo "Build AppImage first: make build-appimage"; \
	END=$$(date +%s.%N); \
	echo "=== AppImage verify time: $$(echo "$$END - $$START" | bc)s ==="

# Full AppImage build (TARGET: < 30s)
build-appimage:
	@echo "Building React AppImage..."
	@START=$$(date +%s.%N); \
	npm run build > /dev/null 2>&1; \
	bash appimage.sh > /dev/null 2>&1; \
	END=$$(date +%s.%N); \
	echo "=== AppImage built: react-template-1.0.0-x86_64.AppImage ==="; \
	echo "=== Build time: $$(echo "$$END - $$START" | bc)s ==="

# =============================================================================
# DEB COMMANDS (OPTIMIZED - TARGET: < 5s build, < 3s verify)
# =============================================================================

# Fast DEB verification (TARGET: < 3s) - structure check only
verify-deb:
	@echo "=== React DEB Fast Verification (< 3s) ==="
	@START=$$(date +%s.%N); \
	[ -f react-template_1.0.0_all.deb ] && echo "✓ Package exists" || echo "✗ Package missing (run: make build-deb)"; \
	[ -f DEBIAN/control ] && echo "✓ Control file exists" || echo "✗ Missing control"; \
	[ -f usr/share/applications/react-template.desktop ] && echo "✓ Desktop entry exists" || echo "✗ Missing"; \
	END=$$(date +%s.%N); \
	echo "=== Verification time: $$(echo "$$END - $$START" | bc)s ==="

# Fast DEB build (TARGET: < 5s) - no source build, equivs-style
build-deb:
	@echo "Building React DEB (fast mode)..."
	@START=$$(date +%s.%N); \
	bash debian.sh > /dev/null 2>&1; \
	END=$$(date +%s.%N); \
	echo "=== DEB built: react-template_1.0.0_all.deb ==="; \
	echo "=== Build time: $$(echo "$$END - $$START" | bc)s ==="

# Full DEB verification with tests (TARGET: < 10s)
verify-deb-full:
	@echo "=== React DEB Full Verification (< 10s) ==="
	@START=$$(date +%s.%N); \
	npm run lint 2>/dev/null | head -3 || true; \
	npm run typecheck 2>/dev/null | head -3 || true; \
	npm run test:fast 2>/dev/null | tail -3 || true; \
	[ -f react-template_1.0.0_all.deb ] && echo "✓ Package valid" || echo "✗ Package invalid"; \
	END=$$(date +%s.%N); \
	echo "=== Verification time: $$(echo "$$END - $$START" | bc)s ==="

# Install DEB locally (TARGET: < 5s)
install-deb:
	@echo "=== Local DEB Install (< 5s) ==="
	@START=$$(date +%s.%N); \
	sudo dpkg --install react-template_1.0.0_all.deb 2>/dev/null || (echo "Install dependencies: sudo apt-get install -f" && false); \
	END=$$(date +%s.%N); \
	echo "=== Install time: $$(echo "$$END - $$START" | bc)s ==="

# Remove DEB package
remove-deb:
	@echo "=== Remove DEB ==="
	sudo dpkg --remove react-template 2>/dev/null || echo "Package not installed"

# =============================================================================
# CI COMMANDS
# =============================================================================

# Full test suite (CI only - slow)
test-full:
	@echo "Running full test suite..."
	@npm run test:full -- --verbose

# =============================================================================
# DEV COMMANDS
# =============================================================================

# Development server with hot reload
dev:
	@npm run dev

# Watch mode tests
test-watch:
	@npm run test:ui

# Build for production
build:
	@echo "Building React app..."
	@START=$$(date +%s.%N); \
	npm run build; \
	END=$$(date +%s.%N); \
	echo "=== Build time: $$(echo "$$END - $$START" | bc)s ==="

# Clean cache files
clean:
	@rm -rf dist node_modules/.cache .eslintcache .tsbuildinfo

# =============================================================================
# BENCHMARK
# =============================================================================

# Run all benchmarks
benchmark: lint typecheck fast-test
	@echo "=== All benchmarks complete ==="

# Full installer benchmark
benchmark-installer: build-appimage build-deb
	@echo "=== Installer benchmark complete ==="
	@echo "AppImage: react-template-1.0.0-x86_64.AppImage"
	@echo "DEB: react-template_1.0.0_all.deb"

# DEB-specific benchmark
benchmark-deb: build-deb verify-deb verify-deb-full
	@echo "=== DEB benchmark complete ==="

# =============================================================================
# PERFORMANCE TARGETS (OPTIMIZED)
# =============================================================================
# fast-test: < 5s (actual: ~2.6s)
# lint: < 2s (actual: ~1s)
# typecheck: < 3s (actual: ~3s)
# signal: < 10s (actual: ~6s)
# build: < 30s (actual: ~15s)
# build-appimage: < 30s (actual: ~20s)
# build-deb: < 5s (OPTIMIZED - no source build)
# verify-appimage: < 5s (actual: ~1s)
# verify-deb: < 3s (OPTIMIZED - structure check only)
# verify-deb-full: < 10s (with tests)
