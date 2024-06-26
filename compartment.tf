resource "oci_identity_compartment" "Prod_01" { # definir el recurso del compartimento
  provider       = oci.homeregion # definir el proveedor
  name           = "Prod_01" # definir el nombre del compartimento
  description    = "Prod_01 Compartment" # definir la descripción del compartimento
  compartment_id = var.compartment_ocid # definir el OCID del compartimento padre

  provisioner "local-exec" { # definir el provisioner
    command = "sleep 60" # definir el comando a ejecutar en este caso un sleep de 60 segundos para esperar a que se cree el compartimento
  }
}

