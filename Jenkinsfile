pipeline {
    agent any

    environment {
        IMAGE_NAME = "serenity-rest-assured-tests"
        CONTAINER_NAME = "serenity-tests"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git 'https://github.com/jstestingacademy/SerenityApi.git'  // Replace with your repo
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build --no-cache -t $IMAGE_NAME .'
                }
            }
        }

        stage('Run Tests in Docker') {
            steps {
                script {
                    sh 'docker run --name $CONTAINER_NAME $IMAGE_NAME || true'
                }
            }
        }

        stage('Copy Serenity Reports') {
            steps {
                script {
                    sh 'docker cp $CONTAINER_NAME:/app/target/serenity-reports ./serenity-reports || true'
                }
            }
        }

        stage('Archive Serenity Reports') {
            steps {
                archiveArtifacts artifacts: 'serenity-reports/**/*', fingerprint: true
            }
        }

        stage('Clean Up') {
            steps {
                script {
                    sh 'docker rm -f $CONTAINER_NAME || true'
                    sh 'docker rmi -f $IMAGE_NAME || true'
                }
            }
        }
    }

    post {
        always {
            script {
                sh 'docker rm -f $CONTAINER_NAME || true'
                sh 'docker rmi -f $IMAGE_NAME || true'
            }
        }
        success {
            echo "Tests executed successfully!"
        }
        failure {
            echo "Tests failed. Check logs for details."
        }
    }
}
