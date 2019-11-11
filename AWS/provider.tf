provider "aws" {
  region = "ap-south-1"
  #profile = "$var.aws_profile}"
}

resource "aws_security_group" "private_db_sg" {
  name        = "private_sg"
  description = "Used for db instances"
#  vpc_id      = "10.0.0.0/16"
  ingress {
    from_port = "80"
    to_port   = "80"
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port   = 22
      to_port     = 22
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

resource "aws_instance" "EC2"{
  ami = "ami-040c7ad0a93be494e"
  instance_type = "t2.micro"
  key_name = "provkeypair"
  vpc_security_group_ids = ["${aws_security_group.private_db_sg.id}"]

  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras install -y nginx1.12",
      "sudo systemctl start nginx"
   ]

   connection {
     type = "ssh"
     user = "ec2-user"
     private_key = file("./provkeypair.pem")
     host = self.public_ip
   }
  }
}
