data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
  region = "eu-west-2"
}

module "vpc_open" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.1"
  count = local.vpc_open ? 1 : 0

  name = "vpc-scout-badges-${var.environment}"

  cidr = "10.0.0.0/16"
  azs  = slice(data.aws_availability_zones.available.names, 0, 2)
  

  #private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = [var.public_subnet1, var.public_subnet2]

  #enable_nat_gateway   = true
  #single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support = true

  #public_subnet_tags = {
  #  "kubernetes.io/role/elb" = 1
  #}

  #private_subnet_tags = {
  #  "kubernetes.io/role/internal-elb" = 1
  #}
}

module "vpc_closed" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.1"
  count = local.vpc_open ? 0 : 1

  name = "vpc-scout-badges-${var.environment}"

  cidr = "10.0.0.0/16"
  azs  = slice(data.aws_availability_zones.available.names, 0, 2)
  

  private_subnets = [var.private_subnet1, var.private_subnet2]
  public_subnets  = [var.public_subnet1, var.public_subnet2]

  #enable_nat_gateway   = true
  #single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support = true

  #public_subnet_tags = {
  #  "kubernetes.io/role/elb" = 1
  #}

  #private_subnet_tags = {
  #  "kubernetes.io/role/internal-elb" = 1
  #}
}