variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "region" {}

data "aws_ami" "AMI_1" {
  most_recent      = true
  owners           = ["self"]
  name_regex       = "^app-docker-\\d{10}"
}