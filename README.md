📘 Project: AWS EKS Deployment with GitHub Actions, Terraform, and Helm
This project automates the deployment of microservices to AWS EKS using GitHub Actions CI/CD pipeline, Terraform for infrastructure provisioning, and Helm for Kubernetes app deployment.

🛠️ Technologies Used
Terraform – For infrastructure provisioning (VPC, EKS, ALB, IAM, etc.)

Helm – Kubernetes package manager to deploy applications

AWS EKS – Managed Kubernetes cluster

AWS Services – VPC, S3, DynamoDB, ALB, Route 53, ACM, CloudFront, Secrets Manager

GitHub Actions – CI/CD workflows for Terraform and application deploy

Trivy & SonarQube – Image scanning and code quality analysis

Prometheus – Metrics scraping

📂 Repository Structure
bash
Copy
Edit
.
├── terraform/
│   ├── modules/
│   ├── main.tf
│   ├── variables.tf
│   └── ...
├── helm/
│   ├── cart/
│   │   └── Chart.yaml, values.yaml, templates/
│   ├── payment/
│   └── ...
├── .github/workflows/
│   ├── terraform.yml
│   └── deploy.yml
├── README.md
🚀 CI/CD Flow
Push to GitHub → Triggers GitHub Actions.

Trivy + SonarQube → Security and code quality checks.

Terraform → Provisions AWS infrastructure with S3/DynamoDB backend.

Helm → Deploys services to EKS.

Secrets Manager → Injects sensitive values.

ALB → Exposes the services.

CloudFront + Route 53 + ACM → CDN + DNS + HTTPS.

🏗️ Infrastructure Deployment (Terraform)
Pre-Requisites
AWS CLI configured

Terraform installed

Backend S3 bucket and DynamoDB table created (or let Terraform do it)

Steps
bash
Copy
Edit
cd terraform/
terraform init -backend-config="bucket=<your-s3-bucket>" \
               -backend-config="key=dev/terraform.tfstate" \
               -backend-config="region=<your-region>" \
               -backend-config="dynamodb_table=<your-table>"

terraform plan -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"
📦 Application Deployment (Helm)
Pre-Requisites
kubectl configured with your EKS cluster

Helm installed

Steps
bash
Copy
Edit
cd helm/
helm repo add my-repo <repo-url> # if using external chart repo
helm install cart ./cart --namespace robot-shop --create-namespace
helm install payment ./payment --namespace robot-shop
To upgrade later:

bash
Copy
Edit
helm upgrade cart ./cart --namespace robot-shop
🔍 Metrics: Prometheus Endpoints
The cart and payment services expose metrics for Prometheus scraping.

Cart Service Metrics
Endpoint: /metrics

Type: Counter – Number of items added to the cart

bash
Copy
Edit
curl http://<ALB-DNS>:8080/api/cart/metrics
Payment Service Metrics
Endpoint: /metrics

Metrics:

Counter – Number of items purchased

Histogram – Total items per cart

Histogram – Total value per cart

bash
Copy
Edit
curl http://<ALB-DNS>:8080/api/payment/metrics
Replace <ALB-DNS> with the DNS name of your Application Load Balancer.

🧪 Trivy & SonarQube Integration
Trivy: Scans Docker images in GitHub Actions before pushing to ECR.

SonarQube: Analyzes code on pull request events.

These tools are integrated in the .github/workflows/deploy.yml pipeline.

🔐 Secrets Handling
Secrets like DB passwords or API keys are stored in AWS Secrets Manager and injected into the app pods via environment variables using secrets-store-csi-driver.

📈 Monitoring & Autoscaling
Prometheus: Scrapes metrics from /metrics endpoints.

Cluster Autoscaler: Scales EKS worker nodes based on demand.

Horizontal Pod Autoscaler (optional): Can be enabled per microservice.

🌐 Domain & SSL
Route 53: Manages DNS records.

ACM: Manages TLS certificates.

CloudFront: Fronts ALB for caching and HTTPS.