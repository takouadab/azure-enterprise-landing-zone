# Implementation status

| Component | Included now | Not yet reconstructed |
|---|---|---|
| Platform root | Exact five-module orchestration and subscription/region interfaces | Runnable backend configuration supplied by operator |
| Core | ALZ v6.2.1, default governance, correct custom Management Group hierarchy | Custom policy/role definitions and archetypes |
| Management | ALZ v6.2.1 with basic Log Analytics/Defender settings | Additional diagnostic settings |
| Connectivity XP/AppBuild/AppRun | Three ALZ v6.2.1 wrappers; templates for hubs and optional Bastion | Full DNS flags, Firewall rule collections and complete Terraform provider validation |
| Application root | Architecture reserved | Subscription vending/Jinja2 and provider alias generation |
| Remote state | `http` backend type in platform root | Address, locking and credentials provided externally |

No Azure resources have been deployed or tested. Treat these files as an implementation **increment under review**, not a production-ready landing zone. The deployment must wait until all templates/configuration and policy inputs are complete and the full Terraform plan has been reviewed.

## Architecture invariants

- No Terraform `azurerm_management_group` resources directly coded in `core`.
- Each specialist invokes `Azure/caf-enterprise-scale/azurerm` **v6.2.1**.
- Core receives **XP connectivity only**, and Management config.
- The same Connectivity subscription ID feeds all XP/AppBuild/AppRun configurations.
- Core owns Management Group creation; specialist instances set `deploy_core_landing_zones = false`.
- All existing authentication and `TF_VAR_*` inputs remain operator-owned and outside this repository.

## Legacy upstream risk

The CAF Enterprise Scale module was archived in September 2026. It remains pinned solely to reproduce the architecture; it is **not recommended for new production infrastructure**. See [upstream README](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale). Any later modernization to Azure Verified Modules must be a separate documented decision, not a silent substitution.

## Local template rendering (no secrets integration)

`make gen` reads these already-exported JSON environment variables: `TF_VAR_xp_hub_network`, `TF_VAR_xp_hub_bastion`, `TF_VAR_xp_hub_firewall`, and the analogous AppBuild/AppRun variables. The operator owns their contents and export mechanism. The Jinja2 dependency is a local Python package (`python3 -m pip install Jinja2` if needed). The renderer validates key shapes and refuses missing data. Rendered `.tf` files are ignored by Git. No secret file or fake network addresses are generated.

To check source wiring without Terraform or Azure credentials: `make check`. For full provider/schema validation in a future increment, dependencies and the backend must first be configured.

## Local template rendering (no secrets integration)

`make gen` reads these already-exported JSON environment variables: `TF_VAR_xp_hub_network`, `TF_VAR_xp_hub_bastion`, `TF_VAR_xp_hub_firewall`, and the analogous AppBuild/AppRun variables. The operator owns their contents and export mechanism. The Jinja2 dependency is a local Python package (`python3 -m pip install Jinja2` if needed). The renderer validates key shapes and refuses missing data. Rendered `.tf` files are ignored by Git. No secret file or fake network addresses are generated.

To check source wiring without Terraform or Azure credentials: `make check`. For full provider/schema validation in a future increment, dependencies and the backend must first be configured.

## Local template rendering (no secrets integration)

`make gen` reads these already-exported JSON environment variables: `TF_VAR_xp_hub_network`, `TF_VAR_xp_hub_bastion`, `TF_VAR_xp_hub_firewall`, and the analogous AppBuild/AppRun variables. The operator owns their contents and export mechanism. The Jinja2 dependency is a local Python package (`python3 -m pip install Jinja2` if needed). The renderer validates key shapes and refuses missing data. Rendered `.tf` files are ignored by Git. No secret file or fake network addresses are generated.

To check source wiring without Terraform or Azure credentials: `make check`. For full provider/schema validation in a future increment, dependencies and the backend must first be configured.
