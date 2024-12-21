resource "aws_launch_template" "template" {
  name = "template-1"
  image_id = data.aws_ami.ami.id
  instance_type = "t2.micro"
  key_name = "mumbai"
  user_data = filebase64("data.sh")
  network_interfaces {
    associate_public_ip_address = true
    security_groups = [ aws_security_group.sg_1.id ]
  }
}