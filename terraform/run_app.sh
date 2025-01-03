#!/bin/bash
# Update system packages
yum update -y

# Install Docker
amazon-linux-extras enable docker
yum install -y docker
systemctl start docker
systemctl enable docker

# Install Python (optional, for troubleshooting or extending)
yum install -y python3

# Add the ec2-user to the docker group to run Docker without sudo
usermod -a -G docker ec2-user

# Pull the Docker image
docker pull jollykyles/weather-app:latest

# Run the container
docker run -d --name weather-app -p 8080:8080 jollykyles/weather-app:latest

# Verify Docker is running
docker ps
