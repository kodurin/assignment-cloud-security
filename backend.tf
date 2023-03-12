
# terraform {
#   backend "azurerm" {
#     resource_group_name  = "cloudsec-tfstatefiles"
#     storage_account_name = "cloudsec-tfstatesacnt"
#     container_name       = "cloudsec-tfstate-container"
#     key                  = "CloudSec.terraform.tfstate"
#     use_azuread_auth     = true
#     subscription_id      = ""
#     tenant_id            = ""
#   }
# }