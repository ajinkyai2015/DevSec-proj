#!/bin/bash
# Jenkins installation script

# Update packages and install Jenkins dependencies
sudo apt-get update -y
sudo apt-get install -y openjdk-11-jdk wget gnupg2

# Download and add Jenkins key
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

# Add Jenkins repository
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update package list and install Jenkins
sudo apt-get update
sudo apt-get install -y jenkins

# Start Jenkins service and enable it to start at boot
sudo systemctl start jenkins
sudo systemctl enable jenkins
