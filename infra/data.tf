data "aws_db_instance" "postgres_data" {
  depends_on             = [module.db]
  db_instance_identifier = module.db.db_instance_identifier
}

data "aws_caller_identity" "current" {}