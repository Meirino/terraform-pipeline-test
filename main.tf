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

resource "aws_s3_bucket_policy" "b" {
  bucket = "${aws_s3_bucket.terraform-state-storage-s3.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::mybucket"
    },
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": ["s3:GetObject", "s3:PutObject"],
      "Resource": "arn:aws:s3:::mybucket/path/to/my/key"
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