# Java Tomcat Boilerplate - Fast Docker Image
# Optimized for agentic development velocity

# Build stage
FROM maven:3.9-eclipse-temurin-11 AS builder

WORKDIR /build

# Copy POM and build
COPY pom.xml ./
RUN mvn dependency:go-offline -B -q

# Copy source
COPY src ./src

# Build WAR
RUN mvn package -DskipTests -B -q

# Development stage - fast iteration
FROM maven:3.9-eclipse-temurin-11 AS dev

WORKDIR /app

# Copy POM for dependency resolution
COPY pom.xml ./
RUN mvn dependency:go-offline -B -q

# Copy source
COPY src ./src

# Fast test command
CMD ["mvn", "test", "-Dtest=FastTests", "-DfailIfNoTests=false", "-B", "-q"]

# Production stage - WAR deployment
FROM tomcat:10.1-jdk11-temurin-jammy AS production

# Copy WAR to webapps
COPY --from=builder /build/target/*.war /usr/local/tomcat/webapps/

# Expose port
EXPOSE 8080

# Multi-stage build targets
# Build dev: docker build --target dev -t app-tomcat:dev .
# Run dev: docker run -v $(pwd):/app -w /app app-tomcat:dev mvn test -Dtest=FastTests -DfailIfNoTests=false
# Build prod: docker build --target production -t app-tomcat:prod .
# Run prod: docker run -p 8080:8080 app-tomcat:prod

# Agent loop example:
# docker build --target dev -t app-tomcat:dev .
# docker run -v $(pwd):/app -w /app app-tomcat:dev mvn test -Dtest=FastTests -DfailIfNoTests=false -B
