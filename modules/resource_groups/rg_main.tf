
# Create a Resource Group
resource "azurerm_resource_group" "rg-name" {
  location = var.location
  name     = var.rg-name

  tags = {
    environment = var.environment
    name        = "Resource Group"
  }
}

data "azurerm_resource_group" "rg-name" {
  name = azurerm_resource_group.rg-name.name
}