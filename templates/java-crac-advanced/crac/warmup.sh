#!/bin/bash
# crac/warmup.sh - CRaC Warmup Script
# Implements Alibaba Dragonwell warmup techniques

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
WARMUP_DIR="${WARMUP_DIR:-crac}"
CHECKPOINT_DIR="${CHECKPOINT_DIR:-checkpoints}"
CACHE_DIR="${CACHE_DIR:-build/cache}"
WARMUP_TIMEOUT="${WARMUP_TIMEOUT:-60000}"  # 60 seconds default

echo "=============================================="
echo "CRaC Warmup Script"
echo "=============================================="
echo "Target warmup time: ${WARMUP_TIMEOUT}ms"
echo "Checkpoint directory: ${CHECKPOINT_DIR}"
echo ""

# =============================================================================
# Phase 1: Clean Build
# =============================================================================
echo -e "${YELLOW}[1/5] Clean Build${NC}"
START=$(date +%s%3N)

./gradlew clean classes testClasses -q --no-daemon

END=$(date +%s%3N)
echo "Clean build: $((END - START)) ms"
echo ""

# =============================================================================
# Phase 2: Compile All Sources
# =============================================================================
echo -e "${YELLOW}[2/5] Full Compilation${NC}"
START=$(date +%s%3N)

./gradlew compileJava compileTestJava --incremental -q --no-daemon

END=$(date +%s%3N)
echo "Full compilation: $((END - START)) ms"
echo ""

# =============================================================================
# Phase 3: Run Fast Tests (warm JIT)
# =============================================================================
echo -e "${YELLOW}[3/5] Warm JIT with Fast Tests${NC}"
START=$(date +%s%3N)

./gradlew fastTest -q --no-daemon

END=$(date +%s%3N)
echo "Fast tests: $((END - START)) ms"
echo ""

# =============================================================================
# Phase 4: Pre-compile Hot Methods
# =============================================================================
echo -e "${YELLOW}[4/5] Pre-compile Hot Methods${NC}"
START=$(date +%s%3N)

# Run a more comprehensive test suite to trigger JIT compilation
./gradlew test --tests "*IntegrationTest" --tests "*SlowTest" -q --no-daemon || true

END=$(date +%s%3N)
echo "Hot method compilation: $((END - START)) ms"
echo ""

# =============================================================================
# Phase 5: Create Checkpoint
# =============================================================================
echo -e "${YELLOW}[5/5] Create Checkpoint${NC}"
START=$(date +%s%3N)

# Create checkpoint directory
mkdir -p ${CHECKPOINT_DIR}

# Create CDS archive first
mkdir -p ${WARMUP_DIR}/cds
./gradlew createCDS -q --no-daemon 2>/dev/null || echo "CDS creation skipped"

# Create CRaC checkpoint
java -XX:CRaCCheckpointTo=${CHECKPOINT_DIR}/app.jar \
     -XX:+IgnoreUnrecognizedVMOptions \
     -jar build/libs/*.jar &
JAVA_PID=$!

# Wait for checkpoint signal (up to timeout)
TIMEOUT=$((WARMUP_TIMEOUT / 1000))
for i in $(seq 1 $TIMEOUT); do
    if ! kill -0 $JAVA_PID 2>/dev/null; then
        break
    fi
    sleep 1
done

# Kill if still running
kill $JAVA_PID 2>/dev/null || true

END=$(date +%s%3N)
echo "Checkpoint creation: $((END - START)) ms"
echo ""

# =============================================================================
# Summary
# =============================================================================
TOTAL_START=$START
TOTAL_END=$(date +%s%3N)

echo "=============================================="
echo "Warmup Complete"
echo "=============================================="
echo "Total warmup time: $((TOTAL_END - TOTAL_START)) ms"
echo ""
echo "Output files:"
echo "  - Checkpoint: ${CHECKPOINT_DIR}/app.jar"
echo "  - CDS Archive: ${WARMUP_DIR}/cds/app-cds.jsa"
echo ""
echo "To restore from checkpoint:"
echo "  java -XX:CRaCRestoreFrom=${CHECKPOINT_DIR}/app.jar -jar build/libs/*.jar"
echo ""
echo -e "${GREEN}Ready for sub-100ms restores!${NC}"
