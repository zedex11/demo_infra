resource "aws_security_group" "test-alb" {
  name   = "${var.env_name}-${var.app_name}"
  vpc_id = data.aws_vpc.dev-vpc.id

  ingress {
    protocol  = "tcp"
    from_port = 80
    to_port   = 80
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


resource "aws_alb" "test-alb" {
  name                       = "${var.env_name}-${var.app_name}"
  internal                   = false
  load_balancer_type         = "application"
  enable_deletion_protection = false
  idle_timeout               = 60
  security_groups            = [aws_security_group.test-alb.id]
  subnets                    = data.aws_subnet_ids.test-public.ids

  tags = local.common_tags
}


output "lb_dns_name" {
  value = aws_alb.test-alb.dns_name
}

resource "aws_alb_target_group" "test" {
  name                          = "${var.env_name}-${var.app_name}"
  port                          = 80
  protocol                      = "HTTP"
  vpc_id                        = data.aws_vpc.dev-vpc.id
  target_type                   = "ip"
  deregistration_delay          = 300
  load_balancing_algorithm_type = "round_robin"

  # health_check {
  #   healthy_threshold   = "5"
  #   interval            = "30"
  #   protocol            = "HTTP"
  #   matcher             = "200"
  #   timeout             = "5"
  #   path                = "/ui"
  #   unhealthy_threshold = "2"
  # }

  tags = local.common_tags
}


# Redirect to https listener
resource "aws_alb_listener" "test-http" {
  load_balancer_arn = aws_alb.test-alb.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.test.arn
  }
}

