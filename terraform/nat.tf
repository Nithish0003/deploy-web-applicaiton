resource "aws_eip" "eip_1" {
  domain = "vpc"
  tags = {
    Name="eip-1"
  }
}
resource "aws_nat_gateway" "nat_1" {
  allocation_id = aws_eip.eip_1.id
  subnet_id = aws_subnet.subnet["subnet-1"].id
  tags = {
    Name="nat-1"
  }
}