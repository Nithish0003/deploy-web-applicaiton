provider "aws" {
  region = "ap-south-1"
}
#creating vpc
resource "aws_vpc" "vpc_1" {
  cidr_block = "192.168.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name="vpc-1"
  }
}