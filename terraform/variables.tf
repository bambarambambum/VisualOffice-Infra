variable "aws_region" {
  description = "Region for the VPC"
  default = "eu-central-1"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default = "172.28.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
  default = "172.28.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for the private subnet"
  default = "172.28.2.0/24"
}

variable "key_path" {
  description = "SSH Public Key path"
  default = "~/.ssh/androsovm.pub"
}