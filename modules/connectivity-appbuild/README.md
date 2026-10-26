# Connectivity APPBUILD

An independent instance of `Azure/caf-enterprise-scale/azurerm` v6.2.1 (matching the source module declarations). The instance deploys **connectivity only** and exposes `configuration` for core policy configuration. The three domains share the same connectivity subscription ID, but use distinct `root_id` suffixes.

`settings.connectivity.tf.j2` and `settings.bastion.tf.j2` represent the main templated infrastructure configuration. Generated files must be created from environment-provided network settings before Terraform can be validated. No config is guessed in Terraform files.

**Limitation of this increment:** detailed firewall rules and the full private DNS service flags are not reconstructed here. They require an approved rule-collection specification and an independent review before deployment. Do not apply this increment.
