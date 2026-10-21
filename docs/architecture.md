# Architecture specification

## 1. Objective

Create a reusable Azure landing-zone foundation for multiple workload groups. Shared platform services and per-subscription application configuration are managed as independent deployment scopes.

## 2. Target Azure hierarchy

At tenant scope, a dedicated Management Group root owns `platform` and `landing-zones` children, plus optional `sandbox` and `decommissioned` groups. Under `platform`: `management`, `connectivity`, and `identity` (reserved; no identity Terraform module in the initial release). Under `landing-zones`: `experimentation` and `application`; `application` owns `appbuild` and `apprun`.

This hierarchy is a **new project naming model**, not a declaration about any existing Azure tenant. Management Groups are not equivalent to resource groups or subscriptions.

## 3. Deployment roots

### `main-infra` — platform foundation

Owns calls to:

1. `modules/connectivity-xp` — XP hub, optional Bastion and Firewall.
2. `modules/connectivity-appbuild` — AppBuild hub, optional Bastion and Firewall.
3. `modules/connectivity-apprun` — AppRun hub, optional Bastion and Firewall.
4. `modules/management` — monitoring and security services.
5. `modules/core` — hierarchy, policy assignments, role definitions and subscription governance.

Terraform graph ordering must follow actual references and outputs; module listing order does not imply deployment order. Governance may need bootstrap permissions before the rest of the platform can be managed.

### `main-bp` — application subscription onboarding

Registers pre-existing application subscriptions, associates them with the correct Management Group, and provisions configurable spoke networks and peerings for enabled workloads. Subscription **creation** is not in the initial target scope: onboarding does not automatically mean billing-account vending.

Cross-root integration uses **explicit published platform outputs** or data-source lookups; it does not refer to `module.*` objects in another Terraform root. Each root owns its own Terraform state.

## 4. Module responsibilities

| Module | Responsible for | Excludes |
|---|---|---|
| `core` | MG hierarchy, policy, RBAC, assignment baselines | Hub/spoke network resources |
| `management` | Log Analytics, diagnostics baseline, selected security settings | Application compute |
| `connectivity-xp` | XP hub and its optional perimeter services | XP application subscriptions |
| `connectivity-appbuild` | AppBuild hub and its optional perimeter services | Build pipelines and workloads |
| `connectivity-apprun` | AppRun hub and its optional perimeter services | Runtime applications |
| `main-bp` | Existing subscription registration, workload spokes, peering, optional routes | Central governance definitions |

## 5. Subscription model

| Subscription role | Purpose | Requirement |
|---|---|---|
| Connectivity | Hosts three segregated hub networks | One accessible subscription for target platform |
| Management | Shared observability and security | Separate subscription in full design |
| XP | Experiments and lab workloads | Zero or more subscriptions |
| AppBuild | Application build services | Zero or more subscriptions |
| AppRun | Runtime workloads | Zero or more subscriptions |

A smaller proof of concept may reuse a subscription for limited evaluation, but it will **not** be represented as the full multi-subscription architecture.

## 6. Governance and operational controls

- Consistent tags for environment, owner, cost center, and lifecycle.
- Policy initiatives applied at appropriate Management Group scopes, with documented exemptions.
- Least-privilege role assignments and no committed credentials.
- Resource diagnostics routed to approved monitoring destinations when supported.
- A cost estimate and explicit approval before activating paid services.

## 7. State and execution boundary

Two independent Terraform states: `platform` and `application-onboarding`. Backend selection is deferred to implementation and will require encryption, controlled access, and locking. The operator supplies all environment variables externally. Deployment automation will not be designed until Terraform module contracts are defined.

## 8. Dependencies and order

1. Verify tenant access, subscription inventory, Management Group privileges and region choices.
2. Establish governance hierarchy and baseline roles/policies.
3. Provision shared management and connectivity foundations.
4. Publish verified hub IDs and addressing outputs.
5. Register application subscriptions and configure spokes/peerings.
6. Confirm diagnostics, policies, routing, and lifecycle controls.

This is a **logical rollout plan**, not a claim that all phases can be applied in one Terraform transaction.
