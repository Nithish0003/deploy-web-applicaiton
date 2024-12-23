resource "aws_autoscaling_group" "asg" {
  name = "asg-1"
  min_size = 1
  max_size = 1
  desired_capacity = 1
  target_group_arns = [ aws_lb_target_group.tg_1.arn ]
  vpc_zone_identifier = [ aws_subnet.subnet["subnet-1"].id,aws_subnet.subnet["subnet-2"].id ]
  health_check_type = "EC2"
  health_check_grace_period = 300
  launch_template {
    id = aws_launch_template.template.id
  }
}