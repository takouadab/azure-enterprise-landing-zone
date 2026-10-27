# Matches the management workspace dependency in Pulsar.
# Disabled for the empty-subscription baseline; turn on only when used.
data "azurerm_log_analytics_workspace" "management" {
  count               = var.read_management_workspace ? 1 : 0
  provider            = azurerm.management
  name                = "${var.root_id}-la"
  resource_group_name = "${var.root_id}-mgmt"
}
