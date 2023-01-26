provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "azure-linux-function-rg" {
  name     = "azure-linux-function-rg"
  location = "West Europe"
}

resource "azurerm_storage_account" "azure-function-sa" {
  name                     = "azurefunctionsa123"
  resource_group_name      = azurerm_resource_group.azure-linux-function-rg.name
  location                 = azurerm_resource_group.azure-linux-function-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "azure-function-sp" {
  name                = "azure-function-sp"
  resource_group_name = azurerm_resource_group.azure-linux-function-rg.name
  location            = azurerm_resource_group.azure-linux-function-rg.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "cdt-bff-test" {
  name                = "cdt-bff-test"
  resource_group_name = azurerm_resource_group.azure-linux-function-rg.name
  location            = azurerm_resource_group.azure-linux-function-rg.location

  storage_account_name       = azurerm_storage_account.azure-function-sa.name
  storage_account_access_key = azurerm_storage_account.azure-function-sa.primary_access_key
  service_plan_id            = azurerm_service_plan.azure-function-sp.id

  site_config {
    application_stack {
      node_version = "18"
    }
    cors {
      allowed_origins = ["htttp://localhost:3000"]
    }

    app_service_logs {
      retention_period_days = "30"
    }
    remote_debugging_enabled = true
    remote_debugging_version = "VS2022"
  }

  functions_extension_version = "~4"
  tags = {
    "key" = "value"
  }
  
}
