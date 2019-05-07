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

  tags {
    Name = "Public Subnet 1"
    Project = "Jenkins"
  }
}