#Creating VPC
/*
resource "aws_vpc" "db_vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    name = "db_vpc"
  }
}
*/
#Creating security groups

resource "aws_security_group" "private_db_sg" {
  name        = "private_sg"
  description = "Used for db instances"
  #vpc_id      = "${aws_vpc.db_vpc.id}"
  ingress {
    from_port = "27017"
    to_port   = "27017"
    protocol  = "tcp"
  }

  ingress {
      from_port   = "22"
      to_port     = "22"
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  #All security groups of app can be defined.
}

#Using provisioner


resource "aws_instance" "EC2"{
    ami = "ami-040c7ad0a93be494e"
    instance_type = "t2.micro"
    key_name = "provkeypair"
    vpc_security_group_ids = ["${aws_security_group.private_db_sg.id}"]

    provisioner "remote-exec" {
      inline = [
        "sudo yum install -y docker",
        "sudo usermod -a -G docker ec2-user",
        "sudo service docker start",
        "sudo docker pull mongo",
        "sudo docker run --name some-mongo -d mongo:latest"
        #"echo 'name=MongoDB Repository' | sudo tee /etc/yum.repos.d/mongodb-org-3.0.repo",
        #"echo 'baseurl=https://repo.mongodb.org/yum/amazon/2013.03/mongodb-org/3.0/x86_64/' | sudo tee /etc/yum.repos.d/mongodb-org-3.0.repo",
        #"echo 'gpgcheck=0' | sudo tee /etc/yum.repos.d/mongodb-org-3.0.repo",
        #"echo 'enabled=1' | sudo tee /etc/yum.repos.d/mongodb-org-3.0.repo",
				#"sudo yum install -y mongodb-org",
				#"sudo service mongod start",
        #"sudo chkconfig mongod on"
     ]

     connection {
       type = "ssh"
       user = "ec2-user"
       private_key = file("./provkeypair.pem")
       host = self.public_ip
     }
  }
}