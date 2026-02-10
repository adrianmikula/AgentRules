# Build stage
FROM azul/zulu-openjdk-alpine:21-crac AS builder

WORKDIR /app

# Copy build files
COPY build.gradle settings.gradle ./
COPY gradle ./gradle

# Download dependencies and build
RUN gradle build -x test --no-daemon

# Development stage with CRaC support
FROM azul/zulu-openjdk-alpine:21-crac AS dev

WORKDIR /app

# Install tools for checkpoint/restore
RUN apk add --no-cache curl jq

# Copy build output
COPY --from=builder /app/build/libs/*.jar app.jar

# Expose port
EXPOSE 8080

# Enable CRaC and run with checkpoint
# First run: starts app and creates checkpoint
# Subsequent runs: restore from checkpoint (milliseconds!)
CMD java -XX:CRaCCheckpointTo=/cr -jar app.jar & \
    PID=$! && \
    sleep 5 && \
    curl -s http://localhost:8080/actuator/health && \
    echo "Creating CRaC checkpoint..." && \
    jcmd $PID JDK.checkpoint && \
    wait $PID

# Production stage
FROM azul/zulu-openjdk-alpine:21-crac AS production

WORKDIR /app

# Install tools for checkpoint/restore
RUN apk add --no-cache curl

# Copy build output
COPY --from=builder /app/build/libs/*.jar app.jar

# Create checkpoint directory
RUN mkdir -p /cr

# Copy checkpoint (to be created during build)
COPY --from=builder /app/cr /cr

EXPOSE 8080

# Restore from checkpoint - milliseconds startup!
CMD java -XX:CRaCRestoreFrom=/cr -jar app.jar
