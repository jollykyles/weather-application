pipeline {
    agent any
    triggers {
        pollSCM("* * * * *")
    }
    environment {
        AWS_REGION = 'us-east-2'
        EKS_CLUSTER_NAME = 'weather-cluster'
        AWS_ACCESS_KEY_ID = credentials('db08df42-aeec-4196-a2ef-4aa3dbc26b8f')  // Jenkins ID for the AWS credentials
        AWS_SECRET_ACCESS_KEY = credentials('db08df42-aeec-4196-a2ef-4aa3dbc26b8f')  // Jenkins ID for the AWS credentials
    }

    stage('Configure Kubeconfig') {
        steps {
            sh 'aws eks --region us-east-2 update-kubeconfig --name weather-cluster'
        }
    }
    stages {
        stage('Build Docker Image') {
            when {
                branch 'main'
            }
            steps {
                echo '=== Building Weather App Docker Image ==='
                script {
                    app = docker.build("jollykyles/weather-app")
                }
            }
        }
        stage('Push Docker Image') {
            when {
                branch 'main'
            }
            steps {
                echo '=== Pushing Weather App Docker Image ==='
                script {
                    GIT_COMMIT_HASH = sh(script: "git log -n 1 --pretty=format:'%H'", returnStdout: true)
                    SHORT_COMMIT = GIT_COMMIT_HASH[0..7]
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerHubCredentials') {
                        app.push("$SHORT_COMMIT")
                        app.push("latest")
                    }
                }
            }
        }
        stage('Deploy to EKS') {
            when {
                branch 'main'
            }
            steps {
                echo '=== Deploying Weather App to EKS ==='
                script {
                    sh '''
                    # Configure AWS CLI to access the EKS cluster
                    aws eks --region $AWS_REGION update-kubeconfig --name $EKS_CLUSTER_NAME
                    
                    # Generate Kubernetes deployment and service YAML files
                    cat <<EOF > deployment.yaml
                    apiVersion: apps/v1
                    kind: Deployment
                    metadata:
                      name: weather-app
                      labels:
                        app: weather-app
                    spec:
                      replicas: 2
                      selector:
                        matchLabels:
                          app: weather-app
                      template:
                        metadata:
                          labels:
                            app: weather-app
                        spec:
                          containers:
                          - name: weather-app
                            image: jollykyles/weather-app:latest
                            ports:
                            - containerPort: 8080
                    EOF

                    cat <<EOF > service.yaml
                    apiVersion: v1
                    kind: Service
                    metadata:
                      name: weather-app-service
                    spec:
                      type: LoadBalancer
                      selector:
                        app: weather-app
                      ports:
                      - protocol: TCP
                        port: 80
                        targetPort: 8080
                    EOF

                    # Apply the Kubernetes manifests
                    kubectl apply -f deployment.yaml
                    kubectl apply -f service.yaml
                    '''
                }
            }
        }
    }
}
