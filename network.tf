provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.region}"
}

// Configurar el data source que lee del remote
data "terraform_remote_state" "cbgi" {
  backend = "local"
  config {
    path = "terraform.tfstate"
  }
}

resource "aws_vpc" "default" {
  cidr_block       = "20.10.0.0/16"

  tags = {
    Name = "Example VPC"
    Project = "Jenkins"
  }
}

resource "aws_subnet" "public-subnet-1" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "20.10.1.0/24"
  availability_zone = "${var.region}a"
  map_public_ip_on_launch = true

  tags {
    Name = "Public Subnet 1"
    Project = "Jenkins"
  }
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "20.10.2.0/24"
  availability_zone = "${var.region}b"
  map_public_ip_on_launch = true

  tags {
    Name = "Public Subnet 2"
    Project = "Jenkins"
  }
}

resource "aws_subnet" "public-subnet-3" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "20.10.3.0/24"
  availability_zone = "${var.region}c"
  map_public_ip_on_launch = true

  tags {
    Name = "Public Subnet 3"
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
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags = {
    Name = "Main App RT"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
    subnet_id = "${aws_subnet.public-subnet-1.id}"
    route_table_id = "${aws_route_table.r.id}"
}

resource "aws_route_table_association" "public_subnet_association-2" {
    subnet_id = "${aws_subnet.public-subnet-2.id}"
    route_table_id = "${aws_route_table.r.id}"
}

// Configurar remote
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}