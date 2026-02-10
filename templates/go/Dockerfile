# syntax=docker/dockerfile:1.6
# Enable BuildKit advanced features

# =============================================================================
# BUILDER STAGE
# =============================================================================
FROM golang:1.23-alpine AS builder

WORKDIR /app

# Copy go mod files first for dependency caching
COPY go.mod go.sum ./

# Download dependencies with cache mount
RUN --mount=type=cache,target=/go/pkg/mod \
    go mod download

# Copy source and build
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o /app.bin ./cmd/app

# =============================================================================
# DEVELOPMENT STAGE
# =============================================================================
FROM golang:1.23-alpine AS development

WORKDIR /app

# Copy go mod cache
COPY --from=builder /go/pkg/mod /go/pkg/mod
COPY go.mod go.sum ./

# Install air for hot reload
RUN --mount=type=cache,target=/go/pkg/mod \
    go install github.com/air-verse/air@latest

COPY . .

EXPOSE 8080

CMD ["air", "-c", ".air.toml"]

# =============================================================================
# PRODUCTION STAGE - Minimal
# =============================================================================
FROM alpine:3.20 AS production

# Install CA certificates
RUN apk add --no-cache ca-certificates tzdata

WORKDIR /app

# Create non-root user
RUN addgroup -S app && adduser -S app -G app
USER app

# Copy binary
COPY --from=builder /app.bin app.jar

EXPOSE 8080

CMD ["./app.bin"]
