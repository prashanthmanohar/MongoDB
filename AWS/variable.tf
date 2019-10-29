variable "aws_region" {}
#variable "aws_profile" {}
variable "aws_availability_zone" {
  default = ["us-east-1a", "us-east-1c"]
}
variable "vpc_cidr" {}
variable "cidrs" {
  type = map
}
variable "engine_version" {}
variable "db_instance_class" {}
variable "dbname" {}
variable "dbpass" {}
data "aws_ami" "ubuntu" {
	most_recent = true
	owners = ["099720109477"]
}

