provider "azuread" {}

# Separate, independently deployed Enterprise Scale instances.
module "connectivity_xp" {
  source = "../modules/connectivity-xp"

  connectivity_resources_tags  = var.connectivity_resources_tags
  enable_ddos_protection       = var.enable_ddos_protection
  primary_location             = var.primary_location
  root_id                      = "${var.root_id}-xp"
  secondary_location           = var.secondary_location
  subscription_id_connectivity = var.subscription_id_connectivity
}

module "connectivity_appbuild" {
  source = "../modules/connectivity-appbuild"

  connectivity_resources_tags  = var.connectivity_resources_tags
  enable_ddos_protection       = var.enable_ddos_protection
  primary_location             = var.primary_location
  root_id                      = "${var.root_id}-appbuild"
  secondary_location           = var.secondary_location
  subscription_id_connectivity = var.subscription_id_connectivity
}

module "connectivity_apprun" {
  source = "../modules/connectivity-apprun"

  connectivity_resources_tags  = var.connectivity_resources_tags
  enable_ddos_protection       = var.enable_ddos_protection
  primary_location             = var.primary_location
  root_id                      = "${var.root_id}-apprun"
  secondary_location           = var.secondary_location
  subscription_id_connectivity = var.subscription_id_connectivity
}

module "management" {
  source = "../modules/management"

  email_security_contact     = var.email_security_contact
  log_retention_in_days      = var.log_retention_in_days
  management_resources_tags  = var.management_resources_tags
  primary_location           = var.primary_location
  root_id                    = var.root_id
  subscription_id_management = var.subscription_id_management
}

module "core" {
  source = "../modules/core"

  configure_connectivity_resources = module.connectivity_xp.configuration
  configure_management_resources   = module.management.configuration
  primary_location                 = var.primary_location
  root_id                          = var.root_id
  root_name                        = var.root_name
  secondary_location               = var.secondary_location
  subscription_id_connectivity     = var.subscription_id_connectivity
  subscription_id_identity         = var.subscription_id_identity
  subscription_id_management       = var.subscription_id_management
  template_file_variables = {
    subscription_id_connectivity = var.subscription_id_connectivity
    subscription_id_identity     = var.subscription_id_identity
    subscription_id_management   = var.subscription_id_management
  }
}
