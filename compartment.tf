resource "oci_identity_compartment" "Prod_01" {
  provider       = oci.homeregion
  name           = "Prod_01"
  description    = "Prod_01 Compartment"
  compartment_id = var.compartment_ocid

  provisioner "local-exec" {
    command = "sleep 60"
  }
}

