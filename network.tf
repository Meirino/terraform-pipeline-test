provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.region}"
}

resource "aws_vpc" "default" {
  cidr_block       = "20.10.0.0/16"

  tags = {
    Name = "Example VPC"
    Project = "Jenkins"
  }
}

resource "aws_subnet" "public-subnet" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "20.10.1.0/24"
  availability_zone = "${var.region}a"
  map_public_ip_on_launch = true

  tags {
    Name = "Public Subnet 1"
    Project = "Jenkins"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.default.id}"

  tags = {
    Name = "App-GW"
  }
}

resource "aws_route_table" "r" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    egress_only_gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags = {
    Name = "Main App RT"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
    subnet_id = "${aws_subnet.public-subnet.id}"
    route_table_id = "${aws_route_table.r.id}"
}