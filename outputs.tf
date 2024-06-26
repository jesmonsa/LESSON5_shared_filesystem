# WebServer Instance Public IP
output "Webserver1PublicIP" { # definir la salida de la IP pública de la instancia
  value = [data.oci_core_vnic.Webserver1_VNIC1.public_ip_address] # definir la IP pública de la instancia
}

# Generated Private Key for WebServer Instance
output "generated_ssh_private_key" { # definir la salida de la clave privada generada para la instancia
  value     = tls_private_key.public_private_key_pair.private_key_pem # definir la clave privada generada
  sensitive = true
}
