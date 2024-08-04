# Create AWS EKS Node Group - PUBLIC
resource "aws_eks_node_group" "eks_node_group_pubic" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.cluster_name}-node-group-public"
  node_role_arn   = aws_iam_role.eks_node_group_role.arn
  subnet_ids      = var.node_group_vpc_public_subnet_ids

  scaling_config {
    desired_size = var.public_node_group_scaling_config.desired_size
    min_size     = var.public_node_group_scaling_config.min_size
    max_size     = var.public_node_group_scaling_config.max_size
  }

  ami_type       = var.node_group_ami_type
  capacity_type  = var.node_group_capacity_type
  disk_size      = var.node_group_disk_size
  instance_types = var.node_group_instance_types

  remote_access {
    ec2_ssh_key = aws_key_pair.node_group_key.key_name
  }

  # The maximum number of unavailable instances when the node group is being updated/upgraded.
  # it means that when node group is being update or update. only `1` instance will be updated at a time
  update_config {
    max_unavailable = 1
    #max_unavailable_percentage = 50    # ANY ONE TO USE
  }

  # Kubernetes config
  version = var.cluster_version

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-AmazonEC2ContainerRegistryReadOnly,
  ]

  tags = merge({
    NodeGroupType = "public"
  }, var.tags)
}

# Create AWS EKS Node Group - PRIVATE
resource "aws_eks_node_group" "eks_node_group_private" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.cluster_name}-node-group-private"
  node_role_arn   = aws_iam_role.eks_node_group_role.arn
  subnet_ids      = var.node_group_vpc_private_subnet_ids

  scaling_config {
    desired_size = var.private_node_group_scaling_config.desired_size
    min_size     = var.private_node_group_scaling_config.min_size
    max_size     = var.private_node_group_scaling_config.max_size
  }

  ami_type       = var.node_group_ami_type
  capacity_type  = var.node_group_capacity_type
  disk_size      = var.node_group_disk_size
  instance_types = var.node_group_instance_types

  remote_access {
    ec2_ssh_key = aws_key_pair.node_group_key.key_name
  }

  # The maximum number of unavailable instances when the node group is being updated/upgraded.
  # it means that when node group is being update or update. only `1` instance will be updated at a time
  update_config {
    max_unavailable = 1
    #max_unavailable_percentage = 50    # ANY ONE TO USE
  }

  # Kubernetes config
  version = var.cluster_version

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-AmazonEC2ContainerRegistryReadOnly,
  ]

  tags = merge({
    NodeGroupType = "private"
  }, var.tags)
}
