# Implementation roadmap

This document sequences future development. **No Terraform code is part of the architecture milestone.**

| Milestone | Deliverable | Completion gate |
|---|---|---|
| 0. Architecture publication | Diagrams, design scope, ADRs, repo skeleton | GitHub repository published and reviewed |
| 1. Platform root contracts | Variables, outputs, providers, backend strategy | Static review; no credentials in Git |
| 2. Core governance | MG structure, role definitions, policies | Tenant permissions and hierarchy validated |
| 3. Management services | Log Analytics and diagnostic baselines | Monitoring scope and costs approved |
| 4. Connectivity domains | XP, AppBuild, AppRun hub modules | Address plan and paid services reviewed |
| 5. Application onboarding | Subscription associations, spokes, peerings | Cross-state contracts tested |
| 6. Quality gates | fmt, validate, lint/security checks, documentation | Reproducible non-destructive pipeline |

## Definition of done — architecture milestone

- Public README clearly explains project purpose and intended architecture.
- Diagram includes Management Groups, platform subscriptions and workload domains.
- Root/module boundaries and state ownership are explicit.
- Assumptions and permissions are documented, with no misleading deployment claims.
- No secrets, internal identifiers, proprietary screenshots or placeholder Terraform implementations are committed.
