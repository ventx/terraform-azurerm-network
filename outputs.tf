output "spoke1_kubevnet_vpc_cidr" {
  value = var.vpc_cidr_kubevnet
}

output "hub1_natgwvnet_vpc_cidr" {
  value = var.vpc_cidr_kubevnet
}
output "spoke1_kubevnet_network_name" {
  value = azurerm_virtual_network.spoke1_kubevnet.name
}

output "spoke1_kubevnet_address_space" {
  value = azurerm_virtual_network.spoke1_kubevnet.address_space
}

output "hub1_natgwvnet_network_name" {
  value = azurerm_virtual_network.hub1_natgwvnet.name
}

output "hub1_natgwvnet_address_space" {
  value = azurerm_virtual_network.hub1_natgwvnet.address_space
}

output "natgw_subnet_id" {
  description = "natgw (NAT Gatway) - Ingress Subnet ID"
  value       = azurerm_subnet.natgw.id
}

output "natgw_subnet_address_prefixes" {
  description = "natgw Subnet address prefixes"
  value       = azurerm_subnet.natgw.address_prefixes
}

output "ingress_subnet_id" {
  description = "Subnet 1 - Ingress Subnet ID"
  value       = azurerm_subnet.ingress.id
}

output "ingress_subnet_address_prefixes" {
  description = "Subnet 1 - Ingress address prefixes"
  value       = azurerm_subnet.ingress.address_prefixes
}

output "aks_subnet_id" {
  description = "Subnet 2 - AKS Subnet ID"
  value       = azurerm_subnet.aks.id
}

output "aks_subnet_address_prefixes" {
  description = "Subnet 2 - AKS address prefixes"
  value       = azurerm_subnet.aks.address_prefixes
}

output "natgw_public_ip_address" {
  description = "natgw - Public IP address"
  value       = azurerm_public_ip.natgw.ip_address
}

output "natgw_public_ip_prefix" {
  description = "natgw - Public IP Prefix"
  value       = azurerm_public_ip_prefix.prefix.ip_prefix
}
