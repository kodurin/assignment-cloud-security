
output "win_vm_username" {
  value = azurerm_windows_virtual_machine.win-vm1.admin_username
}

output "win-vm_private_ip_nw_interface_id" {
  value = azurerm_windows_virtual_machine.win-vm1
}