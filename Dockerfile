# Use a base image that has necessary tools
FROM alpine:latest

# Install Git
RUN apk add --no-cache git

# Add entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the script as the entrypoint
ENTRYPOINT ["/entrypoint.sh"]
