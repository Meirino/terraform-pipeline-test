output "VPC_id" {
  value = "${aws_vpc.default.id}"
}

output "Web_ip" {
  value = "${aws_instance.web.public_ip}"
}

output "Web2_ip" {
  value = "${aws_instance.web2.public_ip}"
}

// El remote falla si no exiten los atributos (O no han sido creados aún), o el propio archivo .tfstate en una primera ejecución.
// Si terraform tiene que recrear recursos, los valores de remote serán los antiguos.
