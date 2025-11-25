pipeline {
    agent any
    
    environment {
        AWS_REGION = 'ap-southeast-1'
        AWS_ACCOUNT_ID = '180016241382'
        ECR_REPOSITORY = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/asyraf-poc-php-app"
        IMAGE_TAG = "${BUILD_NUMBER}"
        ECS_CLUSTER = 'asyraf-poc-cluster'
        ECS_SERVICE = 'asyraf-poc-service'
        TASK_DEFINITION = 'asyraf-poc-task'
    }
    
    stages {
        stage('Install AWS CLI') {
            steps {
                sh '''
                    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
                    unzip -q awscliv2.zip
                    sudo ./aws/install --update
                    aws --version
                '''
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    sh '''
                        docker build -t ${ECR_REPOSITORY}:${IMAGE_TAG} .
                        docker tag ${ECR_REPOSITORY}:${IMAGE_TAG} ${ECR_REPOSITORY}:latest
                    '''
                }
            }
        }
        
        stage('Push to ECR') {
            steps {
                script {
                    sh '''
                        aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
                        docker push ${ECR_REPOSITORY}:${IMAGE_TAG}
                        docker push ${ECR_REPOSITORY}:latest
                    '''
                }
            }
        }
        
        stage('Update ECS Service') {
            steps {
                script {
                    sh '''
                        # Get current task definition
                        TASK_DEFINITION_ARN=$(aws ecs describe-task-definition --task-definition ${TASK_DEFINITION} --region ${AWS_REGION} --query 'taskDefinition.taskDefinitionArn' --output text)
                        
                        # Update ECS service to force new deployment
                        aws ecs update-service --cluster ${ECS_CLUSTER} --service ${ECS_SERVICE} --force-new-deployment --region ${AWS_REGION}
                        
                        # Wait for deployment to complete
                        aws ecs wait services-stable --cluster ${ECS_CLUSTER} --services ${ECS_SERVICE} --region ${AWS_REGION}
                    '''
                }
            }
        }
    }
    
    post {
        always {
            sh 'docker system prune -f'
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}