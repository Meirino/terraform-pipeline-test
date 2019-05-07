variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "region" {}

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