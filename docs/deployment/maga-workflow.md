# Master is Always Green (MAGA) Workflow

## Visual Workflow

```
                                   ┌─────────────────────┐
                                   │                     │
                                   │  FEATURE BRANCHES   │◄────┐
                                   │                     │     │
                                   └──────────┬──────────┘     │
                                              │                │
                                              │ Pull Request   │ Create New
                                              │ (CI Must Pass) │ Feature Branch
                                              ▼                │
                      Pull Request      ┌─────────────────────┐│
┌───────────────┐    (CI Must Pass)     │                     ││
│               │◄─────────────────────┤      DEVELOP        │┘
│  RELEASE      │                       │                     │
│  BRANCH       │────┐                  └─────────────────────┘
│               │    │                        ▲        │
└───────┬───────┘    │                        │        │
        │            │                        │        │
        │            │                   Merge Back    │ Create
E2E Tests│            │                Hot Fixes│        │ Release Branch
Must Pass│            │                        │        ▼
        │            │                  ┌─────────────────────┐
        ▼            │                  │                     │
┌───────────────┐    │ If All Tests Pass│     HOTFIXES       │
│               │    │                  │                     │
│  STAGING ENV  │    │                  └──────────┬──────────┘
│               │    │                             │
└───────┬───────┘    │                             │ Pull Request 
        │            │                             │ (ALL Tests MUST Pass)
        │            │                             ▼
  ALL   │            │                   ┌─────────────────────┐
  Tests │            │                   │                     │
  Pass  │            └──────────────────►│      MASTER        │
        │                                │   (ALWAYS GREEN)    │
        └───────────────────────────────►│                     │
                                         └──────────┬──────────┘
                                                    │
                                                    │ Automatic
                                                    │ Deployment
                                                    ▼
                                         ┌─────────────────────┐
                                         │                     │
                                         │    PRODUCTION       │
                                         │                     │
                                         └─────────────────────┘
```

## Critical Decision Points

```
Is this a hotfix for a production issue?
├── YES → Create branch from MASTER
│          Fix issue
│          Add tests
│          Run ALL tests
│          PR to MASTER and DEVELOP
│
└── NO → Create/use feature branch from DEVELOP
         Implement feature
         Add tests
         PR to DEVELOP when ready
```

```
Is the release ready for production?
├── NO → Stay in release branch
│       Fix issues
│       Run full test suite again
│
└── YES → PR to MASTER
         Automatic deployment to PRODUCTION
```

## Release Certification Checklist

```
◻ All automated tests pass (unit, integration, E2E)
◻ Performance tests meet threshold requirements
◻ Security scan reveals no critical/high issues
◻ QA verification complete
◻ Stakeholder sign-off received
◻ Documentation updated
◻ Staging environment deployment verified
◻ Rollback procedure tested
◻ On-call rotation scheduled
```

## Pulumi Deployment Flow

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐     
│              │     │              │     │              │     
│ GitHub Code  │────►│  CircleCI    │────►│ Pulumi Code  │     
│              │     │              │     │              │     
└──────────────┘     └──────────────┘     └──────────────┘     
                                                 │             
                                                 ▼             
┌──────────────┐     ┌──────────────┐     ┌──────────────┐     
│              │     │              │     │              │     
│ Green Tests  │◄────│  Deployment  │◄────│ Pulumi Cloud │     
│              │     │              │     │              │     
└──────────────┘     └──────────────┘     └──────────────┘     
```

**REMINDER:** The Master branch is ALWAYS kept in a deployable state. Any violation of this rule breaks everything. 