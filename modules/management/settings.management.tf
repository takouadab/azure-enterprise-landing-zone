locals {
  configure_management_resources = {
    settings = {
      ama = {
        enable_uami                                                         = true
        enable_vminsights_dcr                                               = false
        enable_change_tracking_dcr                                          = false
        enable_mdfc_defender_for_sql_dcr                                    = false
        enable_mdfc_defender_for_sql_query_collection_for_security_research = false
      }
      log_analytics = {
        enabled = true
        config = {
          retention_in_days                      = var.log_retention_in_days
          enable_monitoring_for_vm               = false
          enable_monitoring_for_vmss             = false
          enable_sentinel                        = false
          enable_change_tracking                 = false
          enable_solution_for_container_insights = false
        }
      }
      security_center = {
        enabled = false
        config = {
          email_security_contact                                = var.email_security_contact
          enable_defender_for_apis                              = false
          enable_defender_for_app_services                      = false
          enable_defender_for_arm                               = false
          enable_defender_for_containers                        = false
          enable_defender_for_cosmosdb                          = false
          enable_defender_for_cspm                              = false
          enable_defender_for_dns                               = false
          enable_defender_for_key_vault                         = false
          enable_defender_for_oss_databases                     = false
          enable_defender_for_servers                           = false
          enable_defender_for_servers_vulnerability_assessments = false
          enable_defender_for_sql_servers                       = false
          enable_defender_for_sql_server_vms                    = false
          enable_defender_for_storage                           = false
        }
      }
    }
    location = var.primary_location
    tags     = var.management_resources_tags
    advanced = {
      asc_export_resource_group_name = "${var.root_id}-security-logs-export"
    }
  }
}
