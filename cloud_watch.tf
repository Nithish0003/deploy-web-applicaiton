# CloudWatch Alarms for High CPU Usage
resource "aws_cloudwatch_metric_alarm" "high_cpu_alarm" {
  for_each            = { for data in var.cpu_alarm : data.name => data }
  alarm_name          = each.value.name
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "Alarm when CPU utilization exceeds 80%"
  dimensions = {
    InstanceId = aws_instance.instance[each.value.instance_id].id
  }
  alarm_actions = [ aws_sns_topic.topic[each.value.topic].arn ]
}
# CloudWatch Alarms for High Memory Usage
resource "aws_cloudwatch_metric_alarm" "high_memory_alarm" {
  for_each            = { for data in var.memory_alarm : data.name => data }
  alarm_name          = each.value.name
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "mem_used_percent"
  namespace           = "CWAgent"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "Alarm when memory utilization exceeds 80%"
  dimensions = {
    InstanceId = aws_instance.instance[each.value.instance_id].id
  }
  alarm_actions = [ aws_sns_topic.topic[each.value.topic].arn ]
}
# CloudWatch Alarms for Load Balancer
resource "aws_cloudwatch_metric_alarm" "high_latency_alarm" {
  alarm_name          = "high-latency-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "Latency"
  namespace           = "AWS/ELB"
  period              = "300"
  statistic           = "Average"
  threshold           = "1" # Threshold value in seconds
  alarm_description   = "Alarm when latency exceeds 1 second"
  dimensions = {
    LoadBalancerName = aws_lb.elb_1.name
  }
  count = 2
  alarm_actions = [ aws_sns_topic.topic[count.index+4].arn ]
}

resource "aws_sns_topic" "topic" {
  count = 6
  name     = "topic-${count.index+1}"
}
resource "aws_sns_topic_subscription" "notify" {
  count = 6
  topic_arn = aws_sns_topic.topic[count.index].arn
  protocol  = "email"
  endpoint  = var.notification_email
}
