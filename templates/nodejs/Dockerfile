# syntax=docker/dockerfile:1.6
# Enable BuildKit advanced features

# =============================================================================
# BUILDER STAGE
# =============================================================================
FROM node:22-alpine AS builder

WORKDIR /app

# Copy package files first for better layer caching
COPY package.json pnpm-lock.yaml ./

# Install dependencies with cache mount
RUN --mount=type=cache,target=/app/.pnpm-store \
    pnpm install --frozen-lockfile

# Copy source and build
COPY . .
RUN pnpm run build

# =============================================================================
# DEVELOPMENT STAGE
# =============================================================================
FROM node:22-alpine AS development

WORKDIR /app

# Copy pnpm store cache
COPY --from=builder /app/.pnpm-store /app/.pnpm-store
COPY package.json pnpm-lock.yaml ./

# Install dependencies
RUN pnpm install --frozen-lockfile

COPY . .

EXPOSE 3000

CMD ["pnpm", "run", "dev"]

# =============================================================================
# PRODUCTION STAGE
# =============================================================================
FROM node:22-alpine AS production

WORKDIR /app

# Create non-root user
RUN addgroup -S nodejs && adduser -S nodejs -G nodejs
USER nodejs

# Copy built files
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./

EXPOSE 3000

CMD ["node", "dist/server/index.js"]
