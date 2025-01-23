FROM alpine:latest

# Set up the working directory
WORKDIR /app

# Copy the built binary from the builder stage
COPY ./bin/* /app/demo_cloud

# Expose the application port
EXPOSE 4000
