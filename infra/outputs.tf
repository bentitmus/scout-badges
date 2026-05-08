output "ec2_public_dns_name" {
  description = "Public dns name for ec2"
  value       = module.ec2_instance.public_dns
}

output "ec2_public_ip" {
  description = "Public ip for ec2"
  value       = module.ec2_instance.public_ip
}