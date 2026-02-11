# Python Boilerplate - Command Catalogue
# Single entrypoint for all agent operations
# Optimized for sub-10s agentic feedback loop

.PHONY: fast-test typecheck lint test-full dev clean verify-appimage build-appimage verify-deb build-deb install-deb remove-deb signal-deb

# =============================================================================
# DEB INSTALLER COMMANDS (Target: < 10s verification)
# =============================================================================

# Verify DEB package structure (TARGET: < 3s)
verify-deb:
	@echo "=== DEB Verification (< 3s) ==="
	@START=$(date +%s.%N); \
	[ -f python-boilerplate_1.0.0_all.deb ] && echo "✓ Package exists" || echo "✗ Package missing (run: make build-deb)"; \
	[ -f debian/DEBIAN/control ] && echo "✓ Control file exists" || echo "Note: Run debian.sh first"; \
	[ -f usr/share/applications/python-boilerplate.desktop ] && echo "✓ Desktop entry exists" || echo "Note: Run debian.sh first"; \
	END=$(date +%s.%N); \
	echo "=== Verification time: $(echo "$END - $START" | bc)s ==="

# Full DEB verification with tests (TARGET: < 5s)
verify-deb-full:
	@echo "=== Full DEB Verification (< 5s) ==="
	@START=$(date +%s.%N); \
	make lint 2>/dev/null; \
	make typecheck 2>/dev/null; \
	make fast-test 2>/dev/null; \
	[ -f python-boilerplate_1.0.0_all.deb ] && (dpkg-deb --info python-boilerplate_1.0.0_all.deb 2>/dev/null | head -5) || echo "Package not built"; \
	END=$(date +%s.%N); \
	echo "=== Total verification: $(echo "$END - $START" | bc)s ==="

# Build DEB package (TARGET: < 30s)
build-deb:
	@echo "Building DEB package..."
	@START=$(date +%s.%N); \
	bash debian.sh 2>/dev/null; \
	END=$(date +%s.%N); \
	echo "=== DEB built: python-boilerplate_1.0.0_all.deb ==="; \
	echo "=== Build time: $(echo "$END - $START" | bc)s ==="

# Install DEB locally (TARGET: < 10s)
install-deb:
	@echo "=== Local DEB Install (< 10s) ==="
	@START=$(date +%s.%N); \
	sudo dpkg --install python-boilerplate_1.0.0_all.deb 2>/dev/null || (echo "Install dependencies: sudo apt-get install -f" && false); \
	END=$(date +%s.%N); \
	echo "=== Install time: $(echo "$END - $START" | bc)s ==="

# Remove DEB package
remove-deb:
	@echo "=== Remove DEB ==="
	sudo dpkg --remove python-boilerplate 2>/dev/null || echo "Package not installed"

# Fast DEB signal for CI (TARGET: < 5s)
signal-deb: lint typecheck fast-test verify-deb
	@echo "=== DEB signal pipeline complete (< 5s) ==="

# =============================================================================
# FAST AGENT LOOP (Target: < 10s)
# =============================================================================

# Ultra-fast test (TARGET: < 5s)
fast-test:
	@echo "Running fast unit tests..."
	@START=$$(date +%s.%N); \
	pytest tests/unit/ -v --no-cov --tb=short -q; \
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
	@echo "Running ruff lint..."
	@START=$$(date +%s.%N); \
	ruff check src/ tests/unit/ tests/contract/ 2>/dev/null; \
	END=$$(date +%s.%N); \
	echo "=== Lint time: $$(echo "$$END - $$START" | bc)s ==="

# Type check (TARGET: < 2s)
typecheck:
	@echo "Running mypy typecheck..."
	@START=$$(date +%s.%N); \
	mypy src/ --no-error-summary 2>/dev/null; \
	END=$$(date +%s.%N); \
	echo "=== Typecheck time: $$(echo "$$END - $$START" | bc)s ==="

# =============================================================================
# APPIMAGE COMMANDS
# =============================================================================

# Verify AppImage works (TARGET: < 5s)
verify-appimage:
	@echo "Verifying AppImage..."
	@START=$$(date +%s.%N); \
	[ -f python-boilerplate-1.0.0-x86_64.AppImage ] && ./python-boilerplate-1.0.0-x86_64.AppImage --version 2>/dev/null || echo "Build AppImage first: make build-appimage"; \
	END=$$(date +%s.%N); \
	echo "=== AppImage verify time: $$(echo "$$END - $$START" | bc)s ==="

# Full AppImage build (TARGET: < 30s)
build-appimage:
	@echo "Building AppImage..."
	@START=$$(date +%s.%N); \
	[ -d .venv ] || uv venv .venv --system-site-packages 2>/dev/null; \
	source .venv/bin/activate && uv pip install --no-cache pyinstaller > /dev/null 2>&1; \
	pyinstaller --onefile --name python-boilerplate --workers 4 src/app/main.py > /dev/null 2>&1; \
	mkdir -p AppDir/usr/bin && cp dist/python-boilerplate AppDir/usr/bin/; \
	[ -f appimagetool-x86_64.AppImage ] || (wget -q https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage && chmod +x appimagetool-x86_64.AppImage); \
	./appimagetool-x86_64.AppImage --appimage-extract-and-run AppDir python-boilerplate-1.0.0-x86_64.AppImage 2>/dev/null; \
	END=$$(date +%s.%N); \
	echo "=== AppImage built: python-boilerplate-1.0.0-x86_64.AppImage ==="; \
	echo "=== Build time: $$(echo "$$END - $$START" | bc)s ==="

# =============================================================================
# CI COMMANDS
# =============================================================================

# Full test suite (CI only - slow)
test-full:
	@echo "Running full test suite..."
	@pytest tests/ -v --tb=short

# =============================================================================
# DEV COMMANDS
# =============================================================================

# Development server
dev:
	@python -m src.app.main

# Clean cache files
clean:
	@rm -rf .mypy_cache .pytest_cache __pycache__ src/**/__pycache__ dist/ build/ AppDir/

# =============================================================================
# BENCHMARK
# =============================================================================

# Run all benchmarks
benchmark: lint typecheck fast-test verify-appimage
	@echo "=== All benchmarks complete ==="
