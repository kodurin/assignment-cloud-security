#Azure Function create
#Storage Account for app function
resource "azurerm_storage_account" "storage1" {
    name = "pyappstorage"
    resource_group_name = var.rg-name
    location = var.location
    account_tier = "Standard"
    account_replication_type = "LRS"
}

#Service plan
resource "azurerm_service_plan" "svc-paln" {
    name = "svc-plan"
    resource_group_name = var.rg-name
    location = var.location
    os_type = "Linux"
    sku_name = "EP1"
    worker_count = 1
  
}

#Applcation insights
resource "azurerm_application_insights" "insights1" {
  name = "insights1"
  resource_group_name = var.rg-name
    location = var.location
  application_type = "web"
  
}

# Function
resource "azurerm_linux_function_app" "app1" {
    name = "py-app"
    resource_group_name = var.rg-name
    location = var.location
    storage_account_name = azurerm_storage_account.storage1.name
    storage_account_access_key = azurerm_storage_account.storage1.primary_access_key
    service_plan_id = azurerm_service_plan.svc-paln.id
    https_only = true
    app_settings = {
      WEBSITES_ENABLE_APP_SERVICE_STORAGE = false
    }
    
    site_config {
      application_insights_key = azurerm_application_insights.insights1.instrumentation_key
      application_insights_connection_string = azurerm_application_insights.insights1.connection_string
      application_stack {
        python_version = "3.9"
      }
    
      ip_restriction {
        name = "vmonly"
        virtual_network_subnet_id = var.subnet_with_win-vm_id
        action = "Allow"
        priority = "100"
      }
      scm_ip_restriction {
        name = "all"
        ip_address = "0.0.0.0/0"
        action = "Allow"
        priority = "1000"
      }
    }

}

# resource "azurerm_function_app_function" "pyapp" {
#   name            = "pyapp-function-app-function"
#   function_app_id = azurerm_linux_function_app.app1.id
#   language        = "Python"
#   test_data = jsonencode({
#     "name" = "Azure"
#   })
  
#   config_json = jsonencode({
#     "bindings" = [
#       {
#         "authLevel" = "function"
#         "direction" = "in"
#         "methods" = [
#           "get",
#           "post",
#         ]
#         "name" = "req"
#         "type" = "httpTrigger"
#       },
#       {
#         "direction" = "out"
#         "name"      = "$return"
#         "type"      = "http"
#       },
#     ]
#   })
# }