output "vpc_id" {
  value = aws_vpc.vpc_1.id
}

output "subnet_ids" {
  value = aws_subnet.subnet[*].id
}

output "db_instance_endpoint" {
  value = aws_db_instance.my_db.endpoint
}

output "elb_dns_name" {
  value = aws_lb.elb_1.dns_name
}
