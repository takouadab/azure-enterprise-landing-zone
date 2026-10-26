CAF Enterprise Scale outputs fix

Copy these files over the existing files in your project:
  modules/core/outputs.tf
  main-infra/outputs.tf

This removes the obsolete references to standalone azurerm_management_group.*
resources from the earlier governance prototype. It does NOT create or destroy
resources. The native CAF output azurerm_management_group contains level_1 through
level_6 maps, as documented by the official CAF Enterprise Scale module.

After copying:
  terraform fmt -recursive
  terraform -chdir=main-infra validate

Review future terraform plan output before any apply. No provider/backend changes
are included.
