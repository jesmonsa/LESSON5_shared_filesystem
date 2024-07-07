# Bastion Instance Public IP
output "BastionServer_PublicIP" {
  value = [data.oci_core_vnic.BastionServer_VNIC1.public_ip_address]
}

output "PublicLoadBalancer_URL" {
  value = "http://${oci_load_balancer.PublicLoadBalancer.public_ip_addresses[0].ip_address}/shared/"
}


# WebServer1 Instance Private IP
output "Webserver1PrivateIP" { # definir la salida de la IP pública de la instancia
  value = [data.oci_core_vnic.Webserver1_VNIC1.private_ip_address] # definir la IP pública de la instancia
}

# WebServer2 Instance Private IP
output "Webserver2PrivateIP" { # definir la salida de la IP pública de la instancia
  value = [data.oci_core_vnic.Webserver2_VNIC1.private_ip_address] # definir la IP pública de la instancia
}

# Generated Private Key for WebServer Instance
output "generated_ssh_private_key" { # definir la salida de la clave privada generada para la instancia
  value     = tls_private_key.public_private_key_pair.private_key_pem # definir la clave privada generada
  sensitive = true
}
