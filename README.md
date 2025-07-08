📘 Project: AWS EKS Deployment with GitHub Actions, Terraform, and Helm
This project automates the deployment of microservices to AWS EKS using a GitHub Actions CI/CD pipeline, Terraform for infrastructure provisioning, and Helm for Kubernetes application deployment.

🛠️ Technologies Used
Terraform – Infrastructure provisioning (VPC, EKS, ALB, IAM, etc.)

Helm – Kubernetes package manager for app deployment

AWS EKS – Managed Kubernetes cluster

AWS Services:

VPC

S3 (Terraform state)

DynamoDB (state locking)

ALB (service exposure)

Route 53 (DNS management)

ACM (SSL certificates)

CloudFront (CDN)

Secrets Manager (secret injection)

GitHub Actions – CI/CD for infrastructure and app deployments

Trivy – Container image vulnerability scanning

SonarQube – Code quality and static analysis

Prometheus – Metrics collection and monitoring

🔁 CI/CD Workflow Overview
Push to GitHub → Triggers GitHub Actions

Trivy + SonarQube → Image and code security checks

Terraform → Provisions AWS infrastructure with S3/DynamoDB backend

Helm → Deploys microservices to EKS

Secrets Manager → Injects secrets into application pods

ALB → Exposes services externally

CloudFront + Route 53 + ACM → CDN + DNS + HTTPS

🏗️ Infrastructure Deployment with Terraform
✅ Pre-requisites
AWS CLI configured

Terraform installed

S3 bucket and DynamoDB table for backend state

🧪 Terraform Commands

terraform init -backend-config="bucket=<your-s3-bucket>" \
               -backend-config="key=dev/terraform.tfstate" \
               -backend-config="region=<your-region>" \
               -backend-config="dynamodb_table=<your-table>"

terraform plan -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"
🚀 Application Deployment with Helm
✅ Pre-requisites
kubectl configured with your EKS cluster

Helm installed

🧱 Install Services

cd helm/

helm install cart ./cart --namespace robot-shop --create-namespace
helm install payment ./payment --namespace robot-shop
🔁 Upgrade Services

helm upgrade cart ./cart --namespace robot-shop
📊 Prometheus Metrics
Cart Service Metrics
Endpoint: /metrics

Example:

curl http://<ALB-DNS>:8080/api/cart/metrics
Metric: Counter – Number of items added to cart

Payment Service Metrics
Endpoint: /metrics

Example:

curl http://<ALB-DNS>:8080/api/payment/metrics
Metric: Counter – Number of items purchased

🛡️ Security & Code Quality
Trivy (Container Scanning)
Scans Docker images in GitHub Actions before pushing to ECR

SonarQube (Static Code Analysis)
Analyzes code on pull requests

Both are integrated in .github/workflows/deploy.yml.

🔐 Secrets Handling
AWS Secrets Manager stores sensitive values (e.g., DB credentials)

Injected into pods using Secrets Store CSI Driver

📈 Monitoring & Autoscaling
Prometheus – Scrapes metrics from /metrics endpoints

Cluster Autoscaler – Automatically scales worker nodes

Horizontal Pod Autoscaler (optional) – Configurable per service

🌐 Domain, HTTPS, and CDN
Route 53 – Manages DNS records

ACM – TLS/SSL certificate management

CloudFront – Fronts ALB for HTTPS and caching

