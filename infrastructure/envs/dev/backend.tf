terraform {
  backend "s3" {
    bucket  = "fintxn-dev-terraform-state-78738"
    key     = "dev/terraform.tfstate"
    region  = "eu-west-1"
    encrypt = true
    profile = "terraform-portfolio"
  }
}