resource "aws_security_group" "app_sec_group" {
  name          = "app_security_group"
  description   = "Allow app traffic"
  vpc_id        = "${aws_vpc.default.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = "170.252.72.1/32"
    description = "Accenture SSH"
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = "170.252.72.1/32"
    description = "Accenture Node Port"
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = "170.252.72.1/32"
    description = "Accenture HTTP"
  }

  tags = {
    Name = "allow_all"
  }
}

resource "aws_instance" "web" {
  ami               = "${data.aws_ami.AMI_1.id}"
  instance_type     = "t2.micro"
  subnet_id         = "${aws_subnet.public-subnet.id}"
  security_groups   = ["${aws_security_group.app_sec_group.id}"]

  tags = {
    Name = "App"
    Project = "Jenkins"
  }
}