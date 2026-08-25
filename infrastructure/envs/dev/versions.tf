terraform {

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    aws = {
      version = "= 5.32.0"
      source  = "hashicorp/aws"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.6.2"
    }
  }
}