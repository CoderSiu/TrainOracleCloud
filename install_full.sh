#!/bin/bash

# Check if Docker is installed, and if not, install it
if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    usermod -aG docker $USER
    rm get-docker.sh
    echo "Docker installed successfully."
fi

# Check if Docker Compose is installed, and if not, install it
if ! command -v docker-compose &> /dev/null; then
    echo "Installing Docker Compose..."
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    echo "Docker Compose installed successfully."
fi

# Create a docker-compose.yml file with the provided content
echo "Creating docker-compose.yml..."
cat <<EOL > docker-compose.yml
version: "3.8"

services:
  task:
    image: python:3.9
    restart: always
    command: timeout 1m wget 'http://speed.cloudflare.com/__down?bytes=100000000000' --limit-rate 125M -O /dev/null
    deploy:
      replicas: 4
EOL
echo "docker-compose.yml created successfully."

# Start containers using Docker Compose
echo "Starting containers with Docker Compose..."
docker-compose up -d
echo "Containers started successfully."

echo "Script completed."
