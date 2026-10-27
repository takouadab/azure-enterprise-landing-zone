# Platform subscriptions are used only for data access and hub peering.
# Do not onboard them as application subscriptions.
provider "azurerm" {
  features {}
  subscription_id                 = var.subscription_id_connectivity
  resource_provider_registrations = "none"
}

provider "azurerm" {
  alias = "connectivity"
  features {}
  subscription_id                 = var.subscription_id_connectivity
  resource_provider_registrations = "none"
}

provider "azurerm" {
  alias = "management"
  features {}
  subscription_id                 = var.subscription_id_management
  resource_provider_registrations = "none"
}

provider "azapi" {
  subscription_id = var.subscription_id_connectivity
}
