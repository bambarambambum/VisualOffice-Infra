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
  key_name = "${var.key_name}"
  public_key = "${file("${var.key_path}")}"
}

resource "aws_instance" "web_app" {

  ami           = "ami-05f7491af5eef733a"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.public-subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.sgweb.id}"]
  associate_public_ip_address = true
  key_name = "${var.key_name}"

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
  key_name = "${var.key_name}"

  tags = {
    Name = "do-${count.index + 2}"
    Project = "VisualOffice-App-Python"
  }
}

# generate config file for SSH
resource "local_file" "ssh_config" {
  content = templatefile("./templates/config.tpl",
    {
      do-01-ip = aws_eip.static_ip.public_ip
      do-02-ip = aws_instance.services.0.private_ip
      do-03-ip = aws_instance.services.1.private_ip
      do-04-ip = aws_instance.services.2.private_ip
      key_name = "${var.key_name}"
    }
  )
  filename = "./files/config"
  file_permission = "0644"
}

# generate config file for Ansible
resource "local_file" "ansible_config" {
  content = templatefile("./templates/ansible.cfg.tpl",
    {
      key_name = "${var.key_name}"
      remote_user = "ubuntu"
    }
  )
  filename = "./files/ansible.cfg"
  file_permission = "0644"
}

# generate hosts file for Ansible
resource "local_file" "ansible_hosts" {
  content = templatefile("./templates/hosts.tpl", {})
  filename = "./files/hosts"
  file_permission = "0644"
}

output "webserver_public_ip_address" {
  value = aws_eip.static_ip.public_ip
}