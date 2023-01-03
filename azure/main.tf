# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  subscription_id = "40895942-0e3d-4cfe-ab1e-fe941928960f"
  tenant_id       = "03db58c7-f425-4df3-9d35-3caf5ceb70d0"
}