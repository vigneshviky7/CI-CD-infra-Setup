resource "aws_ecr_repository" "this" {
    name = var.repository_name

    image_scanning_configuration {
        scan_on_push = var.scan_on_push
    }

    tags = var.tags
}

resource "aws_ecr_repository_policy" "read_write_access" {
    count      = length(var.repository_read_write_access_arns)
    repository = aws_ecr_repository.this.name
    policy     = data.aws_iam_policy_document.ecr_policy.json
}

data "aws_iam_policy_document" "ecr_policy" {
    statement {
        actions   = ["ecr:*"]
        principals {
            type        = "AWS"
            identifiers = var.repository_read_write_access_arns
        }
    }
}