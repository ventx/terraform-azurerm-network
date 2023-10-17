variable "workspace_name" {
  description = "Unique Workspace Name for tagging"
  type        = string
  default     = "stackx--168ca07b-927e-4350-8ad7-c8d87e6b511e_a9e968df-0b16-4a73-a093-98d18a4b904f"
}

variable "project_name" {
  description = "Project Name"
  type        = string
  default     = "stackx"
}

variable "region" {
  description = "Region"
  type        = string
  default     = "Germany West Central"
}


variable "tags" {
  default = {
    "owner"     = "terraform-azurerm-network",
    "managedby" = "terraform",
    "project"   = "stackx",
  }
}
