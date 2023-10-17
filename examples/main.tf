resource "azurerm_resource_group" "rg" {
  // The maximum length is 80. Please see https://aka.ms/aks-naming-rules
  name     = substr(lower(trimspace((var.workspace_name))), 0, 79)
  location = var.region

  tags = {
    "owner"     = "terraform-azurerm-network",
    "managedby" = "terratest",
    "project"   = "stackx",
    "workspace" = substr(lower(trimspace(var.workspace_name)), 0, 62)
  }
}

# --------------------------------------------------------------------------
# Virtual Network
# --------------------------------------------------------------------------
module "test_network" {
  source = "../"

  name = "${lower(trimspace((var.project_name)))}-testnetwork"
  tags = {
    "owner"     = "terraform-azurerm-network",
    "managedby" = "terratest",
    "project"   = "stackx",
    "workspace" = substr(lower(trimspace(var.workspace_name)), 0, 62)
  }
  rg_name = azurerm_resource_group.rg.name
}
