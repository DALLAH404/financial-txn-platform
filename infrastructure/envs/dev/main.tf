module "s3" {
  source       = "../../modules/s3"
  project_name = "financial-txn"
  environment  = "dev"
}

module "kafka" {
  source         = "../../modules/kafka"
  project_name   = "financial-txn"
  environment    = "dev"
  my_ip_cidr     = "128.77.96.164/32"
  ssh_public_key = file("~/.ssh/kafka-portfolio.pub")
  raw_bucket_arn = module.s3.raw_bucket_arn
}