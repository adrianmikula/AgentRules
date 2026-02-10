#!/usr/bin/env pwsh
# Java CRaC Build and Test Script for Windows

$ErrorActionPreference = "Stop"

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  Java CRaC Template - Windows Build Script" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

# Check if Docker is running
try {
    $dockerVersion = docker --version
    Write-Host "✓ Docker is installed: $dockerVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ Docker is not installed or not running" -ForegroundColor Red
    Write-Host "Please install Docker Desktop with WSL2 backend" -ForegroundColor Yellow
    exit 1
}

# Check if Docker is using Linux containers
try {
    $dockerInfo = docker info --format '{{.OSType}}' 2>$null
    if ($dockerInfo -ne "linux") {
        Write-Host "✗ Docker is not using Linux containers" -ForegroundColor Red
        Write-Host "Please enable Linux containers in Docker Desktop settings" -ForegroundColor Yellow
        exit 1
    }
    Write-Host "✓ Using Linux containers" -ForegroundColor Green
} catch {
    Write-Host "✗ Unable to check container type" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Step 1: Building Java project..." -ForegroundColor Yellow
try {
    ./gradlew build -x test --no-daemon --console=plain
    Write-Host "✓ Build complete" -ForegroundColor Green
} catch {
    Write-Host "✗ Build failed" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Step 2: Building Docker images..." -ForegroundColor Yellow
try {
    docker build -t java-crac:builder --target builder .
    Write-Host "✓ Builder image built" -ForegroundColor Green

    docker build -t java-crac:dev --target dev .
    Write-Host "✓ Dev image built" -ForegroundColor Green

    docker build -t java-crac:production --target production .
    Write-Host "✓ Production image built" -ForegroundColor Green

    docker build -t java-crac:test --target test-runner .
    Write-Host "✓ Test image built" -ForegroundColor Green
} catch {
    Write-Host "✗ Docker build failed" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  Build Complete!" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Available commands:" -ForegroundColor White
Write-Host "  # Create checkpoint (run once):"
Write-Host "  docker run -v \$(pwd)/checkpoint:/cr java-crac:dev"
Write-Host ""
Write-Host "  # Run tests (ultra-fast after checkpoint):"
Write-Host "  docker run -v \$(pwd)/checkpoint:/cr java-crac:test"
Write-Host ""
Write-Host "  # Run production (restored from checkpoint):"
Write-Host "  docker run -p 8080:8080 -v \$(pwd)/checkpoint:/cr java-crac:production"
