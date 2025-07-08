variable "region" {
    description = "AWS region to deploy EKS cluster"
    type        = string
}

variable "cluster_name" {
    description = "Name of the EKS cluster"
    type        = string
}

variable "cluster_version" {
    description = "Kubernetes version for the EKS cluster"
    type        = string
}

variable "subnet_ids" {
    description = "List of subnet IDs for the EKS cluster"
    type        = list(string)
}

variable "desired_size" {
    description = "Desired number of worker nodes"
    type        = number
}

variable "max_size" {
    description = "Maximum number of worker nodes"
    type        = number
}

variable "min_size" {
    description = "Minimum number of worker nodes"
    type        = number
}

variable "node_instance_type" {
    description = "EC2 instance type for worker nodes"
    type        = string
}

variable "enable_autoscaler" {
    description = "Enable cluster autoscaler"
    type        = bool
}