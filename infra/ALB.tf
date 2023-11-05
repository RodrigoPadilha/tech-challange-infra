resource "aws_lb" "alb" {
  name               = "ecs-orders-load-balancer"
  internal           = true # Default é false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = module.vpc.private_subnets # module.vpc.public_subnets
}

resource "aws_lb_target_group" "orders-tg" {
  name        = "orders-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_lb_listener" "listener-http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.orders-tg.id
  }
}

output "IP" {
    value = aws_lb.alb.dns_name
}
