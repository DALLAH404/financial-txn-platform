module "s3" {
  source       = "../../modules/s3"
  project_name = "financial-txn"
  environment  = "dev"
}

module "kafka" {
  source         = "../../modules/kafka"
  project_name   = "financial-txn"
  environment    = "dev"
  my_ip_cidr     = "128.77.96.165/32"
  ssh_public_key = file("~/.ssh/kafka-portfolio.pub")
}