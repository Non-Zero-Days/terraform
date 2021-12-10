terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "nonzero" {
  name     = "rg-non-zero-packages"
  location = "West US 2"
}

resource "azurerm_app_service_plan" "nonzero" {
  name                = "sp-non-zero-packages"
  location            = azurerm_resource_group.nonzero.location
  resource_group_name = azurerm_resource_group.nonzero.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Free"
    size = "F1"
  }
}

resource "azurerm_app_service" "nonzero" {
  name                = "app-non-zero-packages"
  location            = azurerm_resource_group.nonzero.location
  resource_group_name = azurerm_resource_group.nonzero.name
  app_service_plan_id = azurerm_app_service_plan.nonzero.id

  site_config {
    linux_fx_version          = "DOCKER|ghcr.io/boredtweak/non-zero-packages:latest"
    use_32_bit_worker_process = true
  }

  app_settings = {
    "NON_ZERO_VALUE" = "day"
  }
}
