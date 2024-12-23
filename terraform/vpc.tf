#creating vpc
resource "aws_vpc" "vpc_1" {
  cidr_block       = "192.168.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-1"
  }
}
