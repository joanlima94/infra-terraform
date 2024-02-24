provider "aws" {
  region = "us-east-1"

}

resource "aws_instance" "backend" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ubuntu_sec_group.id]

  user_data = <<-EOF
              #!bin/bash
              echo "hello instance!" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF

  tags = {
    name = "ubuntu-instance"
  }

}

resource "aws_security_group" "ubuntu_sec_group" {

  name = "ubuntu-instance"
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

}