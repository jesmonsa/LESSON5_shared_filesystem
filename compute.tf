# WebServer Compute

resource "oci_core_instance" "Webserver1" {
  availability_domain = var.availablity_domain_name == "" ? lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name") : var.availablity_domain_name
  compartment_id      = oci_identity_compartment.Prod_01.id
  display_name        = "WebServer1"
  shape               = var.Shape

  dynamic "shape_config" {
    for_each = local.is_flexible_shape ? [1] : []
    content {
      memory_in_gbs = var.FlexShapeMemory
      ocpus         = var.FlexShapeOCPUS
    }
  }

  source_details {
    source_type = "image"
    source_id   = lookup(data.oci_core_images.OSImage.images[0], "id")
  }

  metadata = {
    ssh_authorized_keys = tls_private_key.public_private_key_pair.public_key_openssh
  }

  # WebServer VNIC
  create_vnic_details {
    subnet_id       = oci_core_subnet.WebSubnet.id
    assign_public_ip = true
  }
}

data "oci_core_vnic" "Webserver1_VNIC1" {
  # Asegúrate de que este vnic_id se obtiene del data source oci_core_vnic_attachments correctamente
  vnic_id = data.oci_core_vnic_attachments.Webserver1_VNIC1_attach.vnic_attachments[0].vnic_id
}