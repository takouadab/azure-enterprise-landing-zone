terraform {
  backend "local" {
    path = "../.local-state/main-infra/terraform.tfstate"
  }
}