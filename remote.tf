# Setup FSS on Webserver1
resource "null_resource" "Webserver1SharedFilesystem" { # definir el recurso nulo para la instalación de software en la instancia del servidor web
  depends_on = [oci_core_instance.Webserver1, oci_core_instance.BastionServer, oci_file_storage_export.Export] # definir la dependencia
  provisioner "remote-exec" { # definir el provisioner
    connection {
      type        = "ssh" # definir el tipo de conexión
      user        = "opc" # definir el usuario
      host        = data.oci_core_vnic.Webserver1_VNIC1.private_ip_address # definir la IP pública de la instancia
      private_key = tls_private_key.public_private_key_pair.private_key_pem # definir la clave privada
      script_path = "/home/opc/myssh.sh" # definir la ruta del script
      agent       = false # definir si se utiliza el agente
      timeout     = "10m" # definir el tiempo de espera
      bastion_host        = data.oci_core_vnic.BastionServer_VNIC1.public_ip_address
      bastion_port        = "22"
      bastion_user        = "opc"
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem
    }
    inline = [
      "echo '== Start of null_resource.Webserver1SharedFilesystem'",
      "sudo /bin/su -c \"yum install -y -q nfs-utils\"",
      "sudo /bin/su -c \"mkdir -p /sharedfs\"",
      "sudo /bin/su -c \"echo '${var.MountTargetIPAddress}:/sharedfs /sharedfs nfs rsize=8192,wsize=8192,timeo=14,intr 0 0' >> /etc/fstab\"",
      "sudo /bin/su -c \"mount /sharedfs\"",
      "echo '== End of null_resource.FoggyKitchenWebserver1SharedFilesystem'"
    ]
  }

}

# Setup FSS on Webserver2
resource "null_resource" "Webserver2SharedFilesystem" { # definir el recurso nulo para la instalación de software en la instancia del servidor web
  depends_on = [oci_core_instance.Webserver2, oci_core_instance.BastionServer, oci_file_storage_export.Export] # definir la dependencia
  provisioner "remote-exec" { # definir el provisioner
    connection {
      type        = "ssh" # definir el tipo de conexión
      user        = "opc" # definir el usuario
      host        = data.oci_core_vnic.Webserver2_VNIC1.private_ip_address # definir la IP pública de la instancia
      private_key = tls_private_key.public_private_key_pair.private_key_pem # definir la clave privada
      script_path = "/home/opc/myssh.sh" # definir la ruta del script
      agent       = false # definir si se utiliza el agente
      timeout     = "10m" # definir el tiempo de espera
      bastion_host        = data.oci_core_vnic.BastionServer_VNIC1.public_ip_address
      bastion_port        = "22"
      bastion_user        = "opc"
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem
    }
    inline = [
      "echo '== Start of null_resource.Webserver2SharedFilesystem'",
      "sudo /bin/su -c \"yum install -y -q nfs-utils\"",
      "sudo /bin/su -c \"mkdir -p /sharedfs\"",
      "sudo /bin/su -c \"echo '${var.MountTargetIPAddress}:/sharedfs /sharedfs nfs rsize=8192,wsize=8192,timeo=14,intr 0 0' >> /etc/fstab\"",
      "sudo /bin/su -c \"mount /sharedfs\"",
      "echo '== End of null_resource.FoggyKitchenWebserver2SharedFilesystem'"
    ]
  }

}

# Software installation within WebServer1 Instance
resource "null_resource" "Webserver1HTTPD" { # definir el recurso nulo para la instalación de software en la instancia del servidor web
  depends_on = [oci_core_instance.Webserver1, oci_core_instance.BastionServer, null_resource.Webserver1SharedFilesystem] # definir la dependencia
  provisioner "remote-exec" { # definir el provisioner
    connection {
      type        = "ssh" # definir el tipo de conexión
      user        = "opc" # definir el usuario
      host        = data.oci_core_vnic.Webserver1_VNIC1.private_ip_address # definir la IP pública de la instancia
      private_key = tls_private_key.public_private_key_pair.private_key_pem # definir la clave privada
      script_path = "/home/opc/myssh.sh" # definir la ruta del script
      agent       = false # definir si se utiliza el agente
      timeout     = "10m" # definir el tiempo de espera
      bastion_host        = data.oci_core_vnic.BastionServer_VNIC1.public_ip_address
      bastion_port        = "22"
      bastion_user        = "opc"
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem
    }
    inline = ["echo '== 1. Installing HTTPD package with yum'", # definir los comandos a ejecutar
      "sudo -u root yum -y -q install httpd", # instalar el paquete HTTPD

     "echo '== 2. Creating /sharedfs/index.html'",
     "sudo -u root touch /sharedfs/index.html",
     "sudo /bin/su -c \"echo 'Welcome to Example.com! These are both WEBSERVERS under LB umbrella with shared index.html Yisus 1...' > /sharedfs/index.html\"",

      "echo '== 3. Adding Alias and Directory sharedfs to /etc/httpd/conf/httpd.conf'",
      "sudo /bin/su -c \"echo 'Alias /shared/ /sharedfs/' >> /etc/httpd/conf/httpd.conf\"",
      "sudo /bin/su -c \"echo '<Directory /sharedfs>' >> /etc/httpd/conf/httpd.conf\"",
      "sudo /bin/su -c \"echo 'AllowOverride All' >> /etc/httpd/conf/httpd.conf\"",
      "sudo /bin/su -c \"echo 'Require all granted' >> /etc/httpd/conf/httpd.conf\"",
      "sudo /bin/su -c \"echo '</Directory>' >> /etc/httpd/conf/httpd.conf\"",

      "echo '== 4. Disabling SELinux'",
      "sudo -u root setenforce 0",

      "echo '== 5. Disabling firewall and starting HTTPD service'",
      "sudo -u root service firewalld stop",
    "sudo -u root service httpd start"]
  }
}

# Software installation within WebServer2 Instance
resource "null_resource" "Webserver2HTTPD" { # definir el recurso nulo para la instalación de software en la instancia del servidor web
  depends_on = [oci_core_instance.Webserver2, oci_core_instance.BastionServer, null_resource.Webserver2SharedFilesystem] # definir la dependencia
  provisioner "remote-exec" { # definir el provisioner
    connection {
      type        = "ssh" # definir el tipo de conexión
      user        = "opc" # definir el usuario
      host        = data.oci_core_vnic.Webserver2_VNIC1.private_ip_address # definir la IP pública de la instancia
      private_key = tls_private_key.public_private_key_pair.private_key_pem # definir la clave privada
      script_path = "/home/opc/myssh.sh" # definir la ruta del script
      agent       = false # definir si se utiliza el agente
      timeout     = "10m" # definir el tiempo de espera
      bastion_host        = data.oci_core_vnic.BastionServer_VNIC1.public_ip_address
      bastion_port        = "22"
      bastion_user        = "opc"
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem
    }
    inline = ["echo '== 1. Installing HTTPD package with yum'",
      "sudo -u root yum -y -q install httpd",

      "echo '== 2. Adding Alias and Directory sharedfs to /etc/httpd/conf/httpd.conf'",
      "sudo /bin/su -c \"echo 'Alias /shared/ /sharedfs/' >> /etc/httpd/conf/httpd.conf\"",
      "sudo /bin/su -c \"echo '<Directory /sharedfs>' >> /etc/httpd/conf/httpd.conf\"",
      "sudo /bin/su -c \"echo 'AllowOverride All' >> /etc/httpd/conf/httpd.conf\"",
      "sudo /bin/su -c \"echo 'Require all granted' >> /etc/httpd/conf/httpd.conf\"",
      "sudo /bin/su -c \"echo '</Directory>' >> /etc/httpd/conf/httpd.conf\"",

      "echo '== 3. Disabling SELinux'",
      "sudo -u root setenforce 0",

      "echo '== 4. Disabling firewall and starting HTTPD service'",
      "sudo -u root service firewalld stop",
    "sudo -u root service httpd start"]
  }
}
