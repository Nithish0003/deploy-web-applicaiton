resource "aws_subnet" "subnet" {
  for_each                = { for data in var.vpc1_subnet : data.name => data }
  vpc_id                  = aws_vpc.vpc_1.id
  cidr_block              = each.value.cidr
  availability_zone       = "ap-south-1${each.value.az}"
  map_public_ip_on_launch = each.value.public_ip
  tags = {
    Name = each.value.name
  }
}
