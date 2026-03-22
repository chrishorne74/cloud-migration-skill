# Cloud Migration — GitHub Copilot Prompt

This folder contains a GitHub Copilot prompt file equivalent of the Claude Code skill.

## Installation

Copy `cloud-migration.prompt.md` into the `.github/prompts/` folder of any VS Code workspace:

```
your-project/
└── .github/
    └── prompts/
        └── cloud-migration.prompt.md
```

Optionally, also copy the reference data files for richer definitions:

```
your-project/
└── .github/
    ├── prompts/
    │   └── cloud-migration.prompt.md
    ├── migration-guardrails.md         ← copy from ../guardrails/
    ├── migration-criteria.json         ← copy from ../criteria/
    └── migration-red-flags.json        ← copy from ../red-flags/
```

## Usage

In VS Code Copilot Chat, type:

```
/cloud-migration assess

Workload: Order Management System
Technology: Java 17 / Spring Boot
Database: Oracle 19c
Business criticality: 4
Dependencies: 12
Age: 8 years
Annual cost: $180,000
Compliance: PCI-DSS
```

All 14 assessment types work the same as the Claude Code skill:
`assess` · `red-flags` · `strategy` · `score` · `container` · `database` ·
`network` · `vmware` · `runbook` · `wave-plan` · `portfolio` · `cost` · `carbon` · `guardrails`

## Requirements

- VS Code with GitHub Copilot extension
- Copilot Chat enabled
- The `.github/prompts/` folder must be in an open workspace
