pipeline {
    agent any

    environment {
        APP_NAME     = "react-hello-local"
        IMAGE_NAME   = "react-hello-local"
        TAG          = "${BUILD_NUMBER}"
        RELEASE_NAME = ""
        NAMESPACE    = ""
        VALUES_FILE  = ""
    }

    stages {

        stage('Detect Branch') {
            steps {
                script {
                    if (env.BRANCH_NAME == "dev") {
                        env.RELEASE_NAME = "react-dev"
                        env.NAMESPACE    = "dev"
                        env.VALUES_FILE  = "helm/react-app/values-dev.yaml"

                    } else if (env.BRANCH_NAME == "staging") {
                        env.RELEASE_NAME = "react-stage"
                        env.NAMESPACE    = "staging"
                        env.VALUES_FILE  = "helm/react-app/values-staging.yaml"

                    } else if (env.BRANCH_NAME == "prod") {
                        env.RELEASE_NAME = "react-prod"
                        env.NAMESPACE    = "prod"
                        env.VALUES_FILE  = "helm/react-app/values-prod.yaml"

                    } else {
                        error("Unsupported branch: ${env.BRANCH_NAME}")
                    }
                }
            }
        }

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                docker build -t ${IMAGE_NAME}:${TAG} ./app
                """
            }
        }

        stage('Deploy with Helm') {
            steps {
                sh """
                helm upgrade --install ${RELEASE_NAME} ./helm/react-app \
                  --namespace ${NAMESPACE} \
                  --create-namespace \
                  -f ${VALUES_FILE} \
                  --set image.repository=${IMAGE_NAME} \
                  --set image.tag=${TAG}
                """
            }
        }

        stage('Verify Deployment') {
            steps {
                sh """
                kubectl get pods -n ${NAMESPACE}
                kubectl get svc -n ${NAMESPACE}
                """
            }
        }
    }

    post {
        success {
            echo "Deployment successful for ${env.BRANCH_NAME}"
        }

        failure {
            echo "Pipeline failed"
        }
    }
}