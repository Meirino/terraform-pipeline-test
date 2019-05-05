provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.region}"
}

data "aws_ami" "AMI_1" {
  most_recent      = true
  owners           = ["self"]
  name_regex       = "^packer-example-1-\\d{10}"
}

data "aws_ami" "AMI_2" {
  most_recent      = true
  owners           = ["self"]
  name_regex       = "^packer-example-2-\\d{10}"
}

resource "aws_vpc" "default" {
  cidr_block       = "10.0.0.0/16"

  tags = {
    Name = "Example VPC"
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

resource "aws_instance" "web1" {
  ami           = "${data.aws_ami.AMI_1.id}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.public-subnet.id}"

  tags = {
    Name = "Custom AMI_1 EC2"
    Project = "Jenkins"
  }
}

resource "aws_instance" "web2" {
  ami           = "${data.aws_ami.AMI_2.id}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.public-subnet.id}"

  tags = {
    Name = "Custom AMI_2 EC2"
    Project = "Jenkins"
  }
}