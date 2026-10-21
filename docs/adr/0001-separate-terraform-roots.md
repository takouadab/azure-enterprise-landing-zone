# ADR 0001: Separate platform and application Terraform roots

**Status:** Accepted for design

**Context:** Platform governance/network resources and workload subscription onboarding have different lifecycles and permissions.

**Decision:** Use `main-infra` and `main-bp` with independent states. Publish explicit integration outputs for existing hub resources.

**Consequences:** Easier isolation of access and blast radius; onboarding cannot rely on direct references to platform root modules.
