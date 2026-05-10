locals {
  vpc_open = var.environment == "dev" ? true : false
  account_id = data.aws_caller_identity.current.account_id
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

# Create the security group without any rules
resource "aws_security_group" "database" {
  name_prefix = "postgres-sg-${var.environment}"
  description = "Security group for postgres"
  vpc_id      = local.vpc_open ? module.vpc_open[0].vpc_id : module.vpc_closed[0].vpc_id

  tags = merge(var.common_tags, var.specific_tags)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "db_from_web" {
  count             = local.vpc_open ? 1 : 0
  security_group_id = aws_security_group.database.id
  description       = "Postgres from internet"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "db_from_bastion" {
  security_group_id            = aws_security_group.database.id
  description                  = "Postgres from bastion"
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
  referenced_security_group_id = module.ec2_instance.security_group_id
}

resource "aws_db_subnet_group" "postgres_subnet_group" {
  name       = "postgres-subnet-group"
  subnet_ids = local.vpc_open ? module.vpc_open[0].public_subnets : module.vpc_closed[0].private_subnets

  tags = merge(var.common_tags, var.specific_tags)
}

module "db" {
  source     = "terraform-aws-modules/rds/aws"
  version    = "7.2.0"
  identifier = "postgres${var.environment}"

  # All available versions: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_PostgreSQL.html#PostgreSQL.Concepts
  engine                   = "postgres"
  engine_version           = "17"
  engine_lifecycle_support = "open-source-rds-extended-support-disabled"
  family                   = "postgres17" # DB parameter group
  major_engine_version     = "17"         # DB option group
  instance_class           = "db.t3.micro"

  allocated_storage = 10

  # NOTE: Do NOT use 'user' as the value for 'username' as it throws:
  # "Error creating DB Instance: InvalidParameterValue: MasterUsername
  # user cannot be used as it is a reserved word used by the engine"
  db_name  = "postgres${var.environment}"
  username = "dbadmin"
  port     = 5432

  # Setting manage_master_user_password_rotation to false after it
  # has previously been set to true disables automatic rotation
  # however using an initial value of false (default) does not disable
  # automatic rotation and rotation will be handled by RDS.
  # manage_master_user_password_rotation allows users to configure
  # a non-default schedule and is not meant to disable rotation
  # when initially creating / enabling the password management feature
  manage_master_user_password_rotation              = true
  master_user_password_rotate_immediately           = false
  master_user_password_rotation_schedule_expression = "rate(2 days)"

  multi_az               = true
  create_db_subnet_group = false
  db_subnet_group_name   = aws_db_subnet_group.postgres_subnet_group.id
  vpc_security_group_ids = [aws_security_group.database.id]

  maintenance_window              = "Mon:00:00-Mon:03:00"
  backup_window                   = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  create_cloudwatch_log_group     = true

  backup_retention_period = 1
  skip_final_snapshot     = local.vpc_open
  deletion_protection     = !local.vpc_open

  performance_insights_enabled = false
  create_monitoring_role       = false

  parameters = [
    {
      name  = "autovacuum"
      value = 1
    },
    {
      name  = "client_encoding"
      value = "utf8"
    }
  ]

  tags = merge(var.common_tags, var.specific_tags)
  db_option_group_tags = {
    "Sensitive" = "low"
  }
  db_parameter_group_tags = {
    "Sensitive" = "low"
  }
  cloudwatch_log_group_tags = {
    "Sensitive" = "high"
  }
}

# KMS key for RDS encryption
resource "aws_kms_key" "rds" {
  description             = "KMS key for RDS database encryption"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  tags = merge(var.common_tags, var.specific_tags)
}

resource "aws_kms_alias" "rds" {
  name          = "alias/scout-badges-rds"
  target_key_id = aws_kms_key.rds.key_id
}