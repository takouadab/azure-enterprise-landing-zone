# Management module

Calls Enterprise Scale `6.2.1` with `deploy_core_landing_zones = false` and `deploy_management_resources = true`. Its `configuration` output is fed into the Core ALZ module, without duplicating management resources. The baseline includes Log Analytics and explicit disabled toggles for optional monitoring and Defender capabilities.

Additional diagnostic settings are tracked as a separate implementation increment and are **not** claimed complete here. Do not apply before that review.
