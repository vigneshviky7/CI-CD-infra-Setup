vpc_name = "dev-vpc"
vpc_cidr = "10.0.0.0/16"
public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
region = "ap-south-1"
availability_zones = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
cluster_name = "dev-cluster"
cluster_version = "1.21"
desired_size = 2
max_size = 4
min_size = 1
node_instance_type = "t3.medium"
enable_autoscaler = true
ecr_repo_name = "dev-ecr-repo"
ecr_scan_on_push = true
tags = {
  Environment = "dev"
}

repository_lifecycle_policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Keep last 30 images",
      "selection": {
        "tagStatus": "tagged",
        "tagPrefixList": ["v"],
        "countType": "imageCountMoreThan",
        "countNumber": 30
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
