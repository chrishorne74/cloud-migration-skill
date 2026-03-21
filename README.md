# Cloud Migration Skill for Claude

A Claude Code skill that performs comprehensive cloud migration assessments without requiring an MCP server. All methodology, scoring criteria, red flags, guardrails, and strategy logic are embedded directly in the prompt.

## What It Does

Invoke `/cloud-migration` in any Claude Code conversation to access:

| Assessment | Command |
|---|---|
| Full workload assessment (score, 7R strategy, guardrails, readiness) | `/cloud-migration assess` |
| Red flag triage (BLOCKER / HIGH / MEDIUM / WARNING, verdict) | `/cloud-migration red-flags` |
| 7R strategy recommendation with rationale | `/cloud-migration strategy` |
| Score and rank a portfolio of workloads | `/cloud-migration score` |
| Containerisation fitness (12-factor, platform recommendation) | `/cloud-migration container` |
| Database migration path, tools, downtime model | `/cloud-migration database` |
| Cloud network readiness assessment | `/cloud-migration network` |
| VMware estate migration strategy | `/cloud-migration vmware` |
| Cutover runbook generation | `/cloud-migration runbook` |
| Wave plan for a portfolio | `/cloud-migration wave-plan` |
| Portfolio summary report | `/cloud-migration portfolio` |
| ROM cost estimate with break-even | `/cloud-migration cost` |
| CO₂ reduction estimate | `/cloud-migration carbon` |
| Guardrail check | `/cloud-migration guardrails` |
| Architecture diagram description | `/cloud-migration diagram` |

## Methodology Sources

AWS MAP · AWS Prescriptive Guidance · Azure CAF · GCP Cloud Adoption Framework · Gartner · IBM Garage · DXC Technology · TCS Mainframe Factory · BMC · mLogica · Uptime Institute 2025 · PCI DSS v4.0 · CIS Docker Benchmark · 12factor.net · CNCF · IEA 2023

## Installation

### Option 1 — One-liner (macOS / Linux)

```bash
curl -fsSL https://raw.githubusercontent.com/chrishorne74/cloud-migration-skill/main/install.sh | bash
```

### Option 2 — One-liner (Windows PowerShell)

```powershell
iwr https://raw.githubusercontent.com/chrishorne74/cloud-migration-skill/main/install.ps1 | iex
```

### Option 3 — Manual

Download [cloud-migration.md](cloud-migration.md) and copy it to your Claude commands directory:

```bash
# macOS / Linux
cp cloud-migration.md ~/.claude/commands/cloud-migration.md

# Windows
copy cloud-migration.md %USERPROFILE%\.claude\commands\cloud-migration.md
```

Then restart Claude Code (or run `/help` to reload skills).

## Usage Examples

```
/cloud-migration assess

Workload: Order Management System
Technology: Java 17 / Spring Boot
Database: Oracle 19c
Business criticality: 4
Dependencies: 12
Age: 8 years
Annual cost: $180,000
Data classification: confidential
Compliance: PCI-DSS
Source code: yes
```

```
/cloud-migration red-flags

Workload: Legacy ERP
Physical hardware dependency: yes (USB dongle)
Latency requirement: 0.5ms
Cloud licensing confirmed: no
```

```
/cloud-migration wave-plan

[provide a list of workloads with their attributes]
```

## Scoring Criteria

17 weighted criteria (CRIT-001 to CRIT-017) plus 8 container fitness criteria (CON-001 to CON-008) based on AWS MAP, Azure CAF, and industry standards.

## Red Flags

22 red flag definitions: 8 BLOCKERs, 9 HIGH, 4 MEDIUM, 3 WARNING. Includes physical hardware, sub-millisecond latency, licensing, mainframe, database-specific blockers, zombie workloads, and organisational risks.

## Related Projects

- [cloud-migration-mcp](https://github.com/chrishorne74/cloud-migration-mcp) — MCP server version with 30+ tools, Docker support, and runtime-configurable guardrails/criteria/red flags

## License

MIT
