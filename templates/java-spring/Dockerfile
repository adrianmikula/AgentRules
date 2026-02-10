# syntax=docker/dockerfile:1.6
# Enable BuildKit advanced features

# =============================================================================
# BUILDER STAGE
# =============================================================================
FROM eclipse-temurin:21-jdk-alpine AS builder

WORKDIR /app

# Copy dependency files first for better layer caching
COPY pom.xml ./
COPY src ./src/

# Download dependencies with cache mount
RUN --mount=type=cache,target=/root/.m2/repository \
    ./mvnw dependency:go-offline -B -q && \
    ./mvnw package -DskipTests -B -q -DskipTests

# =============================================================================
# DEVELOPMENT STAGE
# =============================================================================
FROM eclipse-temurin:21-jdk-alpine AS development

# Install development tools
RUN apk add --no-cache bash vim curl

WORKDIR /app

# Copy dependency cache
COPY --from=builder /root/.m2/repository /root/.m2/repository

# Copy source and install
COPY pom.xml ./
COPY src ./src/

EXPOSE 8080

CMD ["./mvnw", "spring-boot:run", "-Dspring-boot.run.fork=false"]

# =============================================================================
# PRODUCTION STAGE
# =============================================================================
FROM eclipse-temurin:21-jre-alpine AS production

WORKDIR /app

# Create non-root user
RUN addgroup -S spring && adduser -S spring -G spring
USER spring

# Copy built artifact
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
