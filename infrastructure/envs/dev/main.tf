data "aws_caller_identity" "current" {}


module "s3" {
  source       = "../../modules/s3"
  project_name = "financial-txn"
  environment  = "dev"
}