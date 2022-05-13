resource "aws_iam_role" "test-execution" {
  name = "${var.env_name}-${var.app_name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = local.common_tags

}

resource "aws_iam_role_policy_attachment" "test-execution" {
  role       = aws_iam_role.test-execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_cloudwatch_log_group" "test" {
  name              = "/ecs/${var.env_name}-${var.app_name}"
  retention_in_days = var.cloudwatch_log_retention

  tags = local.common_tags
}


resource "aws_ecs_task_definition" "test" {
  family                   = "${var.env_name}-${var.app_name}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.test-execution.arn
  container_definitions    = data.template_file.test.rendered

  tags = local.common_tags
}

resource "aws_ecs_service" "test" {
  name                               = "${var.env_name}-${var.app_name}"
  cluster                            = aws_ecs_cluster.test.arn 
  task_definition                    = aws_ecs_task_definition.test.arn
  desired_count                      = var.service_desired_count
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"

  network_configuration {
    subnets          = data.aws_subnet_ids.test-public.ids
    assign_public_ip = true
    security_groups  = [aws_security_group.service_ecs.id]
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.test.arn
    container_name   = "${var.env_name}-${var.app_name}"
    container_port   = "80"
  }

}

resource "aws_security_group" "service_ecs" {
  name   = "${var.env_name}-service_ecs"
  vpc_id = data.aws_vpc.dev-vpc.id

  ingress {
    protocol  = "-1"
    from_port = 0
    to_port   = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = local.common_tags
}

