# Dockerfile - Roblox-TS build environment

# syntax=docker/dockerfile:1.5

# =============================================================================
# Stage 1: Builder
# =============================================================================
FROM node:18-alpine AS builder

# Install TypeScript and rbx-tsc globally
RUN npm install -g typescript@5.0.0 rbxts@4.0.0 selene

# Set working directory
WORKDIR /app

# Copy package files
COPY package.json package-lock.json* ./

# Install dependencies
RUN npm ci

# Copy source
COPY . .

# =============================================================================
# Stage 2: Production
# =============================================================================
FROM node:18-alpine AS production

# Install TypeScript and rbx-tsc
RUN npm install -g typescript@5.0.0 rbxts@4.0.0

# Set working directory
WORKDIR /app

# Copy from builder
COPY --from=builder /app/node_modules /app/node_modules
COPY --from=builder /app/package.json /app/package.json
COPY --from=builder /app/tsconfig.json /app/tsconfig.json
COPY --from=builder /app/src /app/src

# Build
RUN npm run build

# Entrypoint
ENTRYPOINT ["npm", "run"]

# =============================================================================
# Build Commands
# =============================================================================
#
# Build production image:
#   docker build -t roblox-ts:latest .
#
# Run with Rojo sync:
#   docker run -v $(pwd)/out:/app/out roblox-ts:latest
#
# Build multi-platform:
#   docker buildx build \
#     --platform linux/amd64,linux/arm64 \
#     -t roblox-ts:latest \
#     --push .
#
