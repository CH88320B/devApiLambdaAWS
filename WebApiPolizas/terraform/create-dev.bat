@echo off
echo ================================
echo Creando ambiente DEV en AWS
echo ================================

cd /d C:\Users\hendersoncastaneda\Documents\TestWebApiPolizasAWS\WebApiPolizas\terraform

terraform init
terraform workspace select dev || terraform workspace new dev
terraform apply -auto-approve
pause
