Terraform + WebApiPolizas + Lambada Function +  API GAteway  + Azure SQLserver Database:

# WebApiPolizas Deployment with Terraform on AWS


---

## 📋 Project Overview

This project deploys the **WebApiPolizas** API application as an **AWS Lambda function**, exposes it through **Amazon API Gateway**, and manages the entire infrastructure using **Terraform**.

The architecture allows **multi-environment deployment** (dev, qa, prod) using **Terraform Workspaces**, with automation scripts for easy deployment and destruction.

---

## 📈 Architecture

```plaintext
[Terraform] 
    ➡ [AWS Lambda: WebApiPolizas]
    ➡ [AWS API Gateway: WebApiPolizasAPI]
    ➡ [Internet Clients]
Terraform: Infrastructure as Code.

AWS Lambda: Serverless execution of the WebApiPolizas API.

API Gateway: HTTP interface to expose the Lambda to the public internet.

AWS CLI: Used for authentication and credential management.

🚀 Features
✅ Fully automated deployment with Terraform.

✅ Infrastructure managed per environment (dev, qa, prod).

✅ Use of Terraform Workspaces for isolated environments.

✅ Automation scripts for creation and destruction (.bat files).

✅ Serverless and scalable architecture.

✅ Professional structure for future CI/CD integrations.

🛠️ Prerequisites

Tool	Required Version
Terraform	1.11.4 (or latest stable)
AWS CLI	v2
AWS Account	Free Tier sufficient
.NET Build	WebApiPolizas.zip compiled and ready
📁 Project Structure
plaintext
Copy
Edit
/terraform/
  ├── main.tf
  ├── provider.tf
  ├── outputs.tf
  ├── variables.tf
  ├── lambda/
      └── WebApiPolizas.zip
  ├── create-dev.bat
  ├── create-qa.bat
  ├── create-prod.bat
  ├── destroy-dev.bat
  ├── destroy-qa.bat
  ├── destroy-prod.bat
main.tf: Resource definitions (Lambda, API Gateway, IAM permissions).

provider.tf: AWS provider configuration.

outputs.tf: Outputs like API Gateway URL.

variables.tf: Input variables and locals.

lambda/WebApiPolizas.zip: Lambda deployment package.

.bat scripts: Simplified commands to deploy/destroy by environment.

🌍 Environment Management (Workspaces)

Environment	Workspace Name
Development	dev
Quality Assurance	qa
Production	prod
Switching between environments is done automatically by the .bat scripts or manually with:


terraform workspace select dev
terraform workspace select qa
terraform workspace select prod
📦 Deployment Instructions
1. Initialize Terraform

terraform init
2. Create/Select Workspace
Example for development environment:


terraform workspace new dev
terraform apply -auto-approve
Or simply run the .bat script:


create-dev.bat
✅ Repeat similarly for qa and prod.

🧹 Destroy Instructions
To destroy the environment resources:


terraform workspace select dev
terraform destroy -auto-approve
Or use:


destroy-dev.bat
✅ Repeat similarly for qa and prod.

🔒 AWS Authentication
The project uses AWS CLI default profile (default) for authentication. Make sure you have configured it:


aws configure
You should have valid aws_access_key_id and aws_secret_access_key.

📈 Outputs
After deployment, Terraform will output:

Lambda Function Name.

API Gateway URL.

Example:


api_url = https://xxxxxxxxxx.execute-api.us-east-1.amazonaws.com
lambda_function_name = WebApiPolizas-dev
You can test your deployment accessing the API URL.

⚙️ Future Improvements
Add CI/CD pipeline with GitHub Actions.

Store Terraform tfstate in AWS S3 with state locking via DynamoDB.

Implement API Gateway Authorizers (JWT / IAM Authentication).

Auto-scaling for Lambda concurrency based on traffic.

👨‍💻 Author
Henderson J. Castañeda
Cloud & Software Engineer 🚀
GitHub Profile | LinkedIn Profile

🏁 Final Notes
This project was built as part of professional infrastructure training and serverless API deployment practice.

Fully serverless, scalable, and ready for real-world applications!

🚀 Happy Deployment! 🚀

