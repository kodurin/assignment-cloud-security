
# Create a VNet
resource "azurerm_virtual_network" "vnet1" {
  name                = "vnet1"
  location            = var.location
  resource_group_name = var.rg-name
  address_space       = var.vnet1-address-space

  tags = {
    environment = var.environment
    "Network"   = "vnet1"
  }
}

# Create a Subnet
resource "azurerm_subnet" "vnet1-subnet1" {
  name                 = "vnet1-subnet1"
  resource_group_name  = var.rg-name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = var.vnet1-subnet1-address
  service_endpoints = ["Microsoft.Web"]
}

# Create a NIC for win-vm
resource "azurerm_network_interface" "win-vm-PrivIP-nic" {
  location            = var.location
  name                = "win-vm-PrivIP-nic"
  resource_group_name = var.rg-name
  ip_configuration {
    name      = "win-vm-PrivIP-nic-ipConfig"
    subnet_id = azurerm_subnet.vnet1-subnet1.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = {
    environment = var.environment
  }
}