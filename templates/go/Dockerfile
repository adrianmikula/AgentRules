# Development stage
FROM golang:1.21-alpine AS dev

WORKDIR /app

# Install dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy source
COPY . .

EXPOSE 8080

CMD ["go", "run", "main.go"]

# Production stage
FROM golang:1.21-alpine AS production

WORKDIR /app

# Build binary
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app main.go

# Runtime image
FROM alpine:latest AS runtime

RUN apk --no-cache add ca-certificates

WORKDIR /app

COPY --from=production /app/app .

EXPOSE 8080

CMD ["./app"]
