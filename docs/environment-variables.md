# Environment variable contract

This repository expects the operator to supply variable values. It does not interact with Vault or provision secrets.

## Scope

- **Current Terraform root:** `main-infra/variables.tf` declares 12 required `TF_VAR_*` values.
- **Jinja2 renderer:** `scripts/render_infra.py` reads the nine `TF_VAR_{xp,appbuild,apprun}_hub_{network,bastion,firewall}` JSON values. The wrapper JSON property names must match exactly.
- **Planned application root:** the six `*_subscriptions` and `*_spoke_networks` objects mirror the source configuration shapes, but are **not active inputs** until `main-bp` is implemented.
- **Future/integration keys:** `log_analytics_workspace_id`, `billing_*`, and `bastion_*_user_object_ids` are documented but not wired in the current Terraform code.

## Local use on macOS

```bash
cp env/azure-alz.env.example env/azure-alz.env
chmod 600 env/azure-alz.env
# Edit locally and replace all <PLACEHOLDER> values.
source env/azure-alz.env
```

Do not commit `env/azure-alz.env`. The checked-in file contains placeholders only. Never print real secrets in CI logs.

To inspect the **variable names only** without printing their values:

```bash
env | cut -d= -f1 | grep -E '^(TF_VAR_|ARM_|TF_HTTP_)' | sort
```

## Policies and RBAC design

**CAF Enterprise Scale v6.2.1** supplies built-in archetypes, Policy Definitions, Policy Assignments, and role-related artifacts as part of its `deploy_core_landing_zones = true` deployment. Custom child Management Groups currently use `default_empty` explicitly so the core built-in assignments can be inherited from their parent group and are not duplicated across children. Do not assume a custom group has a separately assigned policy merely because it inherits one.

**ALZ Vending v5.1.2** handles subscription-related role assignments using `role_assignment_enabled` and `role_assignments`. It does not replace CAF governance or auto-select appropriate RBAC principals. When `main-bp` is implemented, use Azure built-in role definition names and operator-provided Entra principal IDs; do not generate custom roles for the sake of populating the module.

No new Policy Definitions or custom Role Definitions are included in this patch. An actual RBAC assignment needs a real principal and scope to be meaningful.

## Preconditions

Do not run `terraform apply` using unresolved placeholders or without a functional HTTP backend. The current `main-infra` code has not been validated against a live Azure tenant; some module interfaces and generated settings still need Terraform initialization and validation.

## Authoritative references

- [Terraform input environment variables](https://developer.hashicorp.com/terraform/language/values/variables)
- [Terraform HTTP backend variables](https://developer.hashicorp.com/terraform/language/backend/http)
- [CAF Enterprise Scale v6.2.1](https://registry.terraform.io/modules/Azure/caf-enterprise-scale/azurerm/6.2.1)
- [ALZ Vending v5.1.2](https://registry.terraform.io/modules/Azure/lz-vending/azurerm/5.1.2)
