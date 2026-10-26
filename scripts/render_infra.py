#!/usr/bin/env python3
"""Render independent connectivity HCL from existing TF_VAR_* JSON environment.

Does not connect to a secrets manager, set env vars, or assume fixed CIDRs.
"""
import json
import os
from pathlib import Path
from jinja2 import Environment, StrictUndefined

ROOT = Path(__file__).resolve().parents[1]
DOMAINS = ("xp", "appbuild", "apprun")


def entry(domain, suffix):
    name = f"{domain}_hub_{suffix}"
    key = f"TF_VAR_{name}"
    raw = os.environ.get(key)
    if raw is None:
        raise ValueError(f"Missing {key}; export it in your environment before rendering")
    payload = json.loads(raw)
    if name not in payload or not isinstance(payload[name], dict):
        raise ValueError(f"{key} must contain a JSON object with property {name}")
    return payload[name]


def render():
    env = Environment(undefined=StrictUndefined, autoescape=False, keep_trailing_newline=True)
    # Preflight: do not create partial output files if operator variables are missing.
    contexts = {}
    for domain in DOMAINS:
        hub = entry(domain, "network")
        bastion = entry(domain, "bastion")
        firewall = entry(domain, "firewall")
        required = ("cidr_block", "azure_gateway_subnet", "azure_bastion_subnet", "shared_services_subnet")
        for key in required:
            if key not in hub:
                raise ValueError(f"Missing {key} in TF_VAR_{domain}_hub_network")
        for key in ("azure_gateway_subnet", "azure_bastion_subnet", "shared_services_subnet"):
            if not all(k in hub[key] for k in ("name", "ip_range")):
                raise ValueError(f"Missing name/ip_range in {domain}.{key}")
        if not isinstance(bastion.get("enabled"), bool) or not isinstance(firewall.get("enabled"), bool):
            raise ValueError(f"{domain}: enabled must be JSON true or false for Bastion and Firewall")
        if firewall["enabled"]:
            for key in ("azure_firewall_subnet", "azure_firewall_management_subnet"):
                if key not in hub or "ip_range" not in hub[key]:
                    raise ValueError(f"{domain}: {key}.ip_range required when Firewall enabled")
        contexts[domain] = {"domain":domain, "hub":hub, "bastion":bastion, "firewall":firewall}

    for domain, ctx in contexts.items():
        directory = ROOT / 'modules' / f'connectivity-{domain}'
        for name in ("settings.connectivity", "settings.bastion"):
            template_file = directory / f"{name}.tf.j2"
            target_file = directory / f"{name}.tf"
            result = env.from_string(template_file.read_text()).render(**ctx)
            target_file.write_text(result)
            print(f"Rendered {target_file.relative_to(ROOT)}")

if __name__ == "__main__":
    try:
        render()
    except (ValueError, json.JSONDecodeError) as exc:
        raise SystemExit(f"Template input error: {exc}")
