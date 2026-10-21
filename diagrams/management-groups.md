# Target Management Group hierarchy

```mermaid
flowchart TB
  root[alz-root]
  platform[platform]
  lz[landing-zones]
  sandbox[sandbox]
  decomm[decommissioned]
  mgmt[management]
  conn[connectivity]
  identity[identity - reserved]
  app[application]
  xp[experimentation]
  build[appbuild]
  run[apprun]
  root --> platform & lz & sandbox & decomm
  platform --> mgmt & conn & identity
  lz --> app & xp
  app --> build & run
```

The identity branch is reserved for a future platform capability and is not implemented by the initial module set. Subscription association and policy inheritance follow actual Azure Management Group scope rules.
