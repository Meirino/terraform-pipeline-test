output "Web_ip" {
  value = "${aws_instance.web.public_ip}"
}

output "Web2_ip" {
  value = "${aws_instance.web2.public_ip}"
}
