provider "aws" {
  region  = var.region
  # profile = var.profile
}

terraform {
  backend "s3" {}
}

locals {
  common_tags = {
    env        = var.env_name
    app        = var.app
    due_date   = var.due_date
    created_by = "terraform"
  }
}
