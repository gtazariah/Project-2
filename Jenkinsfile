pipeline {

agent any

environment {
    IMAGE_NAME  = "azariahgt/trend-react-app"
    IMAGE_TAG   = "${BUILD_NUMBER}"
    AWS_REGION  = "us-east-1"
    EKS_CLUSTER = "trend-eks-cluster"
}

stages {

    stage('Checkout') {
        steps {
            checkout scm
        }
    }

    stage('Build Docker Image') {
        steps {
            sh '''
                docker build \
                  -t ${IMAGE_NAME}:${IMAGE_TAG} .
            '''
        }
    }

    stage('Docker Hub Login and Push') {
        steps {
            withCredentials([
                usernamePassword(
                    credentialsId: 'dockerhub-credentials',
                    usernameVariable: 'DOCKER_USERNAME',
                    passwordVariable: 'DOCKER_PASSWORD'
                )
            ]) {
                sh '''
                    echo "$DOCKER_PASSWORD" | docker login \
                      -u "$DOCKER_USERNAME" \
                      --password-stdin

                    docker push ${IMAGE_NAME}:${IMAGE_TAG}

                    docker logout
                '''
            }
        }
    }

    stage('Configure EKS') {
        steps {
            sh '''
                aws eks update-kubeconfig \
                  --region ${AWS_REGION} \
                  --name ${EKS_CLUSTER}
            '''
        }
    }

    stage('Deploy to EKS') {
        steps {
            sh '''
                kubectl apply -f kubernetes/deployment.yaml
                kubectl apply -f kubernetes/service.yaml
            '''
        }
    }

    stage('Update Image') {
        steps {
            sh '''
                kubectl set image deployment/trend-react-app \
                  trend-react-app=${IMAGE_NAME}:${IMAGE_TAG}
            '''
        }
    }

    stage('Verify Deployment') {
        steps {
            sh '''
                kubectl rollout status deployment/trend-react-app

                kubectl get pods

                kubectl get svc
            '''
        }
    }
}
post {
    success {
        echo """ 
        ===================================== 
        PIPELINE COMPLETED SUCCESSFULLY 
        ===================================== 
        Image: ${IMAGE_REPOSITORY}:${IMAGE_TAG} 
        Cluster: ${EKS_CLUSTER} 
        Region: ${AWS_REGION} 
        """
    }

    failure {
        echo """ 
        ===================================== 
        PIPELINE FAILED 
        ===================================== 
        Image: ${IMAGE_REPOSITORY}:${IMAGE_TAG} 
        Cluster: ${EKS_CLUSTER} 
        Region: ${AWS_REGION} 
        """
    }
    always {
        sh ''' 
            echo "Cleaning unused Docker images..." 
            docker image prune -f || true 
            '''
    }
}
