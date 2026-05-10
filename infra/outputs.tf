output "ec2_public_dns_name" {
  description = "Public dns name for ec2"
  value       = local.vpc_open ? module.ec2_instance.public_dns : ""
}

output "postgres_instance_address" {
  description = "DNS address for postgres - not printed for prod"
  value       = local.vpc_open ? module.db.db_instance_address : ""
}

output "postgres_instance_endpoint" {
  description = "Instance endpoint for postgres - not printed for prod"
  value       = local.vpc_open ? module.db.db_instance_endpoint : ""
}

output "postgres_secrets_manager_entry" {
  description = "Secrets Manager for postgres - not printed for prod"
  value       = local.vpc_open ? data.aws_db_instance.postgres_data.master_user_secret[0].secret_arn : ""
}