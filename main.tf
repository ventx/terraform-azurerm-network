resource "azurerm_virtual_network" "spoke1_kubevnet" {
  name                = "${var.name}-spoke1-kubevnet"
  location            = var.region
  resource_group_name = var.rg_name
  address_space       = [var.vpc_cidr_kubevnet]

  tags = var.tags
}

resource "azurerm_virtual_network" "hub1_natgwvnet" {
  name                = "${var.name}-hub1-natgwvnet"
  location            = var.region
  resource_group_name = var.rg_name
  address_space       = [var.vpc_cidr_hub]

  tags = var.tags
}

resource "azurerm_subnet" "natgw" {
  name                 = "${var.name}-natgwnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.hub1_natgwvnet.name
  address_prefixes     = [cidrsubnet(var.vpc_cidr_hub, 8, 0)] # Default: 10.20.0.0/24
}

resource "azurerm_subnet" "ingress" {
  name                 = "subnet-1-ingress"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.spoke1_kubevnet.name
  address_prefixes     = [cidrsubnet(var.vpc_cidr_kubevnet, 8, 10)] # Default: 10.10.10.0/24
}

resource "azurerm_subnet" "aks" {
  name                 = "subnet-2-aks"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.spoke1_kubevnet.name
  address_prefixes     = [cidrsubnet(var.vpc_cidr_kubevnet, 8, 20)] # Default: 10.10.20.0/24
}

resource "azurerm_virtual_network_peering" "HubToSpoke1" {
  name                         = "HubToSpoke1"
  resource_group_name          = var.rg_name
  virtual_network_name         = azurerm_virtual_network.hub1_natgwvnet.name
  remote_virtual_network_id    = azurerm_virtual_network.spoke1_kubevnet.id
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "Spoke1ToHub" {
  name                         = "Spoke1ToHub"
  resource_group_name          = var.rg_name
  virtual_network_name         = azurerm_virtual_network.spoke1_kubevnet.name
  remote_virtual_network_id    = azurerm_virtual_network.hub1_natgwvnet.id
  allow_virtual_network_access = true
}

resource "azurerm_public_ip" "natgw" {
  name                = "${var.name}-natgw-publicIP"
  location            = var.region
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip_prefix" "prefix" {
  name                = "${var.name}-natgw-publicIPPrefix"
  location            = var.region
  resource_group_name = var.rg_name
  prefix_length       = 30
}

resource "azurerm_nat_gateway" "natgw" {
  name                    = "${var.name}-natgw"
  location                = var.region
  resource_group_name     = var.rg_name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
}

resource "azurerm_nat_gateway_public_ip_association" "assing" {
  nat_gateway_id       = azurerm_nat_gateway.natgw.id
  public_ip_address_id = azurerm_public_ip.natgw.id
}

resource "azurerm_nat_gateway_public_ip_prefix_association" "assign" {
  nat_gateway_id      = azurerm_nat_gateway.natgw.id
  public_ip_prefix_id = azurerm_public_ip_prefix.prefix.id
}

resource "azurerm_subnet_nat_gateway_association" "attach" {
  nat_gateway_id = azurerm_nat_gateway.natgw.id
  subnet_id      = azurerm_subnet.natgw.id
}

# MS Doku via NAT Gateway
resource "azurerm_route_table" "rt" {
  name                = "${var.name}-routetable"
  location            = var.region
  resource_group_name = var.rg_name

  route {
    name                   = "route1"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_public_ip.natgw.ip_address
  }

  tags = var.tags
}


resource "azurerm_subnet_route_table_association" "rtassoc" {
  subnet_id      = azurerm_subnet.aks.id
  route_table_id = azurerm_route_table.rt.id
}
