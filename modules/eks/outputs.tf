output "eks_cluster_role_arn" {
  value = aws_iam_role.eks_cluster.arn
}

data "aws_eks_cluster_auth" "this" {
  name = aws_eks_cluster.this.name
}

output "eks_node_group_role_arn" {
  value = aws_iam_role.eks_node_group.arn
}
