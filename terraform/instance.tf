resource "aws_key_pair" "mumbai" {
  key_name   = "mumbai"
  public_key = file(var.public_key_path)
}
resource "aws_instance" "instance" {
  for_each                    = { for data in var.instance : data.name => data }
  ami                         = data.aws_ami.ami.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.subnet[each.value.subnet].id
  key_name                    = "mumbai"
  vpc_security_group_ids      = [aws_security_group.sg_1.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_instance_profile.name
  monitoring                  = true
  availability_zone           = "ap-south-1${each.value.az}"
  associate_public_ip_address = each.value.public_ip
  user_data                   = file("data.sh")
  tags = {
    Name = each.value.name
  }
}
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2_role.name
}
