variable "vpc1_subnet" {
  type = list(object({
  name = string, cidr = string, az = string, public_ip = bool }))
  default = [
  { "name" = "subnet-1", "cidr" = "192.168.10.0/24", "az" = "a", "public_ip" = true },
  { "name" = "subnet-2", "cidr" = "192.168.11.0/24", "az" = "b", "public_ip" = false }]
}
variable "public_key_path" {
  type        = string
  description = "Path to the public key file"
  sensitive = true
}
variable "instance" {
  type = list(object({
  name = string, subnet = string, az = string, public_ip = bool }))
  default = [
    { "name" = "instance-1", "subnet" = "subnet-1", "az" = "a", "public_ip" = true },
  { "name" = "instance-2", "subnet" = "subnet-2", "az" = "b", "public_ip" = false }]
}
variable "lb_target" {
  type = list(object({ instance = string }))
  default = [
  { "instance" = "instance-1" }, { "instance" = "instance-2" }]
}
variable "cpu_alarm" {
  type = list(object({ name = string, instance_id = string, topic = string }))
  default = [
    { "name" = "instance-1-high-cpu-alarm", "instance_id" = "instance-1", "topic" = "1" },
  { "name" = "instance-2-high-cpu-alarm", "instance_id" = "instance-2", "topic" = "2" }]
}
variable "memory_alarm" {
  type = list(object({ name = string, instance_id = string, topic = string }))
  default = [
    { "name" = "instance-1-high-memory-alarm", "instance_id" = "instance-1", "topic" = "3" },
  { "name" = "instance-2-high-memory-alarm", "instance_id" = "instance-2", "topic" = "4" }]
}
variable "notification_email" {
  type        = string
  description = "your-email@example.com"
}
variable "db_pass" {
  type        = string
  description = "your_db_password"
  sensitive = true
}
variable "access_key_id" {
  type = string
  description = "your_access_key_id"
  sensitive = true
}
variable "secret_key_id" {
  type = string
  description = "your_secret_access_key"
  sensitive = true
}
# variable "github_repo" {
#   type        = string
#   description = "your_github_repo"
# }
# variable "github_token" {
#   type        = string
#   description = "your_github_token"
#   sensitive = true  
# }