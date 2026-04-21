#!/bin/bash

# Update system and install core packages
sudo apt update
sudo apt install fontconfig openjdk-21-jre -y

# Jenkins installation
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get -y install jenkins

sudo systemctl start jenkins
sudo systemctl enable jenkins

# Docker installation
sudo apt-get update
sudo apt-get install docker.io -y

# User group permission
sudo usermod -aG docker ubuntu
sudo usermod -aG docker jenkins
newgrp

sudo systemctl restart docker
sudo systemctl restart jenkins

# Install dependencies and Trivy
sudo apt-get install wget gnupg -y
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb generic main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update -y
sudo apt-get install trivy -y

# AWS CLI installation
sudo snap install aws-cli --classic

# Helm installation
sudo snap install helm --classic

# Kubectl installation
sudo snap install kubectl --classic
