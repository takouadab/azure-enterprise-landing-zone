# Governance implementation — milestone 1

## Purpose

Implement the Management Group topology designed in the architecture milestone.
This is an intentionally bounded increment: only Management Groups are managed.
All infrastructure platform services and application subscription onboarding
remain future milestones.

## Activation and safeguards

1. Confirm the intended Microsoft Entra tenant and parent Management Group.
2. Verify permission to create Management Groups at the selected parent scope.
3. Make sure the `root_id` prefix is unique within the tenant.
4. Run `terraform init`, `terraform fmt -recursive`, `terraform validate`.
5. Run `terraform plan` with `enable_governance=false` (should propose no resources).
6. Explicitly opt in to `enable_governance=true` to review a prospective plan.
7. Do not apply until the plan and authorization are reviewed.

## Architecture contracts

- Owner: `main-infra` Terraform root; module: `modules/core`.
- State: platform Terraform state, kept separate from `main-bp`.
- Provider: `azurerm` version 4.x with explicit subscription context.
- No `subscription_ids` argument is used on MG resources. Future subscription
  association belongs to `main-bp`, preventing mixed ownership.
- Outputs: management-group IDs/names are the contract for future vending.

## Intentional omissions

Policies, archetypes, custom RBAC, monitoring, three Connectivity modules,
subscription association, Jinja2 templates, and remote state configuration
are not implemented in this first increment.

## Reference documentation

- [Azure Management Groups](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview)
- [Terraform Management Group resource](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group)
- [AzureRM 4.0 upgrade notes](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/4.0-upgrade-guide)
