# Application Landing Zones (`main-bp`)

A separate Terraform root for XP (`raztak-experimentation`), AppBuild
(`raztak-appbuild`), and AppRun (`raztak-apprun`). Uses
`Azure/lz-vending/azurerm` v5.1.2 with independently locked AzureRM v4 and AzAPI
providers. State remains local at `.local-state/main-bp/terraform.tfstate`.

## One configuration source: `env/azure-alz.env`

Do not use `.template/bp-subscriptions.json`. All settings come from the same
private, locally sourced `env/azure-alz.env` as `main-infra`.

Add **six exports** to the existing env file (keep your existing variables):

```sh
export TF_VAR_xp_spoke_networks='{}'
export TF_VAR_xp_subscriptions='[]'
export TF_VAR_appbuild_spoke_networks='{}'
export TF_VAR_appbuild_subscriptions='[]'
export TF_VAR_apprun_spoke_networks='{}'
export TF_VAR_apprun_subscriptions='[]'
```

The values are JSON strings inside single shell quotes. Spoke allocations and
subscriptions are distinct, keyed together by `alias_name`, like the Pulsar
reference. Example (illustrative; no real application subscription):

```sh
export TF_VAR_xp_spoke_networks='{"xp0001":{"cidr_block":"10.223.16.0/25"}}'
export TF_VAR_xp_subscriptions='[{"id":"00000000-0000-0000-0000-000000000001","alias_name":"xp0001","display_name":"Example XP","status":"inactive"}]'
```

An active entry requires a real, non-Platform subscription ID, and a matching
Spoke CIDR. The six environment variables **must be set even when empty**, so a
forgotten `source` cannot silently generate an empty configuration and lead to
unintended Terraform deletions. The renderer checks duplicate IDs, allocations,
and overlapping spoke CIDRs. Check actual Azure hubs and other networks for
additional CIDR overlap before activating subscriptions.

## Commands

```sh
source env/azure-alz.env
unset ARM_SKIP_PROVIDER_REGISTRATION
python3 scripts/render_bp.py  # Jinja2 only: renders static provider aliases and modules
terraform fmt -recursive main-bp
terraform -chdir=main-bp validate
terraform -chdir=main-bp plan
```

Terraform must know classic provider alias references when building the graph.
That is why the **single existing Jinja2 renderer** is still required for
multiple application subscriptions. It does not read files other than the six
`.tf.j2` templates, does not call Azure, and does not deploy resources. Generated
`.tf` files are gitignored. No extra JSON catalogs, Vault integration, or new
Python scripts are needed.

No subscriptions are created automatically; the project onboards **existing**
application subscriptions only. Never reuse the Connectivity or Management
Platform subscription as an application subscription. Without active application
subscriptions, expect `No changes` in the plan. Review nonempty plans carefully
before apply; do not commit state, local env values or Terraform plan files.
