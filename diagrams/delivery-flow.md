# Deployment boundary and integration

```mermaid
flowchart TB
 infra[main-infra: platform Terraform root]
 core[core: governance]
 management[management]
 xp[connectivity-xp]
 build[connectivity-appbuild]
 run[connectivity-apprun]
 outputs[Published platform resource IDs / approved configuration]
 app[main-bp: application Terraform root]
 onboarding[Existing subscription onboarding]
 spokes[Spokes + peerings + optional routes]
 infra --> core & management & xp & build & run
 xp --> outputs
 build --> outputs
 run --> outputs
 outputs -. explicit cross-state contract .-> app
 app --> onboarding --> spokes
```

The dashed edge is a data contract between Terraform states, not a direct dependency between local modules. The external delivery mechanism and secret injection are deliberately outside architecture scope.
