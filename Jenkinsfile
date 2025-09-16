pipeline {
    agent any

    environment {
        PROJECT_ID = "student-registry-kub-jenkins"
        REGION = "us-central1"
        REPO = "myrepo"
        IMAGE = "myapp"
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        GOOGLE_APPLICATION_CREDENTIALS = credentials('gcp-service-account-key')
        PATH = "$PATH:C:\\Terraform"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

   stage('Terraform Infra Setup') {
            steps {
                dir("terraform/infra") {
                    script {
                        bat '''
                            gcloud auth activate-service-account --key-file=%GOOGLE_APPLICATION_CREDENTIALS%
                            terraform init
                            terraform apply -auto-approve -var project_id=%PROJECT_ID%
                        '''
                    }
                }
            }
        }

    stage('Build & Test (Maven)') {
      steps {
        script {
            bat 'mvn -B -DskipTests=false clean verify'
          }
        }
       }

        stage('Build Docker Image') {
            steps {
                script {
                    bat "docker build -t %REGION%-docker.pkg.dev/%PROJECT_ID%/%REPO%/%IMAGE%:%IMAGE_TAG% ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    bat '''
                        gcloud auth activate-service-account --key-file=%GOOGLE_APPLICATION_CREDENTIALS%
                        gcloud auth configure-docker %REGION%-docker.pkg.dev -q
                        docker push %REGION%-docker.pkg.dev/%PROJECT_ID%/%REPO%/%IMAGE%:%IMAGE_TAG%
                    '''
                }
            }
        }

        stage('Terraform Deploy Workload') {
            steps {
                dir("terraform/workload") {
                    script {
                        bat '''
                            gcloud auth activate-service-account --key-file=%GOOGLE_APPLICATION_CREDENTIALS%
                            terraform init
                            terraform apply -auto-approve -var project_id=%PROJECT_ID% -var image_tag=%IMAGE_TAG%
                        '''
                    }
                }
            }
        }
    }

    post {
        success {
            echo "✅ Deployment Successful! Access via LoadBalancer IP."
        }
        failure {
            echo "❌ Deployment Failed!"
        }
    }
}
