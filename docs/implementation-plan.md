# Implementation roadmap

This document sequences future development. **Milestone 1 has been started:** the `main-infra` root and tenant Management Group hierarchy are implemented behind a disabled-by-default safety switch. Governance policy/RBAC is still pending.

| Milestone | Deliverable | Completion gate |
|---|---|---|
| 0. Architecture publication | Diagrams, design scope, ADRs, repo skeleton | GitHub repository published and reviewed |
| 1. Platform root contracts | Variables, outputs, providers, backend strategy | Initial root implemented; remote backend pending |
| 2. Core governance | MG structure, role definitions, policies | MG code added; roles and policies pending |
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
