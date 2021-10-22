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
  region  = "${var.aws_region}"
}

resource "aws_eip" "static_ip" {
  instance = aws_instance.web_app.id
}

# Define SSH key pair for our instances
resource "aws_key_pair" "default" {
  key_name = "user"
  public_key = "${file("${var.key_path}")}"
}

resource "aws_instance" "web_app" {

  ami           = "ami-05f7491af5eef733a"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.public-subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.sgweb.id}"]
  associate_public_ip_address = true

  tags = {
    Name = "do-1"
    Project = "VisualOffice-App-Python"
  }
}

resource "aws_instance" "services" {

  count         = 3
  ami           = "ami-05f7491af5eef733a"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.private-subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.sgservices.id}"]

  tags = {
    Name = "do-${count.index + 2}"
    Project = "VisualOffice-App-Python"
  }
}

output "webserver_public_ip_address" {
  value = aws_eip.static_ip.public_ip
}