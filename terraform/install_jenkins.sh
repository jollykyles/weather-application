#!/bin/bash
sudo yum -y update

echo "Install Java JDK 8"
sudo yum remove -y java
sudo yum install java-17-amazon-corretto

echo "Install Maven"
sudo yum install -y maven 

echo "Install git"
sudo yum install -y git

echo "Install Docker engine"
sudo yum update -y
sudo yum install docker -y
sudo systemctl enable docker.service

echo "Install Jenkins"
sudo yum update –y
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade
sudo yum install jenkins -y
sudo systemctl enable jenkins
sudo service docker start
sudo systemctl start jenkins