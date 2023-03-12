
resource "time_sleep" "wait_30_seconds" {
  create_duration = "30s"
}

# # module resource_groups is used to build Resource Group
module "resource_groups" {
  source      = "./modules/resource_groups"
  location    = var.location
  rg-name     = var.rg-name
  environment = var.environment
  depends_on = [
    time_sleep.wait_30_seconds
  ]
}

# # module virtual_networks is used for creating vnets in Resource Group 
module "virtual_networks" {
  source                     = "./modules/virtual_networks"
  location                   = var.location
  environment                = var.environment
  rg-name                    = module.resource_groups.rg-name
  firewall_allocation_method = var.firewall_allocation_method
  firewall_sku               = var.firewall_sku
  vnet1-address-space        = var.vnet1-address-space
  vnet1-subnet1-address      = var.vnet1-subnet1-address
  depends_on                 = [module.resource_groups, time_sleep.wait_30_seconds]
}

# #  module az_bastion setup the Azure bastion Host 
module "az_bastion" {
  source                     = "./modules/az_bastion"
  location                   = var.location
  environment                = var.environment
  rg-name                    = module.resource_groups.rg-name
  firewall_allocation_method = var.firewall_allocation_method
  firewall_sku               = var.firewall_sku
  tf_vnet1_name              = module.virtual_networks.tf_vnet1_name
  vnet1-address-space        = var.vnet1-address-space
  azbastion-subnet-address   = var.azbastion-subnet-address
  azb_scl_units              = var.azb_scl_units
  depends_on                 = [module.resource_groups, module.virtual_networks, time_sleep.wait_30_seconds]
}


# #  module vm is used for creating Virtual Machines in the RG
module "vm" {
  source              = "./modules/vm"
  location            = var.location
  environment         = var.environment
  rg-name             = module.resource_groups.rg-name
  win-vm_nic_id     = module.virtual_networks.win-vm_nic_id
  final_win-vm_pswd = module.az_key_vault.final_win-vm_pswd
  depends_on          = [module.virtual_networks, module.az_key_vault, time_sleep.wait_30_seconds]
}

# #  module traffic_rules is used for setting up different NSGs/Security Rules to control the traffic flow 
module "traffic_rules" {
  source                   = "./modules/traffic_rules"
  location                 = var.location
  environment              = var.environment
  rg-name                  = module.resource_groups.rg-name
  AzureBastionSubnet-id    = module.az_bastion.AzureBastionSubnet-id
  subnet_with_win-vm_id  = module.virtual_networks.subnet_with_win-vm_id
  win-vm_nic_id          = module.virtual_networks.win-vm_nic_id
  azbastion-subnet-address = var.azbastion-subnet-address
  depends_on               = [module.resource_groups, module.vm, module.virtual_networks, module.az_bastion, time_sleep.wait_30_seconds]
}

# #  module for Azure Key Vault 
module "az_key_vault" {
  source      = "./modules/az_key_vault"
  location    = var.location
  environment = var.environment
  rg-name     = module.resource_groups.rg-name
  depends_on  = [module.resource_groups, time_sleep.wait_30_seconds]
}

# # module for Azure functions app
module "az_functions" {
  source                  = "./modules/az_functions"
  location                = var.location
  rg-name                 = module.resource_groups.rg-name
  subnet_with_win-vm_id = module.virtual_networks.subnet_with_win-vm_id
  environment             = var.environment
  depends_on              = [module.resource_groups, module.virtual_networks, time_sleep.wait_30_seconds]

}
