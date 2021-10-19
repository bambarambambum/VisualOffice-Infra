terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "eu-central-1"
}

resource "aws_eip" "static_ip" {
  instance = aws_instance.web_app.id
}

resource "aws_instance" "web_app" {

  ami           = "ami-05f7491af5eef733a"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_app.id, aws_security_group.ssh.id]

  tags = {
    Name = "do-1"
    Project = "VisualOffice-App-Python"
  }
}

resource "aws_instance" "services" {

  count         = 3
  ami           = "ami-05f7491af5eef733a"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ssh.id]

  tags = {
    Name = "do-${count.index + 2}"
    Project = "VisualOffice-App-Python"
  }
}

resource "aws_instance" "monitoring" {

  ami           = "ami-05f7491af5eef733a"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ssh.id]

  tags = {
    Name = "do-5"
    Project = "VisualOffice-App-Python"
  }
}

resource "aws_security_group" "ssh" {

  name = "SSH Rule"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["176.193.244.43/32"]
  }

}
resource "aws_security_group" "web_app" {

  name = "Rules for web-app"

  ingress {
    from_port = 8000
    to_port = 8000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}

output "webserver_public_ip_address" {
  value = aws_eip.static_ip.public_ip
}