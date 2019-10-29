variable "aws_region" {}
#variable "aws_profile" {}
variable "aws_availability_zone" {
	default = ["eu-west-1a", "eu-west-1c"]
}
variable "vpc_cidr" {}
variable "cidrs" {
	type=map
}
variable engine_version {}
variable db_instance_class {}
variable dbname {}
variable dbpass {}

