pipeline {
    agent any

    environment {
        IMAGE_NAME = 'string-theory-guitars'
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {

        stage('Install') {
            steps {
                script {
                    if (isUnix()) {
                        sh 'npm install'
                    } else {
                        bat 'npm install'
                    }
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    if (isUnix()) {
                        sh 'npm test'
                    } else {
                        bat 'npm test'
                    }
                }
            }
        }

        stage('Build image') {
            steps {
                script {
                    if (isUnix()) {
                        sh 'docker build -t $IMAGE_NAME:$IMAGE_TAG .'
                    } else {
                        bat 'docker build -t %IMAGE_NAME%:%IMAGE_TAG% .'
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    if (isUnix()) {
                        sh 'docker compose up -d --build --remove-orphans'
                    } else {
                        bat 'docker compose up -d --build --remove-orphans'
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
