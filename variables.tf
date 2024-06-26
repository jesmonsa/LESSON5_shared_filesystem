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

variable "VCN-CIDR" { # definir el CIDR de la VCN
  default = "10.0.0.0/16" # definir el valor por defecto
}

variable "Subnet-CIDR" { # definir el CIDR de la subred
  default = "10.0.1.0/24" # definir el valor por defecto
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

variable "service_ports" { # definir los puertos de los servicios
  default = [80, 443, 22] # definir el valor por defecto
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
}
