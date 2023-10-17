provider "azurerm" {
  features {}
}

variables {
  name           = "terraform-test"
  rg_name        = "terraform-test"
  workspace_name = "tfest--168ca07b-927e-4350-8ad7-c8d87e6b511e_a9e968df-0b16-4a73-a093-98d18a4b904f"
  project_name   = "tftest"
  region         = "North Central US"

  tags = {
    "owner"     = "terraform-azurerm-network",
    "managedby" = "terraform-test",
    "project"   = "stackx",
    "workspace" = "terraform-test"
  }
}

run "valid_config" {

  command = plan

  assert {
    condition     = azurerm_virtual_network.spoke1_kubevnet.address_space.0 == "10.10.0.0/16"
    error_message = "Virtual Network address space CIDR did not match expected"
  }

  assert {
    condition     = azurerm_subnet.ingress.name == "subnet-1-ingress"
    error_message = "Subnet ingress name did not match expected"
  }
}

#run "execute" {
#  # Test apply configuration
#}
