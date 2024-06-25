# VCN
resource "oci_core_virtual_network" "VCN_Prod_01" {
  cidr_block     = var.VCN-CIDR
  dns_label      = "VCN_Prod_01"
  compartment_id = oci_identity_compartment.Prod_01.id
  display_name   = "VCN_Prod_01"
}

# DHCP Options
resource "oci_core_dhcp_options" "DhcpOptions1" {
  compartment_id = oci_identity_compartment.Prod_01.id
  vcn_id         = oci_core_virtual_network.VCN_Prod_01.id
  display_name   = "DHCPOptions1"

  options {
    type        = "DomainNameServer"
    server_type = "VcnLocalPlusInternet"
  }

  options {
    type                = "SearchDomain"
    search_domain_names = ["example.com"]
  }
}

# Internet Gateway
resource "oci_core_internet_gateway" "InternetGateway" {
  compartment_id = oci_identity_compartment.Prod_01.id
  display_name   = "InternetGateway"
  vcn_id         = oci_core_virtual_network.VCN_Prod_01.id
}

# Route Table
resource "oci_core_route_table" "RouteTableViaIGW" {
  compartment_id = oci_identity_compartment.Prod_01.id
  vcn_id         = oci_core_virtual_network.VCN_Prod_01.id
  display_name   = "RouteTableViaIGW"
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.InternetGateway.id
  }
}

# Security List
resource "oci_core_security_list" "SecurityList" {
  compartment_id = oci_identity_compartment.Prod_01.id
  display_name   = "SecurityList"
  vcn_id         = oci_core_virtual_network.VCN_Prod_01.id

  egress_security_rules {
    protocol    = "6"
    destination = "0.0.0.0/0"
  }

  dynamic "ingress_security_rules" {
    for_each = var.service_ports
    content {
      protocol = "6"
      source   = "0.0.0.0/0"
      tcp_options {
        max = ingress_security_rules.value
        min = ingress_security_rules.value
      }
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = var.VCN-CIDR
  }
}

# Subnet
resource "oci_core_subnet" "WebSubnet" {
  cidr_block        = var.Subnet-CIDR
  display_name      = "WebSubnet"
  dns_label         = "WebSubnetN1"
  compartment_id    = oci_identity_compartment.Prod_01.id
  vcn_id            = oci_core_virtual_network.VCN_Prod_01.id
  route_table_id    = oci_core_route_table.RouteTableViaIGW.id
  dhcp_options_id   = oci_core_dhcp_options.DhcpOptions1.id
  security_list_ids = [oci_core_security_list.SecurityList.id]
}
