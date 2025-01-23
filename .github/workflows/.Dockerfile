
# Use the official Go image as a builder
FROM golang:1.23-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy Go modules and dependencies
COPY ../../go.mod go.sum ./
RUN go mod download

# Copy the source code
COPY ../.. .

# Build the application
ARG COMMIT_HASH
RUN go build -ldflags "-X main.version=${COMMIT_HASH}" -o app cmd/api/*

# Use a minimal runtime image
FROM alpine:latest

# Set the working directory in the runtime container
WORKDIR /root/

# Copy the compiled binary from the builder
COPY --from=builder /app/app .

# Expose the application port
EXPOSE 4000

# Command to run the application
CMD ["./app"]
