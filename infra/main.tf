module "test_s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "nt-2026-test-bucket"

  # Allow deletion of non-empty bucket
  force_destroy = true
}