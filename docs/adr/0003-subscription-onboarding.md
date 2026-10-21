# ADR 0003: Onboard existing subscriptions first

**Status:** Accepted for initial release

**Context:** Creating new Azure subscriptions depends on billing permissions unavailable in many personal tenants.

**Decision:** Initial onboarding uses pre-existing subscriptions. Subscription creation through billing APIs is a potential later extension.

**Consequences:** Enables a useful first implementation without assuming enterprise billing rights; the architecture remains compatible with later automated vending.
