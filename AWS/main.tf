#Creating VPC

resource "aws_vpc" "db_vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    name = "db_vpc"
  }
}

#Creating Route tables

resource "aws_default_route_table" "db_private1_rt" {
  default_route_table_id = "${aws_vpc.db_vpc.default_route_table_id}"
  tags = {
    name = "rt_private1"
  }
}

resource "aws_default_route_table" "db_private2_rt" {
  default_route_table_id = "${aws_vpc.db_vpc.default_route_table_id}"
  tags = {
    name = "rt_private2"
  }
}

#Creating DB Subnet

#data "aws_availability_zones" "available" {
#  state = "available"
#}

resource "aws_subnet" "db_subnet_zone1" {
  vpc_id                  = "${aws_vpc.db_vpc.id}"
  cidr_block              = "${var.cidrs["private1"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${var.aws_availability_zone[0]}"
  #availability_zone = "${data.aws_availability_zone.availabile.names[0]}"
  tags = {
    name = "db_subnet_zone1"
  }
}

resource "aws_subnet" "db_subnet_zone2" {
  vpc_id                  = "${aws_vpc.db_vpc.id}"
  cidr_block              = "${var.cidrs["private2"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${var.aws_availability_zone[1]}"
  #availability_zone = "${data.aws_availability_zone.availabile.names[1]}"
  tags = {
    name = "db_subnet_zone2"
  }
}

#Creating DB subnet groups

resource "aws_db_subnet_group" "db_subnet_group" {
  name = "db_subnet_group"
  subnet_ids = ["${aws_subnet.db_subnet_zone1.id}",
  "${aws_subnet.db_subnet_zone2.id}"]
  tags = {
    name = "db_subnet_group"
  }
}

#Subnet Association

resource "aws_route_table_association" "db_private1_assoc" {
  subnet_id      = "${aws_subnet.db_subnet_zone1.id}"
  route_table_id = "${aws_default_route_table.db_private1_rt.id}"
}

resource "aws_route_table_association" "db_private2_assoc" {
  subnet_id      = "${aws_subnet.db_subnet_zone2.id}"
  route_table_id = "${aws_default_route_table.db_private2_rt.id}"
}

#Creating security groups

resource "aws_security_group" "private_db_sg" {
  name        = "private_sg"
  description = "Used for db instances"
  vpc_id      = "${aws_vpc.db_vpc.id}"
  ingress {
    from_port = "3306"
    to_port   = "3306"
    protocol  = "tcp"
  }
  #All security groups of app can be defined.
}

#Creating DB instance

resource "aws_db_instance" "db_mongo_instance" {
  allocated_storage      = "10"
  engine                 = "mongodb"
  engine_version         = "${var.engine_version}"
  instance_class         = "${var.db_instance_class}"
  name                   = "${var.dbname}"
  password               = "${var.dbpass}"
  db_subnet_group_name   = "${aws_db_subnet_group.db_subnet_group.name}"
  vpc_security_group_ids = ["${aws_security_group.private_db_sg.id}"]
  skip_final_snapshot    = true
}

#Creating DB server on EC2 instance

#local {
#  engine_version = "${var.engine_version}"
#}

resource "aws_instance" "mongo_db_ec2" {
  ami            = "${data.aws_ami.ubuntu.id}"
  instance_type  = "t2.micro"
  user_data      = <<-EOF
                #!/bin/bash
                sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
				echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list
				read -p "MongoDB Version:  " mongo
				sudo apt-get install -y mongodb-org=$mongo
				#sudo apt-get install -y mongodb-org=3.4 mongodb-org-server=3.4 mongodb-org-shell=3.4 mongodb-org-mongos=3.4 mongodb-org-tools=3.4
				sudo service mongodb start
              EOF
  tags = {
    Name = "MongoEC2"
  }
}


 