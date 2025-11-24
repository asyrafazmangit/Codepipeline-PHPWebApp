@echo off
echo ========================================
echo AWS CodePipeline PHP Web App Deployment
echo ========================================

set PROJECT_NAME=php-webapp
set AWS_REGION=ap-southeast-1
set GITHUB_REPO=your-username/php-webapp

echo.
echo Setting up AWS CLI profile...
echo Please ensure AWS CLI is configured with proper credentials
echo.

echo Step 1: Creating GitHub Personal Access Token Parameter
echo Please create a GitHub Personal Access Token and store it in Parameter Store
echo.
set /p GITHUB_TOKEN="Enter your GitHub Personal Access Token: "

aws ssm put-parameter ^
    --name "/github/personal-access-token" ^
    --value "%GITHUB_TOKEN%" ^
    --type "SecureString" ^
    --overwrite ^
    --region %AWS_REGION%

if %ERRORLEVEL% neq 0 (
    echo ERROR: Failed to store GitHub token
    pause
    exit /b 1
)

echo.
echo Step 2: Deploying Infrastructure Stack...
aws cloudformation deploy ^
    --template-file infrastructure.yaml ^
    --stack-name %PROJECT_NAME%-infrastructure ^
    --parameter-overrides ProjectName=%PROJECT_NAME% ^
    --capabilities CAPABILITY_IAM ^
    --region %AWS_REGION%

if %ERRORLEVEL% neq 0 (
    echo ERROR: Infrastructure deployment failed
    pause
    exit /b 1
)

echo.
echo Step 3: Deploying CodePipeline Stack...
set /p REPO_INPUT="Enter GitHub repository (owner/repo) or press Enter for default [%GITHUB_REPO%]: "
if not "%REPO_INPUT%"=="" set GITHUB_REPO=%REPO_INPUT%

aws cloudformation deploy ^
    --template-file codepipeline.yaml ^
    --stack-name %PROJECT_NAME%-pipeline ^
    --parameter-overrides ProjectName=%PROJECT_NAME% GitHubRepo=%GITHUB_REPO% ^
    --capabilities CAPABILITY_IAM ^
    --region %AWS_REGION%

if %ERRORLEVEL% neq 0 (
    echo ERROR: CodePipeline deployment failed
    pause
    exit /b 1
)

echo.
echo Step 4: Getting deployment information...
echo.
echo Infrastructure Stack Outputs:
aws cloudformation describe-stacks ^
    --stack-name %PROJECT_NAME%-infrastructure ^
    --query "Stacks[0].Outputs" ^
    --region %AWS_REGION%

echo.
echo Pipeline Stack Outputs:
aws cloudformation describe-stacks ^
    --stack-name %PROJECT_NAME%-pipeline ^
    --query "Stacks[0].Outputs" ^
    --region %AWS_REGION%

echo.
echo ========================================
echo Deployment completed successfully!
echo ========================================
echo.
echo Next steps:
echo 1. Push your PHP code to the GitHub repository
echo 2. The pipeline will automatically build and deploy
echo 3. Access your application via the Load Balancer URL shown above
echo.
echo To monitor the pipeline:
echo aws codepipeline get-pipeline-state --name %PROJECT_NAME%-pipeline --region %AWS_REGION%
echo.

pause