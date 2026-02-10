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

WORKDIR /app

# Install development tools
RUN apk add --no-cache bash vim curl

# Copy dependency cache
COPY --from=builder /root/.m2/repository /root/.m2/repository

# Copy source and install
COPY pom.xml ./
COPY src ./src/

EXPOSE 8080

CMD ["./mvnw", "tomcat7:run", "-DskipTests"]

# =============================================================================
# PRODUCTION STAGE
# =============================================================================
FROM tomcat:10.1-jdk21-alpine AS production

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy built WAR file
COPY --from=builder /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Create non-root user
RUN addgroup -S tomcat && adduser -S tomcat -G tomcat
RUN chown -R tomcat:tomcat /usr/local/tomcat
USER tomcat

EXPOSE 8080

CMD ["catalina.sh", "run"]
