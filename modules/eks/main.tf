# provider "kubernetes" {
#   host                   = data.aws_eks_cluster.this.endpoint
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
#   token                  = data.aws_eks_cluster_auth.this.token
# }
#
# provider "helm" {
#   kubernetes = {
#     config_path = "~/.kube/config"
#   }
# }

resource "aws_eks_cluster" "this" {
    name     = var.cluster_name
    role_arn = aws_iam_role.eks_cluster.arn

    vpc_config {
        subnet_ids = var.subnet_ids
    }

    depends_on = [aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy]
}

resource "aws_iam_role" "eks_cluster" {
    name = "${var.cluster_name}-eks-cluster-role"
    assume_role_policy = data.aws_iam_policy_document.eks_cluster_assume_role.json
}

data "aws_iam_policy_document" "eks_cluster_assume_role" {
    statement {
        actions = ["sts:AssumeRole"]
        principals {
            type        = "Service"
            identifiers = ["eks.amazonaws.com"]
        }
    }
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSBlockStoragePolicy" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSBlockStoragePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSComputePolicy" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSComputePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSLoadBalancingPolicy" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSLoadBalancingPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSNetworkingPolicy" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSNetworkingPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSVPCResourceController" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

resource "aws_iam_role" "eks_node_group" {
    name = "${var.cluster_name}-eks-node-group-role"
    assume_role_policy = data.aws_iam_policy_document.eks_node_group_assume_role.json
}

data "aws_iam_policy_document" "eks_node_group_assume_role" {
    statement {
        actions = ["sts:AssumeRole"]
        principals {
            type        = "Service"
            identifiers = ["ec2.amazonaws.com"]
        }
    }
}

resource "aws_iam_role_policy_attachment" "eks_node_AmazonEKS_CNI_Policy" {
  role       = aws_iam_role.eks_node_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "eks_node_AmazonEKSWorkerNodePolicy" {
    role       = aws_iam_role.eks_node_group.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_node_AmazonEC2ContainerRegistryReadOnly" {
    role       = aws_iam_role.eks_node_group.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_eks_node_group" "this" {
    cluster_name    = aws_eks_cluster.this.name
    node_group_name = "${var.cluster_name}-node-group"
    node_role_arn   = aws_iam_role.eks_node_group.arn
    subnet_ids      = var.subnet_ids

    scaling_config {
        desired_size = var.desired_size
        max_size     = var.max_size
        min_size     = var.min_size
    }

    depends_on = [
        aws_iam_role_policy_attachment.eks_node_AmazonEKSWorkerNodePolicy,
        aws_iam_role_policy_attachment.eks_node_AmazonEC2ContainerRegistryReadOnly,
        aws_iam_role_policy_attachment.eks_node_AmazonEKS_CNI_Policy
    ]
}

data "aws_eks_cluster" "this" {
    name = aws_eks_cluster.this.name
}

data "tls_certificate" "oidc_thumbprint" {
    url = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
    url             = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
    client_id_list  = ["sts.amazonaws.com"]
    thumbprint_list = [data.tls_certificate.oidc_thumbprint.certificates[0].sha1_fingerprint]
}

# resource "aws_iam_policy" "cluster_autoscaler" {
#     name        = "${var.cluster_name}-cluster-autoscaler-policy"
#     description = "EKS Cluster Autoscaler policy"
#     policy      = file("${path.module}/cluster-autoscaler-policy.json")
# }
#
# resource "aws_iam_role" "cluster_autoscaler" {
#     name = "${var.cluster_name}-cluster-autoscaler-role"
#     assume_role_policy = data.aws_iam_policy_document.cluster_autoscaler_assume_role.json
# }
#
# data "aws_iam_policy_document" "cluster_autoscaler_assume_role" {
#     statement {
#         actions = ["sts:AssumeRoleWithWebIdentity"]
#         principals {
#             type        = "Federated"
#             identifiers = [aws_iam_openid_connect_provider.eks.arn]
#         }
#         condition {
#             test     = "StringEquals"
#             variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
#             values   = ["system:serviceaccount:kube-system:cluster-autoscaler"]
#         }
#     }
# }
#
# resource "aws_iam_role_policy_attachment" "cluster_autoscaler" {
#     role       = aws_iam_role.cluster_autoscaler.name
#     policy_arn = aws_iam_policy.cluster_autoscaler.arn
# }
#
# resource "kubernetes_service_account" "cluster_autoscaler" {
#     metadata {
#         name      = "cluster-autoscaler"
#         namespace = "kube-system"
#         annotations = {
#             "eks.amazonaws.com/role-arn" = aws_iam_role.cluster_autoscaler.arn
#         }
#     }
#     depends_on = [
#     aws_eks_node_group.this
#     ]
# }


# resource "helm_release" "cluster_autoscaler" {
#   name       = "cluster-autoscaler"
#   repository = "https://kubernetes.github.io/autoscaler"
#   chart      = "cluster-autoscaler"
#   namespace  = "kube-system"
#
#   version    = "9.29.0"   # Optional: pin a stable version
#   wait       = true
#   atomic     = true
#   timeout    = 600
#
#   set = [
#     {
#       name  = "autoDiscovery.clusterName"
#       value = var.cluster_name
#     },
#     {
#       name  = "awsRegion"
#       value = var.region
#     },
#     {
#       name  = "rbac.create"
#       value = "false"
#     },
#     {
#       name  = "serviceAccount.create"
#       value = "false"
#     },
#     {
#       name  = "serviceAccount.name"
#       value = kubernetes_service_account.cluster_autoscaler.metadata[0].name
#     }
#   ]
#
#   depends_on = [
#     aws_eks_cluster.this,
#     aws_eks_node_group.this,
#     kubernetes_service_account.cluster_autoscaler
#   ]
# }
