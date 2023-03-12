
resource "azurerm_windows_virtual_machine" "win-vm1" {
  admin_username                  = "adminuser"
  admin_password                  = var.final_win-vm_pswd 
  location                        = var.location
  name                            = "win-vm1"
  network_interface_ids = [
    var.win-vm_nic_id
  ]
  resource_group_name = var.rg-name
  size                = "Standard_F2"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  tags = {
    environment = var.environment
  }
}