# creating subnet group
resource "aws_db_subnet_group" "subnet_group" {
  name = "subnet-group"
  subnet_ids = [ aws_subnet.subnet["subnet-1"].id,aws_subnet.subnet["subnet-2"].id ]
}
# retrieving db-pass 
# retrieves the secret meta data
# data "aws_secretsmanager_secret" "db_pass" {
#   name="db-pass"
# }
# # retrieves the actual secret value
# data "aws_secretsmanager_secret_version" "db_pass" {
#   secret_id = data.aws_secretsmanager_secret.db_pass.id
# }
# creating RDS
resource "aws_db_instance" "my_db" {
  allocated_storage = 8
  db_subnet_group_name = aws_db_subnet_group.subnet_group.id
  db_name = "marks_db"
  engine = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro"
  multi_az = false
  username = "admin"
  # password = aws_secretsmanager_secret_version.db_pass.secret_string
  password = var.db_pass
  skip_final_snapshot = true
  monitoring_role_arn = aws_iam_role.rds_role.arn
  monitoring_interval = 60
  storage_type = "gp2"
  vpc_security_group_ids = [ aws_security_group.database_sg.id ]
  tags = {
    Name="my-db"
  }
}