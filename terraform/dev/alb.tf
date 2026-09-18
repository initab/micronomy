# Application Load Balancer with ECS Backend Support
# This ALB is designed to be auto-scalable with Fargate ECS cluster
# Configuration supports:
# - Multiple ECS services (add more as needed)
# - Auto-scaling readiness when ECS scales up/down
# - HTTPS termination with ACM certificate
# - HTTP to HTTPS redirect

resource "aws_lb" "micronomy_alb" {
  name               = "${local.app-name}-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.public[*].id
  security_groups    = [aws_security_group.alb_ingress.id]
}


resource "aws_lb_target_group" "micronomy_http" {
  name                 = "${local.app-name}-http-target"
  port                 = 8080
  protocol             = "HTTP"
  vpc_id               = aws_vpc.micronomy-vpc.id
  target_type          = "ip"
  deregistration_delay = 60

  tags = {
    Name = "${local.app-name}-http-target"
  }
}


resource "aws_lb_listener" "micronomy_https_443" {
  load_balancer_arn = aws_lb.micronomy_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.micronomy_certificate.arn

  # Default action forward to HTTP target on ECS (port 8080)
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.micronomy_http.arn
  }
}
