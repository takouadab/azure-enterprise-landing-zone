# ADR 0002: Three independent connectivity domains

**Status:** Accepted for design

**Context:** Experiments, build services and runtime workloads need separable networking controls.

**Decision:** Model XP, AppBuild and AppRun as three independently configurable hub-and-spoke domains. All hubs may reside in one connectivity subscription.

**Consequences:** Clear segmentation, but more operational complexity and potentially higher network service costs; avoid deploying paid services by default.
