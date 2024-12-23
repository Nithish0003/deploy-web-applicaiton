resource "aws_route_table" "rt_1" {
  vpc_id = aws_vpc.vpc_1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_1.id
  }
  tags = {
    Name = "rt-1"
  }
}
resource "aws_route_table_association" "association_1" {
  subnet_id      = aws_subnet.subnet["subnet-1"].id
  route_table_id = aws_route_table.rt_1.id
}
resource "aws_route_table" "rt_2" {
  vpc_id = aws_vpc.vpc_1.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_1.id
  }
  tags = {
    Name = "rt-2"
  }
}
resource "aws_route_table_association" "association_2" {
  subnet_id      = aws_subnet.subnet["subnet-2"].id
  route_table_id = aws_route_table.rt_2.id
}
