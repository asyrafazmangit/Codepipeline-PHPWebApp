@echo off
echo Deploying Jenkins Pipeline Stack...

aws cloudformation deploy ^
    --template-file jenkins-pipeline.yaml ^
    --stack-name asyraf-poc-jenkins-pipeline ^
    --region ap-southeast-1

if %ERRORLEVEL% EQU 0 (
    echo Jenkins Pipeline deployment completed successfully!
    echo.
    echo ========================================
    echo JENKINS PIPELINE CREDENTIALS:
    echo ========================================
    echo ACCESS KEY ID:
    aws cloudformation describe-stacks ^
        --stack-name asyraf-poc-jenkins-pipeline ^
        --query "Stacks[0].Outputs[?OutputKey=='JenkinsPipelineAccessKeyId'].OutputValue" ^
        --output text ^
        --region ap-southeast-1
    echo.
    echo SECRET ACCESS KEY:
    aws cloudformation describe-stacks ^
        --stack-name asyraf-poc-jenkins-pipeline ^
        --query "Stacks[0].Outputs[?OutputKey=='JenkinsPipelineSecretAccessKey'].OutputValue" ^
        --output text ^
        --region ap-southeast-1
    echo ========================================
    echo.
    echo ECR Repository URI:
    aws cloudformation describe-stacks ^
        --stack-name asyraf-poc-jenkins-pipeline ^
        --query "Stacks[0].Outputs[?OutputKey=='ECRRepositoryURI'].OutputValue" ^
        --output text ^
        --region ap-southeast-1
    echo.
    echo Use these credentials in Jenkins for pipeline commits!
) else (
    echo Jenkins Pipeline deployment failed!
)

pause