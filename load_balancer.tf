# creating load balancer
resource "aws_lb" "elb_1" {
  name               = "elb-1"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_1.id]
  subnets            = [aws_subnet.subnet["subnet-1"].id, aws_subnet.subnet["subnet-2"].id]
}
# creating target group
resource "aws_lb_target_group" "tg_1" {
  name     = "tg-1"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc_1.id
}
# attaching instances
resource "aws_lb_target_group_attachment" "attachment" {
  for_each         = { for data in var.lb_target : data.instance => data }
  target_group_arn = aws_lb_target_group.tg_1.arn
  target_id        = aws_instance.instance[each.value.instance].id
  port             = 80
}
# attaching alb listener
resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.elb_1.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_1.arn
  }
}
