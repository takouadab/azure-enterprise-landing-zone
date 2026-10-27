terraform {
  # Independent local state. Do not commit state files to Git.
  backend "local" {
    path = "../.local-state/main-bp/terraform.tfstate"
  }
}
