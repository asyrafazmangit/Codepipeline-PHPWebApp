@echo off
echo ========================================
echo AWS Resources Cleanup Script
echo ========================================

set PROJECT_NAME=php-webapp
set AWS_REGION=ap-southeast-1

echo.
echo WARNING: This will delete all AWS resources created by the deployment!
set /p CONFIRM="Are you sure you want to proceed? (yes/no): "

if /i not "%CONFIRM%"=="yes" (
    echo Cleanup cancelled.
    pause
    exit /b 0
)

echo.
echo Step 1: Deleting CodePipeline Stack...
aws cloudformation delete-stack ^
    --stack-name %PROJECT_NAME%-pipeline ^
    --region %AWS_REGION%

echo Waiting for pipeline stack deletion...
aws cloudformation wait stack-delete-complete ^
    --stack-name %PROJECT_NAME%-pipeline ^
    --region %AWS_REGION%

echo.
echo Step 2: Emptying S3 Artifacts Bucket...
for /f "tokens=*" %%i in ('aws s3api list-buckets --query "Buckets[?contains(Name, '%PROJECT_NAME%-pipeline-artifacts')].Name" --output text --region %AWS_REGION%') do (
    echo Emptying bucket: %%i
    aws s3 rm s3://%%i --recursive --region %AWS_REGION%
)

echo.
echo Step 3: Deleting Infrastructure Stack...
aws cloudformation delete-stack ^
    --stack-name %PROJECT_NAME%-infrastructure ^
    --region %AWS_REGION%

echo Waiting for infrastructure stack deletion...
aws cloudformation wait stack-delete-complete ^
    --stack-name %PROJECT_NAME%-infrastructure ^
    --region %AWS_REGION%

echo.
echo Step 4: Deleting ECR Repository...
aws ecr delete-repository ^
    --repository-name %PROJECT_NAME%-repo ^
    --force ^
    --region %AWS_REGION% 2>nul

echo.
echo Step 5: Deleting GitHub Token Parameter...
aws ssm delete-parameter ^
    --name "/github/personal-access-token" ^
    --region %AWS_REGION% 2>nul

echo.
echo ========================================
echo Cleanup completed successfully!
echo ========================================

pause