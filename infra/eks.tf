module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "example"
  kubernetes_version = "1.33"

  # Optional
  endpoint_public_access = true
  endpoint_private_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  # enable_cluster_creator_admin_permissions = true

  compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  # TODO: Specify only the Private subnet_ids for vpc_closed
  vpc_id     = local.vpc_open ? module.vpc_open[0].vpc_id : module.vpc_closed[0].vpc_id
  subnet_ids = local.vpc_open ? module.vpc_open.subnet_ids : module.vpc_closed.subnet_ids

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}