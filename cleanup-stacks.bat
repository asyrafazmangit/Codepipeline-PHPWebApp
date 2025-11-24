@echo off
echo ========================================
echo  AWS CloudFormation Cleanup Script
echo ========================================
echo.

echo WARNING: This will delete all AWS resources!
echo Press any key to continue or Ctrl+C to cancel...
pause

echo Deleting Jenkins Pipeline Stack...
aws cloudformation delete-stack ^
    --stack-name asyraf-poc-jenkins-pipeline ^
    --region ap-southeast-1

echo Waiting for Jenkins pipeline stack deletion...
aws cloudformation wait stack-delete-complete ^
    --stack-name asyraf-poc-jenkins-pipeline ^
    --region ap-southeast-1

echo Deleting AWS Services Stack...
aws cloudformation delete-stack ^
    --stack-name asyraf-poc-aws-services ^
    --region ap-southeast-1

echo Waiting for AWS services stack deletion...
aws cloudformation wait stack-delete-complete ^
    --stack-name asyraf-poc-aws-services ^
    --region ap-southeast-1

echo Cleanup completed!
pause