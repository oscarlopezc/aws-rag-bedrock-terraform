#!/bin/bash

set -e

# Update base system
apt-get update -y
apt-get upgrade -y

# Install dependencies
apt-get install -y ca-certificates curl gnupg lsb-release

# Add Docker official GPG key
mkdir -p /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Add Docker repo
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker + Compose V2
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Install AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
apt-get install -y unzip
unzip awscliv2.zip
sudo ./aws/install

# Enable Docker
systemctl start docker
systemctl enable docker

# Add ubuntu user to docker group
usermod -aG docker ubuntu

# =========================
# FLUENT BIT AGENT (BASIC)
# =========================

# Install Fluent Bit (quick install script)
curl https://raw.githubusercontent.com/fluent/fluent-bit/master/install.sh | sh

# Start Fluent Bit as background agent (no config yet)
fluent-bit &