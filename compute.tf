# WebServer Compute

resource "oci_core_instance" "Webserver1" { # definir el recurso de la instancia
  availability_domain = var.availablity_domain_name == "" ? lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name") : var.availablity_domain_name # definir el dominio de disponibilidad de la instancia en caso de que no se haya definido en las variables
  compartment_id      = oci_identity_compartment.Prod_01.id # definir el OCID del compartimento
  display_name        = "WebServer1" # definir el nombre de la instancia
  shape               = var.Shape # definir la forma de la instancia

  dynamic "shape_config" { # definir la configuración de la forma de la instancia
    for_each = local.is_flexible_shape ? [1] : []  # definir si la forma de la instancia es flexible o no lo es 
    content { # definir el contenido de la forma de la instancia
      memory_in_gbs = var.FlexShapeMemory # definir la memoria de la instancia flexible
      ocpus         = var.FlexShapeOCPUS # definir los OCPUs de la instancia flexible
    }
  }

  source_details { # definir los detalles de la fuente de la instancia
    source_type = "image" # definir el tipo de fuente de la instancia
    source_id   = lookup(data.oci_core_images.OSImage.images[0], "id") # definir el OCID de la imagen de la instancia
  }

  metadata = { # definir los metadatos de la instancia
    ssh_authorized_keys = tls_private_key.public_private_key_pair.public_key_openssh # definir la clave pública SSH
  }

  # WebServer VNIC
  create_vnic_details { # definir los detalles de la creación de la VNIC
    subnet_id       = oci_core_subnet.WebSubnet.id # definir el OCID de la subred
    assign_public_ip = true # definir si se asigna una IP pública a la VNIC
  }
}

data "oci_core_vnic" "Webserver1_VNIC1" { # definir el data source de la VNIC
  # Asegúrate de que este vnic_id se obtiene del data source oci_core_vnic_attachments correctamente
  vnic_id = data.oci_core_vnic_attachments.Webserver1_VNIC1_attach.vnic_attachments[0].vnic_id # definir el OCID de la VNIC
}