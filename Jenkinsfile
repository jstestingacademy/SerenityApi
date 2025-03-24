pipeline {
    agent any

    environment {
        IMAGE_NAME = "serenity-rest-assured-tests"
        CONTAINER_NAME = "serenity-tests"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/jstestingacademy/SerenityApi.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                   sh 'docker build -t my-image:latest .'
                }
            }
        }

        stage('Run Tests in Docker') {
            steps {
                script {
                    sh """
                        docker run --rm --name ${env.CONTAINER_NAME} ${env.IMAGE_NAME}
                    """
                }
            }
        }

        stage('Copy Serenity Reports') {
            steps {
                script {
                    sh """
                        docker cp ${env.CONTAINER_NAME}:/app/target/serenity-reports ./serenity-reports || echo "No reports found"
                    """
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
                    sh """
                        docker rm -f ${env.CONTAINER_NAME} || true
                        docker rmi -f ${env.IMAGE_NAME} || true
                        docker system prune -f || true
                    """
                }
            }
        }
    }

    post {
        always {
            script {
                sh """
                    docker rm -f ${env.CONTAINER_NAME} || true
                    docker rmi -f ${env.IMAGE_NAME} || true
                """
            }
        }
        success {
            echo "✅ Tests executed successfully!"
        }
        failure {
            echo "❌ Tests failed. Check logs for details."
        }
    }
}
