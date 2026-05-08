locals {
  vpc_open = var.environment == "dev" ? true : false
}

module "bastion_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "5.13.0"

  bucket = "nt-bastion-bucket-${var.environment}"

  # Allow deletion of non-empty bucket
  force_destroy = true

  tags = merge(var.common_tags, var.specific_tags)
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.4.0"

  name = "bastion"

  instance_type               = "t3.micro"
  subnet_id                   = local.vpc_open ? module.vpc_open[0].public_subnets[0] : module.vpc_closed[0].private_subnets[0]
  associate_public_ip_address = local.vpc_open

  tags = merge(var.common_tags, var.specific_tags)
}

