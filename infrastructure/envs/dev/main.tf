module "s3" {
  source       = "../../modules/s3"
  project_name = "financial-txn"
  environment  = "dev"
}

module "kinesis" {
  source         = "../../modules/kinesis"
  project_name   = "financial-txn"
  environment    = "dev"
  raw_bucket_arn = module.s3.raw_bucket_arn
}