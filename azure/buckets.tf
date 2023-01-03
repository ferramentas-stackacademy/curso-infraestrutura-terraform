resource "azurerm_resource_group" "example" {
  name     = "terraform-course"
  location = "East US"
}

resource "azurerm_storage_account" "example" {
  name                     = "terraformcourse20122024"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "staging"
  }
}

resource "azurerm_storage_container" "example" {
  count  = length(var.containers)
  name                  = "${var.containers[count.index]}"
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "private"
}