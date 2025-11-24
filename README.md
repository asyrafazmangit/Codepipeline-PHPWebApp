# AWS CodePipeline PHP Web App Deployment

This project sets up a complete CI/CD pipeline for deploying a PHP web application on AWS using CodePipeline, ECS Fargate, and supporting infrastructure.

## Architecture

- **VPC**: Custom VPC with public/private subnets across 2 AZs
- **NAT Gateway**: For outbound internet access from private subnets
- **ECS Fargate**: Containerized PHP application deployment
- **Application Load Balancer**: Traffic distribution and high availability
- **CodePipeline**: Automated CI/CD pipeline
- **CodeBuild**: Docker image building and ECR push
- **ECR**: Container image registry

## Prerequisites

1. **AWS CLI** installed and configured with appropriate permissions
2. **GitHub repository** with your PHP application code
3. **GitHub Personal Access Token** with repo permissions

## Quick Start

### 1. Automated Deployment

Run the deployment script:
```cmd
deploy.bat
```

This script will:
- Store your GitHub token in AWS Parameter Store
- Deploy the infrastructure stack (VPC, ECS, NAT Gateway, etc.)
- Deploy the CodePipeline stack
- Display deployment information

### 2. Manual Deployment

If you prefer manual deployment:

#### Deploy Infrastructure:
```cmd
aws cloudformation deploy ^
    --template-file infrastructure.yaml ^
    --stack-name php-webapp-infrastructure ^
    --parameter-overrides ProjectName=php-webapp ^
    --capabilities CAPABILITY_IAM ^
    --region ap-southeast-1
```

#### Store GitHub Token:
```cmd
aws ssm put-parameter ^
    --name "/github/personal-access-token" ^
    --value "your-github-token" ^
    --type "SecureString" ^
    --region ap-southeast-1
```

#### Deploy CodePipeline:
```cmd
aws cloudformation deploy ^
    --template-file codepipeline.yaml ^
    --stack-name php-webapp-pipeline ^
    --parameter-overrides ProjectName=php-webapp GitHubRepo=your-username/your-repo ^
    --capabilities CAPABILITY_IAM ^
    --region ap-southeast-1
```

## File Structure

```
├── infrastructure.yaml    # CloudFormation template for AWS infrastructure
├── codepipeline.yaml     # CloudFormation template for CI/CD pipeline
├── Dockerfile            # Docker configuration for PHP app
├── index.php            # Sample PHP application
├── deploy.bat           # Automated deployment script
├── cleanup.bat          # Resource cleanup script
└── README.md           # This file
```

## Configuration

### Parameters you can customize:

- **ProjectName**: Change the project name (default: php-webapp)
- **AWS Region**: Modify the region in batch scripts (default: ap-southeast-1)
- **GitHub Repository**: Update your repository details
- **Instance Sizes**: Modify ECS task CPU/Memory in infrastructure.yaml

### Environment Variables:

The CodeBuild project uses these environment variables:
- `AWS_DEFAULT_REGION`: AWS region
- `AWS_ACCOUNT_ID`: Your AWS account ID
- `IMAGE_REPO_NAME`: ECR repository name
- `IMAGE_TAG`: Docker image tag (default: latest)

## Monitoring

### Check Pipeline Status:
```cmd
aws codepipeline get-pipeline-state --name php-webapp-pipeline --region ap-southeast-1
```

### View ECS Service:
```cmd
aws ecs describe-services --cluster php-webapp-cluster --services php-webapp-service --region ap-southeast-1
```

### Check Application Logs:
```cmd
aws logs tail /ecs/php-webapp --follow --region ap-southeast-1
```

## Cleanup

To remove all AWS resources:
```cmd
cleanup.bat
```

This will delete:
- CodePipeline and related resources
- ECS cluster and services
- VPC and networking components
- ECR repository
- S3 artifacts bucket
- CloudWatch logs

## Troubleshooting

### Common Issues:

1. **GitHub Token Issues**: Ensure your token has proper repository permissions
2. **ECS Task Failures**: Check CloudWatch logs for container errors
3. **Build Failures**: Review CodeBuild logs in the AWS Console
4. **Network Issues**: Verify VPC and security group configurations

### Useful Commands:

```cmd
# Check stack status
aws cloudformation describe-stacks --stack-name php-webapp-infrastructure --region ap-southeast-1

# View pipeline execution
aws codepipeline list-pipeline-executions --pipeline-name php-webapp-pipeline --region ap-southeast-1

# Check ECS tasks
aws ecs list-tasks --cluster php-webapp-cluster --region ap-southeast-1
```

## Security Considerations

- GitHub tokens are stored securely in AWS Parameter Store
- ECS tasks run in private subnets
- Security groups restrict access appropriately
- IAM roles follow least privilege principle

## Cost Optimization

- ECS Fargate tasks are configured with minimal resources
- NAT Gateway is deployed in single AZ (can be expanded for HA)
- CloudWatch logs have 7-day retention
- Consider using Spot instances for non-production workloads

## Next Steps

1. Customize the PHP application in `index.php`
2. Add database connectivity if needed
3. Implement SSL/TLS with ACM certificates
4. Add monitoring and alerting with CloudWatch
5. Implement blue/green deployments
6. Add automated testing stages