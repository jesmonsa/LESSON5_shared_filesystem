# VCN
resource "oci_core_virtual_network" "VCN_Prod_01" { # definir el recurso de la red virtual (VCN)
  cidr_block     = var.VCN-CIDR # definir el bloque CIDR de la VCN
  dns_label      = "vcnprod01" # definir la etiqueta DNS de la VCN
  compartment_id = oci_identity_compartment.Prod_01.id # definir el OCID del compartimento
  display_name   = "vcnprod01" # definir el nombre de la VCN
}

# DHCP Options
resource "oci_core_dhcp_options" "DhcpOptions1" { # definir el recurso de las opciones DHCP
  compartment_id = oci_identity_compartment.Prod_01.id # definir el OCID del compartimento
  vcn_id         = oci_core_virtual_network.VCN_Prod_01.id # definir el OCID de la VCN
  display_name   = "DHCPOptions1"

  options {
    type        = "DomainNameServer" # definir el tipo de opción
    server_type = "VcnLocalPlusInternet" # definir el tipo de servidor
  }

  options {
    type                = "SearchDomain"  # definir el tipo de opción
    search_domain_names = ["example.com"] # definir el nombre del dominio de búsqueda
  }
}

# Internet Gateway
resource "oci_core_internet_gateway" "InternetGateway" { # definir el recurso de la puerta de enlace de Internet
  compartment_id = oci_identity_compartment.Prod_01.id # definir el OCID del compartimento
  display_name   = "InternetGateway" # definir el nombre de la puerta de enlace de Internet
  vcn_id         = oci_core_virtual_network.VCN_Prod_01.id # definir el OCID de la VCN
}

# Route Table
resource "oci_core_route_table" "RouteTableViaIGW" { # definir el recurso de la tabla de rutas
  compartment_id = oci_identity_compartment.Prod_01.id # definir el OCID del compartimento
  vcn_id         = oci_core_virtual_network.VCN_Prod_01.id # definir el OCID de la VCN
  display_name   = "RouteTableViaIGW"
  route_rules { # definir las reglas de ruta
    destination       = "0.0.0.0/0" # definir el destino
    destination_type  = "CIDR_BLOCK" # definir el tipo de destino
    network_entity_id = oci_core_internet_gateway.InternetGateway.id # definir el OCID de la puerta de enlace de Internet
  }
}

# Security List
resource "oci_core_security_list" "SecurityList" { # definir el recurso de la lista de seguridad
  compartment_id = oci_identity_compartment.Prod_01.id # definir el OCID del compartimento
  display_name   = "SecurityList" # definir el nombre de la lista de seguridad
  vcn_id         = oci_core_virtual_network.VCN_Prod_01.id # definir el OCID de la VCN

  egress_security_rules { # definir las reglas de seguridad de salida
    protocol    = "6" # definir el protocolo
    destination = "0.0.0.0/0" # definir el destino
  }

  dynamic "ingress_security_rules" { # definir las reglas de seguridad de entrada
    for_each = var.service_ports # definir si la forma de la instancia es flexible o no lo es
    content { # definir el contenido de las reglas de seguridad de entrada
      protocol = "6" # definir el protocolo
      source   = "0.0.0.0/0" # definir la fuente
      tcp_options {
        max = ingress_security_rules.value # definir el máximo
        min = ingress_security_rules.value # definir el mínimo
      }
    }
  }

  ingress_security_rules { # definir las reglas de seguridad de entrada
    protocol = "6" # definir el protocolo
    source   = var.VCN-CIDR # definir la fuente
  }
}

# Subnet
resource "oci_core_subnet" "WebSubnet" { # definir el recurso de la subred
  cidr_block        = var.Subnet-CIDR # definir el bloque CIDR de la subred
  display_name      = "WebSubnet" # definir el nombre de la subred
  dns_label         = "WebSubnetN1"   # definir la etiqueta DNS de la subred
  compartment_id    = oci_identity_compartment.Prod_01.id # definir el OCID del compartimento
  vcn_id            = oci_core_virtual_network.VCN_Prod_01.id # definir el OCID de la VCN
  route_table_id    = oci_core_route_table.RouteTableViaIGW.id # definir el OCID de la tabla de rutas
  dhcp_options_id   = oci_core_dhcp_options.DhcpOptions1.id # definir el OCID de las opciones DHCP
  security_list_ids = [oci_core_security_list.SecurityList.id] # definir el OCID de la lista de seguridad
}
