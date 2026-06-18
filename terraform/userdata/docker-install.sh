#!/bin/bash

apt-get update -y

# Instalar Docker
apt-get install -y docker.io

# Instalar Docker Compose
apt-get install -y docker-compose

# Instalar AWS CLI
apt-get install -y awscli

# Iniciar Docker
systemctl start docker
systemctl enable docker

# Permitir que ubuntu use Docker sin sudo
usermod -aG docker ubuntu

