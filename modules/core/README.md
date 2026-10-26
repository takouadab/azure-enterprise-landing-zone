# Core governance

Calls `Azure/caf-enterprise-scale/azurerm` **v6.2.1** (not 12 direct `azurerm_management_group` resources). Core deploys the default ALZ hierarchy, Azure Policies and access model; it receives the XP connectivity and Management configurations to synchronize relevant governance policies **without** redeploying their resources. Identity resource deployment is disabled.

## Intentional, disclosed adaptation

The four application Management Groups currently use the built-in **`default_empty` archetype** until this project’s own policy and role library is designed and reviewed. This deliberately means there are **no custom policy assignments on those four groups yet**. Do not deploy before architecture sign-off.
