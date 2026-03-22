# Cloud Migration Skill for Claude

A Claude Code skill that performs comprehensive cloud migration assessments without requiring an MCP server. All methodology, strategy logic, and output formats are embedded in the prompt. Authoritative scoring criteria, red flags, and guardrails are provided as separate reference files — Claude reads these at assessment time for full, current definitions.

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

Copy all files into a `cloud-migration/` folder inside your Claude commands directory:

```bash
# macOS / Linux
mkdir -p ~/.claude/commands/cloud-migration/guardrails \
         ~/.claude/commands/cloud-migration/criteria \
         ~/.claude/commands/cloud-migration/red-flags
cp SKILL.md                            ~/.claude/commands/cloud-migration/SKILL.md
cp guardrails/migration-guardrails.md  ~/.claude/commands/cloud-migration/guardrails/
cp criteria/migration-criteria.json    ~/.claude/commands/cloud-migration/criteria/
cp red-flags/migration-red-flags.json  ~/.claude/commands/cloud-migration/red-flags/
```

```powershell
# Windows
xcopy /E /I . %USERPROFILE%\.claude\commands\cloud-migration
```

Then restart Claude Code (or run `/help` to reload skills).

## Repository Structure

```
cloud-migration-skill/
├── SKILL.md                             ← main skill prompt
├── guardrails/
│   └── migration-guardrails.md          ← 40+ guardrails across 9 categories
├── criteria/
│   └── migration-criteria.json          ← 17 CRIT + 8 CON scoring criteria with weights/bands
├── red-flags/
│   └── migration-red-flags.json         ← 22 red flag definitions with condition expressions
├── install.sh                           ← one-liner installer (macOS/Linux)
├── install.ps1                          ← one-liner installer (Windows)
└── README.md
```

Everything is installed to `~/.claude/commands/cloud-migration/`. Claude reads the reference files at assessment time.

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

## GitHub Copilot

A Copilot-compatible prompt file is available in [`copilot/`](copilot/). Drop it into `.github/prompts/` in any VS Code workspace and invoke with `/cloud-migration` in Copilot Chat. See [copilot/README.md](copilot/README.md) for setup instructions.

## Related Projects

- [cloud-migration-mcp](https://github.com/chrishorne74/cloud-migration-mcp) — MCP server version with 30+ tools, Docker support, and runtime-configurable guardrails/criteria/red flags

## License

MIT
