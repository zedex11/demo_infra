resource "aws_ecs_cluster" "test" {
  name = "${var.env_name}-${var.app_name}" 
  
  setting {
      name = "containerInsights"
      value = "enabled"
  }

  tags = local.common_tags

}

resource "aws_ecs_cluster_capacity_providers" "test" {
  cluster_name = aws_ecs_cluster.test.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}
