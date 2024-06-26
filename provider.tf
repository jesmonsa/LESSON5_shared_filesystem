terraform { # Versión de Terraform.
  required_providers { # Proveedores requeridos.
    oci = {
      source = "oracle/oci" # Fuente del proveedor de OCI.
      version = "5.35.0" # Versión del proveedor de OCI.
    }
  }
}
# General Provider 
provider "oci" {
  tenancy_ocid     = var.tenancy_ocid # definir el OCID del tenancy
  user_ocid        = var.user_ocid # definir el OCID del usuario
  fingerprint      = var.fingerprint # definir la huella digital
  private_key_path = var.private_key_path # definir la ruta de la clave privada
  region           = var.region # definir la región
}

# Home Region Provider
provider "oci" {
  alias                = "homeregion" # definir el alias del proveedor
  tenancy_ocid         = var.tenancy_ocid # definir el OCID del tenancy
  user_ocid            = var.user_ocid # definir el OCID del usuario
  fingerprint          = var.fingerprint # definir la huella digital
  private_key_path     = var.private_key_path # definir la ruta de la clave privada
  region               = data.oci_identity_region_subscriptions.home_region_subscriptions.region_subscriptions[0].region_name # definir la región
  disable_auto_retries = "true" # definir si se deshabilitan los reintentos automáticos
}
