variable "root_id" {
  description = "Management group prefix shared with main-infra."
  type        = string
}

variable "primary_location" {
  description = "Azure location (for example francecentral)."
  type        = string
}

variable "subscription_id_connectivity" {
  description = "Existing platform Connectivity subscription. Must never be onboarded by vending."
  type        = string
}

variable "subscription_id_management" {
  description = "Existing platform Management subscription. Must never be onboarded by vending."
  type        = string
}

variable "read_management_workspace" {
  description = "Read the existing management workspace when optional integrations need it."
  type        = bool
  default     = false
}
