pipeline {
  agent any
  environment { IMAGE_NAME = 'string-theory-guitars' }
  stages {
    stage('Install') { steps { sh 'npm install' } }
    stage('Test') { steps { sh 'npm test' } }
    stage('Build image') { steps { sh 'docker build -t $IMAGE_NAME:$BUILD_NUMBER .' } }
    stage('Deploy') { when { branch 'main' } steps { sh 'docker compose up -d --build' } }
  }
  post { always { cleanWs() } }
}
