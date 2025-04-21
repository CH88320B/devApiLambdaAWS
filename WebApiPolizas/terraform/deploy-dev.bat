@echo off
echo ================================
echo Creando ambiente DEV en AWS
echo ================================
terraform init
terraform workspace select dev || terraform workspace new dev
terraform apply -auto-approve
pause
