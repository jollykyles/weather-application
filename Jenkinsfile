pipeline {
    agent any
       triggers {
        pollSCM "* * * * *"
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
                    GIT_COMMIT_HASH = sh (script: "git log -n 1 --pretty=format:'%H'", returnStdout: true)
                    SHORT_COMMIT = "${GIT_COMMIT_HASH[0..7]}"
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerHubCredentials') {
                        app.push("$SHORT_COMMIT")
                        app.push("latest")
                    }
                }
            }
        }
        // stage('Remove local images') {
        //     steps {
        //         echo '=== Delete the local docker images ==='
        //         sh("sudo docker rmi -f jollykyles/weather-application:latest || :")
        //         sh("sudo docker rmi -f jollykyles/weather-app:$SHORT_COMMIT || :")
        //     }
        // }
    }
}
