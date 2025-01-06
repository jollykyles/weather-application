# Weather Application

## Overview

The **Weather Application** is a fully functional weather forecasting app built to showcase various components in a cloud-based architecture. This app leverages Kubernetes for container orchestration, Amazon Web Services (AWS) for cloud infrastructure, and Jenkins for continuous integration and deployment. It provides users with weather information in a user-friendly interface and is accessible via an external load balancer.

This project was developed as part of the **INADEV Interview** challenge and demonstrates the deployment of the app to AWS EKS (Elastic Kubernetes Service), with automated CI/CD pipelines using Jenkins.

## App Access

You can access the Weather Application by visiting the following link:

[Weather Application](http://a0ebe174bcef5479eb084b35ef6ed616-838719233.us-east-2.elb.amazonaws.com)

The app is hosted on AWS using an **Elastic Load Balancer (ELB)** and exposes the application to the internet via port 80.

## Jenkins Access

Continuous Integration and Deployment (CI/CD) for this application is managed through Jenkins. The Jenkins server is set up for automating build, test, and deployment processes. You can access Jenkins here:

[Jenkins Dashboard](http://ec2-3-139-85-130.us-east-2.compute.amazonaws.com:8080)

### Jenkins Credentials:
- **Username**: Admin
- **Password**: Admin

Ensure you use the provided credentials to log in and access Jenkins' CI/CD pipeline configurations.

## Technologies Used

- **Kubernetes (EKS)**: Orchestrates containerized applications.
- **Amazon Web Services (AWS)**: Hosts the application and provides scalable cloud services.
- **Jenkins**: Automates the deployment pipeline, ensuring continuous delivery.
- **Docker**: Containerizes the weather application for deployment in Kubernetes.
- **Elastic Load Balancer (ELB)**: Routes traffic to the weather app for external access.

## Features

- **Weather Forecasting**: Users can view real-time weather data for various cities.
- **Scalable Deployment**: The app is deployed on AWS EKS, enabling automatic scaling based on traffic.
- **CI/CD Pipeline**: Automated deployment through Jenkins ensures the latest version of the app is always deployed without manual intervention.
- **User Authentication**: Protected Jenkins interface for authorized access.

## Architecture

This weather application follows a microservices architecture deployed on Kubernetes. The components include:

- **Frontend**: The user-facing weather data display.
- **Backend**: The API that handles requests and fetches weather data.
- **Database**: A persistent layer for storing user preferences and weather data (if applicable).

The Kubernetes setup ensures high availability, fault tolerance, and the ability to scale based on traffic demands.

## Deployment Instructions

1. **Create Kubernetes Cluster**: 
   - Set up an AWS EKS cluster using Terraform or AWS Management Console.
   
2. **Deploy Application**:
   - Build and push Docker images to a container registry like Docker Hub or AWS ECR.
   - Apply Kubernetes manifests to deploy pods, services, and other resources.
   
3. **Configure Jenkins**:
   - Set up Jenkins with the provided credentials for automated builds.
   - Create a Jenkinsfile that defines the build, test, and deploy pipeline.

4. **Expose App via ELB**:
   - The application is exposed through a **LoadBalancer** service in Kubernetes, enabling external access.