module "eks" {

  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  enable_cluster_creator_admin_permissions = true # # Automatically grants admin access to the IAM identity (user/role) that runs

  name                   = local.name
  endpoint_public_access = true
  kubernetes_version     = "1.34"

  addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent    = true
      before_compute = true
    }
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.public_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  # EKS Managed Node Group configuration

  eks_managed_node_groups = {

    easy-shop-ng = {
      min_size     = 2
      max_size     = 3
      desired_size = 2

      instance_types = ["m7i-flex.large"]
      capacity_type  = "SPOT"

      disk_size                  = 20
      volume_type                = "gp3"
      use_custom_launch_template = false # Important to apply disk size!

      # Additional IAM policies for the node group instances
      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy     = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
        AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      }

      tags = {
        Name        = "easy-shop-ng"
        Environment = "dev"
        ExtraTag    = "e-commerce-app"
      }
    }
  }

  node_security_group_additional_rules = {
    ingress_nodeport = {
      description = "Allow NodePort range"
      protocol    = "tcp"
      from_port   = 30000
      to_port     = 32767
      type        = "ingress"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  tags = local.tags


}

data "aws_instances" "eks_nodes" {
  instance_tags = {
    "eks:cluster-name" = module.eks.cluster_name
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }

  depends_on = [module.eks]
}