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

EXPOSE 5173

CMD ["pnpm", "run", "dev"]

# =============================================================================
# PRODUCTION STAGE - Nginx serving static files
# =============================================================================
FROM nginx:alpine AS production

# Copy built static files
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Create non-root user
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chown -R nginx:nginx /var/cache/nginx && \
    chown -R nginx:nginx /var/log/nginx && \
    sed -i 's/listen       80;/listen       80;\n    user nginx;/' /etc/nginx/conf.d/default.conf

USER nginx

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
