data "template_file" "test" {

  template = file("templates/test.json")
  vars = {
    region         = var.region
    log_group      = aws_cloudwatch_log_group.test.name
    name           = "${var.env_name}-${var.app_name}"
    image          = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.env_name}-${var.app_name}:${var.image_version}"
    container_port = "80"
  }
}
data "aws_caller_identity" "current" {}

data "aws_vpc" "dev-vpc" {
  tags = {
    Name       = "dev-vpc"
  }
}

data "aws_subnet_ids" "test-public" {
  vpc_id = data.aws_vpc.dev-vpc.id

  tags = {
    Name = "dev-vpc-public*"
  }
}
