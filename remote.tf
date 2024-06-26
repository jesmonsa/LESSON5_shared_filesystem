# Software installation within WebServer Instance
resource "null_resource" "Webserver1HTTPD" { # definir el recurso nulo para la instalación de software en la instancia del servidor web
  depends_on = [oci_core_instance.Webserver1] # definir la dependencia
  provisioner "remote-exec" { # definir el provisioner
    connection {
      type        = "ssh" # definir el tipo de conexión
      user        = "opc" # definir el usuario
      host        = data.oci_core_vnic.Webserver1_VNIC1.public_ip_address # definir la IP pública de la instancia
      private_key = tls_private_key.public_private_key_pair.private_key_pem # definir la clave privada
      script_path = "/home/opc/myssh.sh" # definir la ruta del script
      agent       = false # definir si se utiliza el agente
      timeout     = "10m" # definir el tiempo de espera
    }
    inline = ["echo '== 1. Installing HTTPD package with yum'", # definir los comandos a ejecutar
      "sudo -u root yum -y -q install httpd", # instalar el paquete HTTPD

      "echo '== 2. Creating /var/www/html/index.html'", # crear el archivo index.html
      "sudo -u root touch /var/www/html/index.html", # crear el archivo index.html
      "sudo /bin/su -c \"echo 'Welcome to example.com! This is WEBSERVER1...' > /var/www/html/index.html\"", # escribir en el archivo index.html

      "echo '== 3. Disabling firewall and starting HTTPD service'", # deshabilitar el firewall y arrancar el servicio HTTPD
      "sudo -u root service firewalld stop", # detener el servicio de firewall
    "sudo -u root service httpd start"] # arrancar el servicio HTTPD
  }
}
