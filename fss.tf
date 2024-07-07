# Mount Target

resource "oci_file_storage_mount_target" "MountTarget" {
  availability_domain = var.availablity_domain_name == "" ? lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name") : var.availablity_domain_name
  compartment_id      = oci_identity_compartment.Prod_01.id
  subnet_id           = oci_core_subnet.WebSubnet.id
  ip_address          = var.MountTargetIPAddress
  display_name        = "MountTarget"
}

# Export Set

resource "oci_file_storage_export_set" "Exportset" {
  mount_target_id = oci_file_storage_mount_target.MountTarget.id
  display_name    = "Exportset"
}

# FileSystem

resource "oci_file_storage_file_system" "Filesystem" {
  availability_domain = var.availablity_domain_name == "" ? lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name") : var.availablity_domain_name
  compartment_id      = oci_identity_compartment.Prod_01.id
  display_name        = "Filesystem"
}

# Export

resource "oci_file_storage_export" "Export" {
  export_set_id  = oci_file_storage_mount_target.MountTarget.export_set_id
  file_system_id = oci_file_storage_file_system.Filesystem.id
  path           = "/sharedfs"
}
