# Remote state backend — follow these steps to enable:
#
# 1. Run `terraform init` and `terraform apply` WITHOUT this backend block to
#    create the S3 bucket and DynamoDB table for state storage.
#
# 2. Fill in the sensitive values (bucket, region) in backend.hcl
#    (that file is gitignored and never committed).
#
# 3. Uncomment the terraform block below, then run:
#      terraform init -backend-config=backend.hcl -migrate-state
#    Terraform will copy local state into the S3 backend automatically.

terraform {
  backend "s3" {
    key          = "portfolio/production/terraform.tfstate"
    encrypt      = true
    use_lockfile = true
  }
}
