#!/usr/bin/env python3
"""Render main-bp .tf files from TF_VAR_* exported by env/azure-alz.env.

Six variables are mandatory (including explicit empty maps/lists), to avoid
accidentally removing generated subscription modules when the env isn't loaded.
"""

import ipaddress
import json
import os
import re
import sys
from pathlib import Path

from jinja2 import Environment, StrictUndefined

ROOT = Path(__file__).resolve().parents[1]
DOMAINS = ("xp", "appbuild", "apprun")
MANAGEMENT_GROUPS = {"xp": "experimentation", "appbuild": "appbuild", "apprun": "apprun"}
GUID = re.compile(r"[0-9a-f]{8}(?:-[0-9a-f]{4}){3}-[0-9a-f]{12}\Z", re.ASCII)
ALIAS = re.compile(r"[a-z][a-z0-9_]*\Z", re.ASCII)


def read_env_json(key, expected_type):
    name = f"TF_VAR_{key}"
    value = os.environ.get(name)
    if value is None or not value.strip():
        raise ValueError(f"Missing {name}. Run 'source env/azure-alz.env' first; explicit empty values are required.")
    try:
        parsed = json.loads(value)
    except json.JSONDecodeError as exc:
        raise ValueError(f"{name} must contain valid JSON: {exc}") from exc
    if not isinstance(parsed, expected_type):
        kind = "object" if expected_type is dict else "array"
        raise ValueError(f"{name} must be a JSON {kind}")
    return parsed


def render():
    protected = {
        os.environ.get("TF_VAR_subscription_id_connectivity", "").lower(),
        os.environ.get("TF_VAR_subscription_id_management", "").lower(),
    }
    seen_ids = set()
    used_networks = []
    contexts = {}

    for domain in DOMAINS:
        spoke_networks = read_env_json(f"{domain}_spoke_networks", dict)
        subscriptions = read_env_json(f"{domain}_subscriptions", list)
        cidrs = {}
        for alias, details in spoke_networks.items():
            if not isinstance(alias, str) or not ALIAS.fullmatch(alias):
                raise ValueError(f"{domain}: invalid spoke alias {alias!r}")
            if not isinstance(details, dict) or not isinstance(details.get("cidr_block"), str):
                raise ValueError(f"{domain}/{alias}: expected {{'cidr_block': 'x.x.x.x/prefix'}}")
            try:
                cidr = ipaddress.IPv4Network(details["cidr_block"], strict=True)
            except ValueError as exc:
                raise ValueError(f"{domain}/{alias}: invalid IPv4 CIDR: {exc}") from exc
            for other_domain, other_alias, other_cidr in used_networks:
                if cidr.overlaps(other_cidr):
                    raise ValueError(
                        f"Overlapping spoke CIDRs: {domain}/{alias} {cidr} "
                        f"and {other_domain}/{other_alias} {other_cidr}"
                    )
            used_networks.append((domain, alias, cidr))
            cidrs[alias] = str(cidr)

        active = []
        seen_aliases = set()
        for subscription in subscriptions:
            if not isinstance(subscription, dict):
                raise ValueError(f"{domain}: each subscription must be a JSON object")
            if subscription.get("status") not in ("active", "inactive"):
                raise ValueError(f"{domain}: subscription status must be active or inactive")
            if subscription["status"] != "active":
                continue
            if not all(os.environ.get(name) for name in (
                "TF_VAR_subscription_id_connectivity", "TF_VAR_subscription_id_management"
            )):
                raise ValueError("Both Platform subscription IDs must be exported for active subscriptions")
            for key in ("id", "alias_name", "display_name"):
                if not isinstance(subscription.get(key), str) or not subscription[key]:
                    raise ValueError(f"{domain}: missing or invalid {key}")
            subscription_id = subscription["id"].lower()
            alias = subscription["alias_name"]
            if not GUID.fullmatch(subscription_id):
                raise ValueError(f"{domain}: subscription ID must be a GUID")
            if not ALIAS.fullmatch(alias):
                raise ValueError(f"{domain}: invalid alias_name {alias!r}")
            if subscription_id in protected:
                raise ValueError(f"{domain}: Platform subscription cannot be onboarded")
            if subscription_id in seen_ids:
                raise ValueError(f"Duplicate active subscription ID: {subscription_id}")
            if alias in seen_aliases:
                raise ValueError(f"{domain}: duplicate active alias_name {alias}")
            if alias not in cidrs:
                raise ValueError(f"{domain}/{alias}: no matching {domain}_spoke_networks allocation")
            if "cidr_block" in subscription:
                raise ValueError(f"{domain}/{alias}: keep cidr_block only in {domain}_spoke_networks")
            seen_aliases.add(alias)
            seen_ids.add(subscription_id)
            active.append({**subscription, "cidr_block": cidrs[alias]})

        contexts[domain] = {
            "domain": domain,
            "management_group": MANAGEMENT_GROUPS[domain],
            "subscriptions": active,
        }

    engine = Environment(
        undefined=StrictUndefined,
        autoescape=False,
        trim_blocks=True,
        lstrip_blocks=True,
        keep_trailing_newline=True,
    )
    outputs = {}
    for domain in DOMAINS:
        for prefix in ("providers", "projects"):
            template_path = ROOT / "main-bp" / f"{prefix}-{domain}.tf.j2"
            target_path = template_path.with_suffix("")
            outputs[target_path] = engine.from_string(
                template_path.read_text(encoding="utf-8")
            ).render(**contexts[domain])

    # Write only after all inputs and all templates have been successfully checked.
    for target_path, content in outputs.items():
        target_path.write_text(content, encoding="utf-8")
        print(f"Rendered {target_path.relative_to(ROOT)}")
    print(f"Active application subscriptions: {len(seen_ids)}")
    print(f"Reserved spoke CIDRs: {len(used_networks)}")


if __name__ == "__main__":
    try:
        render()
    except (ValueError, KeyError) as exc:
        sys.exit(f"main-bp generation error: {exc}")
