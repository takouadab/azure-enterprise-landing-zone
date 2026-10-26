# Pass through the native CAF Enterprise Scale management group output.
output "azurerm_management_group" {
  description = "Management Groups managed by CAF Enterprise Scale in the Core module."
  value       = module.core.azurerm_management_group
}
