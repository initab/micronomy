terraform {
  required_version = ">= 1.15.0"

  backend "s3" {
    bucket = "micronomy-terraform-state-dev"
    key    = "dev/terraform.tfstate"
    region = "eu-north-1"
  }
}
