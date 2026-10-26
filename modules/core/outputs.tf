# Expose the management group resources managed by the CAF Enterprise Scale
# module, instead of referencing standalone azurerm_management_group resources.
output "azurerm_management_group" {
  description = "Management Groups managed by the CAF Enterprise Scale module, grouped by hierarchy level."
  value       = module.alz.azurerm_management_group
}
