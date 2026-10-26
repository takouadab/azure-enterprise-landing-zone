# Platform Terraform root (`main-infra`)

This root orchestrates **five distinct Azure Landing Zones Enterprise Scale module instances**. It intentionally does **not** replace Enterprise Scale with ad-hoc resources.

## Exact logical contract

- `connectivity_xp` -> `../modules/connectivity-xp` -> `root_id = <root>-xp`
- `connectivity_appbuild` -> `../modules/connectivity-appbuild` -> `root_id = <root>-appbuild`
- `connectivity_apprun` -> `../modules/connectivity-apprun` -> `root_id = <root>-apprun`
- `management` -> `../modules/management`
- `core` -> `../modules/core`

All three connectivity instances use **the same** `subscription_id_connectivity` input. In this architecture, **only** the XP connectivity module's `configuration` is passed to the core module for policies; `core` also receives the management module's `configuration`. The AppBuild and AppRun instances deploy their own connectivity resources, but are not passed as `configure_connectivity_resources` to core.

The HTTP backend is intentionally unconfigured; you must supply its full address, credentials, locking configuration and state-name separation. No secrets or `*.tfvars` are part of this repository. Environment variables are owned by the operator.

## Implementation boundaries

The Enterprise Scale wrappers, the platform root call graph and the custom Management Group tree are included. The custom policy library and complete application subscription vending templates are **not** included yet. The complete project must not be applied until those are implemented and reviewed. Run the supplied static checks first; running `terraform init` would need accessible registry providers and an operator-configured HTTP backend.
