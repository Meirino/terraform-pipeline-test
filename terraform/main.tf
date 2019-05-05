provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.region}"
}

data "aws_ami" "AMI" {
  most_recent      = true
  owners           = ["self"]
  name_regex       = "^packer-example-\\d{10}"
}


resource "aws_vpc" "default" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "dedicated"

  tags = {
    Name = "Example"
    Project = "Jenkins"
  }
}

resource "aws_subnet" "public-subnet" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = "${var.region}a"

  tags {
    Name = "Public Subnet"
    Project = "Jenkins"
  }
}

resource "aws_instance" "web" {
  ami           = "${data.aws_ami.AMI.id}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.public-subnet.id}"

  tags = {
    Name = "Custom AMI EC2"
    Project = "Jenkins"
  }
}

terraform {
  backend "local" {
    path = "./terraform.tfstate"
  }
}