@echo off
echo Setting up AWS credentials...

SET AWS_ACCESS_KEY_ID=YOUR_ACCESS_KEY_HERE
SET AWS_SECRET_ACCESS_KEY=YOUR_SECRET_KEY_HERE
SET AWS_SESSION_TOKEN=YOUR_SESSION_TOKEN_HERE
SET AWS_DEFAULT_REGION=ap-southeast-1

echo Testing AWS connection...
aws sts get-caller-identity

if %ERRORLEVEL% EQU 0 (
    echo AWS credentials configured successfully!
    echo Region: ap-southeast-1
) else (
    echo Failed to authenticate with AWS. Please check your credentials.
    echo Note: Session tokens expire after a certain time period.
)

pause