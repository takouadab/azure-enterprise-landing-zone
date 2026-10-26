# Independent Management Group names and built-in empty archetypes until
# custom organization-specific policy/role templates have been completed.
locals {
  custom_landing_zones = {
    "${var.root_id}-application" = {
      display_name               = "${upper(var.root_id)} Application"
      parent_management_group_id = "${var.root_id}-landing-zones"
      subscription_ids           = []
      archetype_config = {
        archetype_id   = "default_empty"
        parameters     = {}
        access_control = {}
      }
    }
    "${var.root_id}-appbuild" = {
      display_name               = "${upper(var.root_id)} Application Build"
      parent_management_group_id = "${var.root_id}-application"
      subscription_ids           = []
      archetype_config = {
        archetype_id   = "default_empty"
        parameters     = {}
        access_control = {}
      }
    }
    "${var.root_id}-apprun" = {
      display_name               = "${upper(var.root_id)} Application Run"
      parent_management_group_id = "${var.root_id}-application"
      subscription_ids           = []
      archetype_config = {
        archetype_id   = "default_empty"
        parameters     = {}
        access_control = {}
      }
    }
    "${var.root_id}-experimentation" = {
      display_name               = "${upper(var.root_id)} Experimentation"
      parent_management_group_id = "${var.root_id}-landing-zones"
      subscription_ids           = []
      archetype_config = {
        archetype_id   = "default_empty"
        parameters     = {}
        access_control = {}
      }
    }
  }
}
