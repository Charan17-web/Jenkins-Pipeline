pipeline {

    agent any

    environment{

        IMAGE_NAME = "demoimage"

        DOCKERHUB_USERNAME = "kunchalavikram"

    }
 
    stages {

        stage('Checkout') {

            steps {

                git 'repo url'

            }

        }

        stage('build'){

            steps{

                withEnv(['PATH+EXTRA=/opt/apache-maven-3.9.5/bin']) {

                    sh 'mvn package'

                }

                sh "ls -al target/"

            }

        }

        stage('dockerize'){

            steps{

                withCredentials([string(credentialsId: 'docker_token', variable: 'TOKEN')]) {

                    sh 'docker login -u kunchalavikram -p ${TOKEN}'

                }

                sh 'docker build -t $IMAGE_NAME:$BUILD_NUMBER .'

                sh 'docker tag $IMAGE_NAME:$BUILD_NUMBER $DOCKERHUB_USERNAME/$IMAGE_NAME:$BUILD_NUMBER'

            }

        }

        stage('push'){

            steps{

                sh 'docker push $DOCKERHUB_USERNAME/$IMAGE_NAME:$BUILD_NUMBER'

            }

        }

    }

}
 
pipeline {

    agent any

    stages {

        stage('Clean') {

            steps {

                echo 'Cleaning...'

                bat 'mvn clean'

            }

        }

        stage('Package') {

            steps {

                echo 'Packaging...'

                bat 'mvn package'

            }

        }

        stage('Build') {

            steps {

                echo 'Building...'

                bat 'mvn install'

            }

        }

    }

}
