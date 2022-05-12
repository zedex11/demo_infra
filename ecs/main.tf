provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {}
}

locals {
  common_tags = {
    env        = var.env_name
    app        = var.app
    builduser  = var.build_user
    created_by = "terraform"
  }
}
