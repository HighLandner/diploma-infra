terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.46.0"
    }
  }
  backend "s3" {
    bucket = "diploma-bucket-keeper"
    key    = "tfstate/"
    region = "eu-central-1"
  }
}
