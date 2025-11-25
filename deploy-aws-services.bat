@echo off
echo Deploying AWS Services Stack...

aws cloudformation deploy ^
    --template-file aws-services.yaml ^
    --stack-name asyraf-poc-aws-services ^
    --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM ^
    --region ap-southeast-1

if %ERRORLEVEL% EQU 0 (
    echo AWS Services deployment completed successfully!
    echo.
    echo ========================================
    echo JENKINS CREDENTIALS:
    echo ========================================
    echo ACCESS KEY ID:
    aws cloudformation describe-stacks ^
        --stack-name asyraf-poc-aws-services ^
        --query "Stacks[0].Outputs[?OutputKey=='JenkinsAccessKeyId'].OutputValue" ^
        --output text ^
        --region ap-southeast-1
    echo.
    echo SECRET ACCESS KEY:
    aws cloudformation describe-stacks ^
        --stack-name asyraf-poc-aws-services ^
        --query "Stacks[0].Outputs[?OutputKey=='JenkinsSecretAccessKey'].OutputValue" ^
        --output text ^
        --region ap-southeast-1
    echo ========================================
    echo.
    echo ECR Repository URI:
    aws cloudformation describe-stacks ^
        --stack-name asyraf-poc-aws-services ^
        --query "Stacks[0].Outputs[?OutputKey=='ECRRepositoryURI'].OutputValue" ^
        --output text ^
        --region ap-southeast-1
    echo.
    echo Load Balancer URL:
    aws cloudformation describe-stacks ^
        --stack-name asyraf-poc-aws-services ^
        --query "Stacks[0].Outputs[?OutputKey=='LoadBalancerURL'].OutputValue" ^
        --output text ^
        --region ap-southeast-1
    echo.
    echo Save the Jenkins credentials for your Jenkins configuration!
) else (
    echo AWS Services deployment failed!
)

pause