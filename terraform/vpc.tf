resource "aws_vpc" "internal" {
  cidr_block = "${var.vpc_cidr_private}"

  tags = {
    Name = "Internal Network"
  }
}

resource "aws_subnet" "subnet-internal" {
  vpc_id            = "${aws_vpc.internal.id}"
  cidr_block        = "${var.vpc_cidr_private}"
  tags = {
    Name            = "Internal subnet"
  }
}

resource "aws_vpc" "external" {
  cidr_block = "${var.vpc_cidr_external}"

  tags = {
    Name = "External Network"
  }
}

resource "aws_subnet" "subnet-external" {
  vpc_id            = "${aws_vpc.external.id}"
  cidr_block        = "${var.vpc_cidr_external}"
  tags = {
    Name            = "External subnet"
  }
}

## Internet gateway
resource "aws_internet_gateway" "gateway" {
    vpc_id = "${aws_vpc.external.id}"
}


## Elastic IP for NAT GW
resource "aws_eip" "eip" {
  vpc        = true
  depends_on = ["aws_internet_gateway.gateway"]
}


## NAT gateway
resource "aws_nat_gateway" "gateway" {
    allocation_id = "${aws_eip.eip.id}"
    subnet_id     = "${aws_subnet.subnet-external.id}"
    depends_on    = ["aws_internet_gateway.gateway"]
}

output "NAT_GW_IP" {
  value = "${aws_eip.eip.public_ip}"
}