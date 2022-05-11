resource "aws_ecs_cluster" "test" {
  name = "${var.env_name}-ecs-cluster"
  capacity_providers = [ "FARGATE" ]
  

  setting {
      name = "containerInsights"
      value = "enabled"
  }

  tags = local.common_tags

}
