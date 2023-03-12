subscription_id          = ""
tenant_id                = ""
client_id                = ""
client_secret            = ""
location                 = "UK South"
environment              = "Dev"
rg-name                  = "cloud-security"
vnet1-address-space      = ["10.100.0.0/16"]
vnet1-subnet1-address    = ["10.100.0.0/24"]
azbastion-subnet-address = ["10.100.1.0/26"]
azb_scl_units            = 2

firewall_allocation_method = "Static" 
firewall_sku               = "Standard"