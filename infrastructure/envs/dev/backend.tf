terraform {
  backend "s3" {
    bucket  = "financial-txn-dev-terraform-state-e14c"
    key     = "dev/terraform.tfstate"
    region  = "eu-west-1"
    encrypt = true
    profile = "terraform-portfolio"
  }
}