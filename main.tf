provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.region}"
}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "dedicated"

  tags = {
    Name = "Example"
    Project = "Jenkins"
  }
}

resource "aws_s3_bucket" "terraform-state-storage-s3" {
    bucket = "terraform-state-management-bucket-s3"
 
    versioning {
      enabled = true
    }
 
    lifecycle {
      prevent_destroy = true
    }
 
    tags {
      Name = "S3 Remote Terraform State Store"
      Project = "Jenkins"
    }      
}

resource "aws_s3_bucket_policy" "tf-bucket-policy" {
  bucket = "${aws_s3_bucket.terraform-state-storage-s3.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "MY_POLICY"
  "Statement": [
    {
      "Sid": "Stmt1556886425926",
      "Action": [
        "s3:GetObject",
        "s3:ListBucket",
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::terraform-state-management-bucket-s3/*",
      "Principal": "*"
    }
  ]
}
POLICY
}

# terraform {
#  backend "s3" {
#  encrypt = true
#  bucket = "terraform-remote-state-storage-s3"
#  region = "${var.region}"
#  key = ""
#  }
# }