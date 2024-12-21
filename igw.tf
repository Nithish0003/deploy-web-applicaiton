resource "aws_internet_gateway" "igw_1" {
  vpc_id = aws_vpc.vpc_1.id
  tags = {
    Name="igw-1"
  }
}