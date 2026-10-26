provider "azurerm" {
  subscription_id = var.subscription_id_management
  features {}
}

data "azurerm_client_config" "current" {}

module "alz" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "6.2.1"
  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm
    azurerm.management   = azurerm
  }
  root_parent_id                 = data.azurerm_client_config.current.tenant_id
  root_id                        = var.root_id
  default_location               = var.primary_location
  deploy_core_landing_zones      = false
  deploy_management_resources    = true
  configure_management_resources = local.configure_management_resources
  subscription_id_management     = var.subscription_id_management
  disable_telemetry              = true
}
