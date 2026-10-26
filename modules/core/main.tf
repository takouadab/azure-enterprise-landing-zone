provider "azurerm" {
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
  root_parent_id   = data.azurerm_client_config.current.tenant_id
  root_id          = var.root_id
  root_name        = var.root_name
  library_path     = "${path.module}/lib"
  default_location = var.primary_location

  deploy_core_landing_zones = true
  custom_landing_zones      = local.custom_landing_zones

  deploy_identity_resources    = false
  configure_identity_resources = local.configure_identity_resources
  subscription_id_identity     = var.subscription_id_identity

  deploy_connectivity_resources    = false
  configure_connectivity_resources = var.configure_connectivity_resources
  subscription_id_connectivity     = var.subscription_id_connectivity

  deploy_management_resources    = false
  configure_management_resources = var.configure_management_resources
  subscription_id_management     = var.subscription_id_management
  disable_telemetry              = true
  template_file_variables = merge(
    var.template_file_variables,
    { root_id = var.root_id }
  )

  archetype_config_overrides = {
    root = {
      enforcement_mode = {
        "Deploy-ASC-Monitoring"   = false
        "Deploy-MDEndpoints"      = false
        "Deploy-MDEndpointsAMA"   = false
        "Deploy-MDFC-Config-H224" = false
        "Deploy-MDFC-OssDb"       = false
        "Deploy-MDFC-SqlAtp"      = false
        "Deploy-AzActivity-Log"   = false
        "Deploy-Diag-LogsCat"     = false
      }
    }

    platform = {
      enforcement_mode = {
        "Deploy-MDFC-DefSQL-AMA"   = false
        "Deploy-VM-ChangeTrack"    = false
        "Deploy-VM-Monitoring"     = false
        "Deploy-VMSS-ChangeTrack"  = false
        "Deploy-VMSS-Monitoring"   = false
        "Deploy-vmArc-ChangeTrack" = false
        "Deploy-vmHybr-Monitoring" = false
        "Enable-AUM-CheckUpdates"  = false
      }
    }

    landing-zones = {
      enforcement_mode = {
        "Enable-DDoS-VNET"         = false
        "Deploy-MDFC-DefSQL-AMA"   = false
        "Deploy-AzSqlDb-Auditing"  = false
        "Deploy-SQL-TDE"           = false
        "Deploy-SQL-Threat"        = false
        "Deploy-VM-Backup"         = false
        "Deploy-VM-ChangeTrack"    = false
        "Deploy-VM-Monitoring"     = false
        "Deploy-VMSS-ChangeTrack"  = false
        "Deploy-VMSS-Monitoring"   = false
        "Deploy-vmArc-ChangeTrack" = false
        "Deploy-vmHybr-Monitoring" = false
        "Enable-AUM-CheckUpdates"  = false
      }
      parameters = {
        "Deny-Priv-Esc-AKS" = {
          effect = "Deny"
        }

        "Enforce-AKS-HTTPS" = {
          effect = "Deny"
        }
      }
    }

    connectivity = {
      enforcement_mode = {
        "Enable-DDoS-VNET" = false
      }
    }
  }
}
