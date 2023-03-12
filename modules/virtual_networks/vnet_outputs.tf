
output "tf_vnet1_id" {
  value = azurerm_virtual_network.vnet1.id
}
output "tf_vnet1_name" {
  value = azurerm_virtual_network.vnet1.name
}

output "subnet_with_win-vm_id" {
  value = azurerm_subnet.vnet1-subnet1.id
}

output "win-vm_nic_id" {
  value = azurerm_network_interface.win-vm-PrivIP-nic.id
}

