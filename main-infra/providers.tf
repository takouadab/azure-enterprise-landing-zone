provider "azurerm" {
  features {}

  # AzureRM 4.x requires an explicit subscription ID.
  # The operator supplies the corresponding TF_VAR_* value externally.
  subscription_id = var.subscription_id_connectivity
}
