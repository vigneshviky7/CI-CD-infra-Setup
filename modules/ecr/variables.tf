variable "repository_name" {
    description = "The name of the ECR repository."
    type        = string
}

variable "scan_on_push" {
    description = "Indicates whether images are scanned after being pushed to the repository."
    type        = bool
}

variable "repository_lifecycle_policy" {
    description = "The JSON lifecycle policy for the ECR repository."
    type        = string
}

variable "tags" {
    description = "A map of tags to assign to the resource."
    type        = map(string)
}

variable "repository_read_write_access_arns" {
    description = "A list of IAM ARNs to grant read/write access to the ECR repository."
    type        = list(string)
}