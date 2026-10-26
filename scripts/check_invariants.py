#!/usr/bin/env python3
"""Fast offline checks for architecture fidelity and the five-module wiring."""
from pathlib import Path
root = Path(__file__).resolve().parents[1]
infra = (root / "main-infra/main.tf").read_text()
for module_name in (
    "connectivity_xp", "connectivity_appbuild", "connectivity_apprun", "management", "core"
):
    assert f'module "{module_name}"' in infra, module_name
assert 'module.connectivity_xp.configuration' in infra
assert 'module.management.configuration' in infra
assert 'module.connectivity_appbuild.configuration' not in infra
assert 'module.connectivity_apprun.configuration' not in infra
for name in ("connectivity-xp", "connectivity-appbuild", "connectivity-apprun", "management", "core"):
    body=(root / "modules" / name / "main.tf").read_text()
    assert 'Azure/caf-enterprise-scale/azurerm' in body
    assert 'version = "6.2.1"' in body
    assert name == 'core' or __import__('re').search(r'deploy_core_landing_zones\s*=\s*false', body)
assert 'backend "http" {}' in (root / 'main-infra/backend.tf').read_text()
assert 'azurerm_management_group' not in (root / 'modules/core/main.tf').read_text()
print("PASS: five ALZ wrappers and platform dependency directions")
