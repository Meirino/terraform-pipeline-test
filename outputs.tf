output "VPC_id" {
  value = "${aws_vpc.default.id}"
}

output "Web_ip" {
  value = "${aws_instance.web.public_ip}"
}

output "Web2_ip" {
  value = "${aws_instance.web2.public_ip}"
}

// El remote falla si no exiten los atributos (O no han sido creados aún)

# output "VPC_id_remote" {
#   value = "${data.terraform_remote_state.cbgi.VPC_id}"
# }

# output "Web_ip_remote" {
#   value = "${data.terraform_remote_state.cbgi.Web_ip}"
# }

# output "Web2_ip_remote" {
#   value = "${data.terraform_remote_state.cbgi.Web2_ip}"
# }
