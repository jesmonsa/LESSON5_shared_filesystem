# All variables used by the automation.

variable "tenancy_ocid" {} # definir el OCID del tenancy
variable "user_ocid" {} # definir el OCID del usuario
variable "fingerprint" {} # definir la huella digital
variable "private_key_path" {} # definir la ruta de la clave privada
variable "compartment_ocid" {} # definir el OCID del compartment
variable "region" {} # definir la región

variable "availablity_domain_name" { # definir el nombre del dominio de disponibilidad
  default = "" # definir el valor por defecto
}

variable "availablity_domain_name2" { # definir el nombre del dominio de disponibilidad
  default = "" # definir el valor por defecto
}

variable "VCN-CIDR" { # definir el CIDR de la VCN
  default = "10.0.0.0/16" # definir el valor por defecto
}

variable "WebSubnet-CIDR" {
  default = "10.0.1.0/24"
}

variable "LBSubnet-CIDR" {
  default = "10.0.2.0/24"
}

variable "BastionSubnet-CIDR" {
  default = "10.0.3.0/24"
}

variable "MountTargetIPAddress" {
  default = "10.0.1.25"
}

variable "Shape" { # definir la forma
  default = "VM.Standard.E3.Flex" # definir el valor por defecto
}

variable "FlexShapeOCPUS" { # definir los OCPUs de la instancia flexible
  default = 1 # definir el valor por defecto
}

variable "FlexShapeMemory" { # definir la memoria de la instancia flexible
  default = 1 # definir el valor por defecto
}

variable "instance_os" { # definir el sistema operativo de la instancia
  default = "Oracle Linux" # definir el valor por defecto
}

variable "linux_os_version" { # definir la versión del sistema operativo Linux
  default = "7.9" # definir el valor por defecto
}

variable "webservice_ports" {
  default = [80, 443]
}

variable "bastion_ports" {
  default = [22]
}

variable "lb_shape" {
  default = "flexible"
}

variable "flex_lb_min_shape" {
  default = 10
}

variable "flex_lb_max_shape" {
  default = 100
}

# Dictionary Locals
locals {
  compute_flexible_shapes = [ # definir las formas de la instancia flexible
    "VM.Standard.E3.Flex", # definir la forma de la instancia flexible
    "VM.Standard.E4.Flex", # definir la forma de la instancia flexible
    "VM.Standard.E5.Flex", # definir la forma de la instancia flexible
    "VM.Standard.A1.Flex", # definir la forma de la instancia flexible
    "VM.Optimized3.Flex" # definir la forma de la instancia flexible
  ]
}

# Checks if is using Flexible Compute Shapes
locals {
  is_flexible_shape = contains(local.compute_flexible_shapes, var.Shape)
  is_flexible_lb_shape = var.lb_shape == "flexible" ? true : false
}
