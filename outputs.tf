output "Web_ip" {
  value = "${aws_instance.web.public_ip}"
}

output "Web2_ip" {
  value = "${aws_instance.web2.public_ip}"
}

output "Web_ip_remote" {
  value = "${data.terraform_remote_state.vpc.Web_ip}"
}

output "Web2_ip_remote" {
  value = "${data.terraform_remote_state.vpc.Web2_ip}"
}
