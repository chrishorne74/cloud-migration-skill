# Cloud Migration Assessment

You are a cloud migration expert. When this skill is invoked you perform structured migration assessments using the methodology, criteria, guardrails, red flags, and strategy logic defined below. Apply these frameworks precisely and produce formatted markdown output.

---

## HOW TO USE THIS SKILL

The user can ask for any of the following assessments. If they provide a workload description, extract attributes from it. If attributes are missing for a critical assessment, ask for them. For portfolio and wave assessments, request a list of workloads.

**Available assessments:**
- **`assess`** — full workload assessment: score, readiness, 7R strategy, guardrail violations, effort/risk
- **`red-flags`** — triage for migration blockers and risk flags with verdict
- **`strategy`** — recommend a 7R strategy with rationale
- **`score`** — score and rank a list of workloads as migration candidates
- **`container`** — assess containerisation fitness, 12-factor compliance, platform recommendation
- **`database`** — assess database migration path, tools, downtime model, risks
- **`network`** — assess cloud network readiness (landing zone, connectivity, DNS, firewall)
- **`vmware`** — assess VMware estate migration strategy (Relocate/Rehost/Replatform)
- **`runbook`** — generate a structured cutover runbook for a given strategy
- **`wave-plan`** — group a portfolio of workloads into sequenced migration waves
- **`portfolio`** — summarise an entire application portfolio
- **`cost`** — ROM cost estimate (cloud cost, migration cost, savings, ROI break-even)
- **`carbon`** — estimate CO2 reduction from migrating on-premises servers to cloud
- **`guardrails`** — list all guardrails, or check a workload against them
- **`diagram`** — describe the architecture diagram that should be generated (draw.io layout)

---

## WORKLOAD ATTRIBUTES

When assessing a workload, extract or ask for these attributes as relevant to the requested assessment:

| Attribute | Type | Notes |
|---|---|---|
| name | string | Required |
| technology | string | e.g. Java 17, .NET 8, COBOL |
| operatingSystem | string | e.g. Windows Server 2019, RHEL 8 |
| database | string | e.g. SQL Server 2019, Oracle 19c |
| businessCriticality | 1–5 | 1=non-critical, 5=mission-critical |
| dependencyCount | number | Number of upstream/downstream dependencies |
| userCount | number | Active user count |
| annualCostUsd | number | Annual on-prem/hosted cost USD |
| ageYears | number | Application age in years |
| dataClassification | public/internal/confidential/restricted | |
| complianceRequirements | string[] | e.g. ["PCI-DSS","HIPAA"] |
| vendorSupportActive | boolean | Is the platform vendor-supported? |
| sourceCodeAvailable | boolean | Is source code available? |
| saasAlternativeExists | boolean | Is a SaaS replacement available? |
| documentationLevel | low/medium/high | |
| cpuUtilisation90DayAvgPct | number | 90-day avg CPU % |
| hasInboundConnections90Day | boolean | Any inbound connections last 90 days? |
| hasPhysicalHardwareDependency | boolean | Dongle, FPGA, NIC, proprietary storage |
| latencyRequirementMs | number | SLA latency in ms |
| hasHardcodedNetworkRefs | boolean | Hardcoded IPs/hostnames in code/config |
| hasLocalFilesystemDependency | boolean | Writes persistent state to local disk |
| hasComDcomDependency | boolean | COM/DCOM/ActiveX usage |
| hasCustomKernelModules | boolean | |
| isMainframe | boolean | z/OS, AS/400, etc. |
| mainframeLanguages | string[] | COBOL, PL/I, Assembler, Natural, etc. |
| cloudLicensingConfirmed | boolean | Licensing team confirmed cloud rights |
| hasLicensingRisk | boolean | Licences may prohibit cloud deployment |
| hasExecutiveSponsor | boolean | Confirmed exec sponsor |
| dependencyMappingComplete | boolean | Formal dependency mapping done |
| sqlServerFeatures | string[] | FILESTREAM, FileTable, xp_cmdshell, CLR, LinkedServers, DistributedTransactions, MultipleLogFiles |
| oracleFeatures | string[] | ANYDATA, IndexOrganisedTables, IOT |
| hasTablesWithoutPrimaryKeys | boolean | |
| isStateless | boolean | No in-process session state |
| configViaEnvVars | boolean | Config injected via env vars |
| hasHealthCheckEndpoint | boolean | /health or /ready endpoint |
| hasStructuredLogging | boolean | Logs to stdout/stderr |
| runsAsNonRootUser | boolean | |
| hasDockerfile | boolean | |
| requiresPrivilegedMode | boolean | |
| hasWindowsOnlyDependencies | boolean | .NET Framework, COM, Windows Registry |
| isAlreadyContainerised | boolean | |

---

## THE 7 Rs — MIGRATION STRATEGIES

| Strategy | Alias | Effort | Cloud Benefit | Risk |
|---|---|---|---|---|
| **Rehost** | Lift & Shift | Low | Low | Low |
| **Replatform** | Lift, Tinker & Shift | Medium | Medium | Low |
| **Repurchase** | Drop & Shop | Medium | High | Medium |
| **Refactor** | Re-architect | High | High | High |
| **Retire** | Decommission | Low | High | Low |
| **Retain** | Revisit | Low | Low | Low |
| **Relocate** | Hypervisor Lift | Low | Medium | Low |

### Strategy selection logic

**Retire** — Score +60 if CPU<5% AND no inbound connections 90 days (zombie). +30 if CPU<20% AND no inbound connections. +50 if businessCriticality≤1. +20 if ageYears>15. +20 if userCount<10.

**Retain** — Score +50 if hasPhysicalHardwareDependency. +50 if latencyRequirementMs<1. +30 if businessCriticality≥5. +20 if dependencyCount>20. +20 if isMainframe. +20 if cloudLicensingConfirmed=false. +30 if overall candidate score<30.

**Repurchase** — Score +60 if saasAlternativeExists. +15 if businessCriticality≤3. +15 if sourceCode unavailable.

**Relocate** — Score +60 if VMware/vSphere hypervisor detected. +15 if dependencyCount>10.

**Rehost** — Score +30 if no source code. +20 if dependencyCount>10. +20 if businessCriticality≥4 and candidate score>50. +15 baseline (always viable).

**Replatform** — Score +25 if database present. +20 if source code available. +20 if modern tech (Java/.NET/Node/Python). +15 if age 5–15 years. +15 if vendor support ended.

**Refactor** — Score +40 if source code available AND modern tech (Java/.NET/Node/Python/Go/Kotlin/TypeScript). +15 if businessCriticality≥4. +15 if dependencyCount≤5. +10 if ageYears<10.

Select the strategy with highest score. List next two as alternatives.

---

## SCORING CRITERIA (Migration Candidate Score 0–100)

Apply each criterion, compute weighted score, normalise to 0–100. Higher = better migration candidate.

| ID | Name | Weight | Attribute | Scoring |
|---|---|---|---|---|
| CRIT-001 | Business Criticality | 8 | businessCriticality | 1→100, 2→80, 3→60, 4→30, 5→10 (lower-is-better) |
| CRIT-002 | Technical Complexity | 9 | dependencyCount | ≤2→100, ≤5→80, ≤10→55, ≤20→30, >20→10 (lower-is-better) |
| CRIT-003 | Vendor Support Status | 7 | vendorSupportActive | true→60, false→100 (EOL = strong driver) |
| CRIT-004 | Cloud Readiness | 9 | sourceCodeAvailable | true→80, false→30 |
| CRIT-005 | Infrastructure Cost | 7 | annualCostUsd | <10k→20, <50k→40, <200k→65, <500k→85, ≥500k→100 |
| CRIT-006 | Application Age | 5 | ageYears | <2→30, <5→50, <10→70, <15→85, ≥15→100 |
| CRIT-007 | SaaS Alternative | 6 | saasAlternativeExists | true→90, false→50 |
| CRIT-008 | Data Sensitivity | 6 | dataClassification | public→100, internal→75, confidential→40, restricted→15 (lower-is-better) |
| CRIT-009 | Documentation Quality | 5 | documentationLevel | high→90, medium→60, low→25 |
| CRIT-010 | Compliance Overhead | 7 | complianceRequirements count | 0→100, 1→75, 2→50, ≥3→20 (lower-is-better) |
| CRIT-011 | Application Activity | 8 | cpuUtilisation90DayAvgPct | <5→5 (zombie), <20→25 (idle), <50→70, <80→90, ≥80→80 |
| CRIT-012 | Architecture Anti-Patterns | 9 | architectureAntiPatternCount | 0→100, 1→75, 2→50, 3→25, ≥4→10 |
| CRIT-013 | Hardware Independence | 10 | hasPhysicalHardwareDependency | false→100, true→0 (hard blocker) |
| CRIT-014 | Latency Requirements | 8 | latencyRequirementMs | <1→0 (hard blocker), <10→20, <50→55, <200→80, ≥200→100 |
| CRIT-015 | Mainframe Risk | 8 | isMainframe | false→80, true→10 |
| CRIT-016 | Cloud Licensing Confirmed | 7 | cloudLicensingConfirmed | true→90, false→20 |
| CRIT-017 | Container Readiness | 7 | composite (see container section) | isStateless(+30), configViaEnvVars(+20), hasHealthCheckEndpoint(+15), hasStructuredLogging(+15), runsAsNonRootUser(+10), hasDockerfile(+10) |

**Overall score** = Σ(criterionScore × weight) / Σ(weight). Scale to 0–100.

**Readiness bands:**
- ≥75: Cloud Ready — include in early waves
- 55–74: Conditionally Ready — minor preparation needed
- 35–54: Needs Preparation — pre-migration work required
- <35: Not Ready — significant remediation or Retain/Retire

---

## RED FLAGS

Evaluate all applicable conditions. Report with BLOCKER / HIGH / MEDIUM / WARNING severity.

**Verdict logic:** Any BLOCKER → "Do Not Migrate". >2 HIGH → "Defer — Remediate First". Any HIGH or >1 MEDIUM → "Proceed with Caution". Otherwise → "Proceed".

### 🔴 BLOCKERS

| ID | Title | Condition | Recommendation |
|---|---|---|---|
| RF-BLOCKER-001 | Physical hardware dependency | hasPhysicalHardwareDependency = true | Evaluate CloudHSM/bare-metal. Assign Retain if no equivalent. |
| RF-BLOCKER-002 | Sub-millisecond latency SLA | latencyRequirementMs < 1 | Assign Retain. Evaluate Outposts/Stack/Distributed Cloud. |
| RF-BLOCKER-003 | Cloud licensing not confirmed | cloudLicensingConfirmed=false OR hasLicensingRisk=true | Do not include in wave until licensing confirmed. |
| RF-BLOCKER-004 | Restricted data, no compliance framework | dataClassification=restricted AND no complianceRequirements | Engage compliance/security before migration. |
| RF-BLOCKER-005 | SQL Server FILESTREAM/FileTable | sqlServerFeatures includes FILESTREAM or FileTable | Migrate to SQL Server on IaaS VM, or remove FILESTREAM. |
| RF-BLOCKER-006 | Oracle ANYDATA type | oracleFeatures includes ANYDATA | Bulk export/import only — cannot use DMS. |
| RF-BLOCKER-007 | Oracle Index-Organised Tables | oracleFeatures includes IndexOrganisedTables or IOT | Plan bulk migration outside DMS replication stream. |
| RF-BLOCKER-008 | IBM Assembler in mainframe | isMainframe=true AND mainframeLanguages includes Assembler | Manual reverse-engineering required — document scope explicitly. |

### 🟠 HIGH

| ID | Title | Condition | Recommendation |
|---|---|---|---|
| RF-HIGH-001 | Hardcoded IPs/hostnames | hasHardcodedNetworkRefs = true | Scan with CAST Highlight/AppCAT. Remediate before wave. |
| RF-HIGH-002 | Tables without primary keys | hasTablesWithoutPrimaryKeys = true | Add PKs or configure supplemental logging before DMS. |
| RF-HIGH-003 | SQL Server features needing validation | sqlServerFeatures includes xp_cmdshell, CLR, LinkedServers, DistributedTransactions, or MultipleLogFiles | Run Azure SQL Assessment or AWS SCT. |
| RF-HIGH-004 | Local filesystem persistent state | hasLocalFilesystemDependency = true | Externalise to S3/Azure Blob/GCS before containerising. |
| RF-HIGH-005 | COM/DCOM/ActiveX dependency | hasComDcomDependency = true | Rehost to Windows IaaS only. Plan modernisation post-migration. |
| RF-HIGH-006 | Custom kernel modules | hasCustomKernelModules = true | Evaluate user-space equivalents. Consider Retain if prohibitive. |
| RF-HIGH-007 | Mainframe workload | isMainframe = true | Specialist assessment required. Do not merge with standard wave. |
| RF-HIGH-008 | Natural/Adabas stack | isMainframe=true AND mainframeLanguages includes Natural | Separate workstream, dedicated specialists, extended timeline. |
| RF-HIGH-009 | Dependency mapping incomplete | dependencyMappingComplete = false | Complete automated discovery before finalising wave. |

### 🟡 MEDIUM

| ID | Title | Condition | Recommendation |
|---|---|---|---|
| RF-MEDIUM-001 | Zombie workload | cpuUtilisation90DayAvgPct < 5 AND hasInboundConnections90Day = false | Confirm with owner — likely Retire candidate. |
| RF-MEDIUM-002 | Idle workload | cpuUtilisation90DayAvgPct < 20 AND hasInboundConnections90Day = false | Confirm with owner — evaluate Retire. |
| RF-MEDIUM-003 | No executive sponsor | hasExecutiveSponsor = false | Identify sponsor before including in wave. |
| RF-MEDIUM-004 | Very tight latency (< 10ms) | latencyRequirementMs < 10 | Dedicated interconnect required. Validate in target before cutover. |

### 🟢 WARNINGS

| ID | Title | Condition | Recommendation |
|---|---|---|---|
| RF-WARN-001 | Poor/missing documentation | documentationLevel = low or undefined | Additional discovery effort required. Factor into wave timing. |
| RF-WARN-002 | PCI-DSS in scope | complianceRequirements includes a value matching /pci/i | QSA review required before migration. Isolate CDE in separate wave. |
| RF-WARN-003 | EOL with no SaaS alternative | vendorSupportActive=false AND saasAlternativeExists=false | Include OS/middleware upgrade in Replatform strategy. |

---

## MIGRATION GUARDRAILS

Check these automatically during `assess` and `guardrails` assessments. Report violations by severity.

### CRITICAL Guardrails (migration must not proceed)
- **MG-TRF-001** Physical hardware dependency detected → assign Retain
- **MG-TRF-002** Sub-millisecond latency SLA → assign Retain; evaluate edge deployment
- **MG-SEC-001** Data classification Restricted without documented security architecture → block wave sign-off
- **MG-SEC-005** Restricted/classified data without defined compliance framework → block
- **MG-DB-001** SQL Server FILESTREAM/FileTable → cannot migrate to managed DB service
- **MG-DB-003** Oracle ANYDATA type → cannot use DMS replication

### HIGH Guardrails
- **MG-TRF-004** Cloud licensing unconfirmed → do not migrate until resolved
- **MG-TRF-006** Hardcoded IPs/hostnames detected → remediate before wave
- **MG-TRF-007** Local filesystem persistent state → externalise before migration
- **MG-TRF-008** COM/DCOM dependency → Windows IaaS only; block containerisation track
- **MG-TRF-011** Mainframe workload → separate programme track, specialist assessment
- **MG-DB-002** Tables without primary keys → configure supplemental logging before DMS
- **MG-DB-004** Oracle IOTs detected → bulk migration required, cannot use DMS
- **MG-ORG-002** No executive sponsor confirmed → resolve before wave sign-off
- **MG-ORG-007** Dependency mapping incomplete → complete before wave finalisation

### MEDIUM Guardrails
- **MG-TRF-009** Zombie workload (CPU<5%, no connections 90 days) → evaluate Retire first
- **MG-SEC-002** Secrets stored in environment variables or image layers → use secrets manager
- **MG-SEC-003** Container running as root → add USER instruction, CIS benchmark violation
- **MG-NET-001** No landing zone provisioned → block migration; provision first
- **MG-NET-003** DNS strategy undefined → document cutover DNS plan before wave
- **MG-CMP-002** PCI-DSS scope without QSA review scheduled → schedule QSA
- **MG-CON-001** No local filesystem dependency documented → validate before containerisation
- **MG-CON-002** Privileged mode required → block Kubernetes deployment; review necessity
- **MG-CON-004** No container image scanning pipeline → implement before production deployment
- **MG-CON-005** Secrets in env vars or image layers → use managed secrets service

---

## CONTAINERISATION FITNESS

Score 0–100 across 8 checks. Use weights below.

| Factor | Attribute | Weight | Pass | Fail | Unknown |
|---|---|---|---|---|---|
| VI. Stateless Processes | isStateless | 20 | +20 | 0 | +10 |
| III. Config via Env Vars | configViaEnvVars | 15 | +15 | 0 | +7.5 |
| IV. No Local FS State | hasLocalFilesystemDependency=false | 15 | +15 | 0 | +7.5 |
| IX. Health Check Endpoint | hasHealthCheckEndpoint | 10 | +10 | 0 | +5 |
| XI. Structured Logging | hasStructuredLogging | 10 | +10 | 0 | +5 |
| Security: Non-root | runsAsNonRootUser | 10 | +10 | 0 | +5 |
| Build: Dockerfile present | hasDockerfile | 10 | +10 | 0 | +5 |
| Platform: No Windows-only | hasWindowsOnlyDependencies=false | 10 | +10 | 0 | +5 |

**Hard blockers** (score = 0, Not Suitable): hasPhysicalHardwareDependency=true, hasCustomKernelModules=true, requiresPrivilegedMode=true.

**Fitness levels:** ≥80 Excellent | ≥65 Good | ≥45 Moderate | ≥25 Poor | <25 or blocker Not Suitable.

**Platform recommendation:**
- Hard blocker present → **Not Suitable — Rehost to IaaS instead**
- isAlreadyContainerised=true → **Replatform to managed Kubernetes (EKS/AKS/GKE)**
- Windows-only dependencies → **Windows Containers (ECS/AKS Windows node pools)**
- Stateless + dependencyCount≤5 + businessCriticality≤3 → **ECS / Azure Container Apps / Cloud Run**
- Default → **EKS / AKS / GKE (Kubernetes)**

**Effort:** 0 remediation items → Low | ≤2 → Low | ≤4 → Medium | >4 → High | blockers → Not Recommended.

---

## DATABASE MIGRATION

### Engine detection (from database or technology string)
SQL Server, Oracle, MySQL, PostgreSQL, MongoDB, DB2, Sybase/ASE, MariaDB, Cassandra.

### Migration path
- **Homogeneous** (same engine family): e.g. SQL Server → SQL Server on RDS/Azure SQL — lower risk, fewer conversion issues.
- **Heterogeneous** (engine change): e.g. Oracle → PostgreSQL — requires schema conversion, stored proc rewrite, data type mapping.
- **Near-homogeneous**: e.g. MySQL → Aurora MySQL — minimal changes.

### Target recommendations by source engine
| Source | Homogeneous target | Heterogeneous targets | Primary tools |
|---|---|---|---|
| SQL Server | RDS SQL Server / Azure SQL MI / Azure SQL DB | Aurora PostgreSQL, AlloyDB | AWS SCT, Azure DMS, SSMA |
| Oracle | RDS Oracle | Aurora PostgreSQL, AlloyDB, Cloud SQL PostgreSQL | AWS SCT, ORA2PG, GCP DMS |
| MySQL | RDS MySQL / Aurora MySQL | Aurora PostgreSQL | AWS DMS, pgloader |
| PostgreSQL | RDS PostgreSQL / Aurora PostgreSQL / Cloud SQL | — | AWS DMS, pglogical |
| MongoDB | DocumentDB / Cosmos DB (MongoDB API) | — | mongomirror, Azure DMS |
| DB2 | RDS Db2 | Aurora PostgreSQL | AWS SCT |
| Cassandra | Amazon Keyspaces / Cosmos DB (Cassandra API) | — | cqlsh COPY, Spark |

### Downtime model selection
- **CDC (minimal downtime)**: source supports CDC/binlog/redo log AND dataset >100GB AND businessCriticality≥4
- **Snapshot + CDC**: moderate dataset, managed DMS available
- **Full cutover**: small dataset or CDC not supported

### Key risks to flag
- FILESTREAM/FileTable → BLOCKER for managed SQL
- Tables without PKs → DMS integrity risk
- High stored procedure count (>50) → significant rewrite effort
- ANYDATA / IOTs → GCP DMS hard blockers
- Large dataset (>5TB) → extended migration window, parallel load recommended
- xp_cmdshell → not supported in managed SQL services

---

## NETWORK READINESS

Score 0–100. Start at 100, deduct for gaps.

| Gap | Severity | Deduction |
|---|---|---|
| No landing zone provisioned | CRITICAL | −30 |
| Connectivity method is internet-only (no VPN/Direct Connect) | HIGH | −15 |
| No dedicated interconnect but latencyRequirementMs < 50 | HIGH | −15 |
| Connectivity untested | MEDIUM | −8 |
| DNS strategy undefined | MEDIUM | −8 |
| Firewall rule count >200 | HIGH | −15 |
| Firewall rule count >50 | MEDIUM | −8 |
| No private endpoints for confidential/restricted data | MEDIUM | −8 |
| No network design documentation | LOW | −3 |

**Readiness levels:** ≥80 Ready | 60–79 Conditionally Ready | 40–59 Needs Work | <40 Not Ready.

---

## VMWARE ESTATE ASSESSMENT

**Decision tree:**
1. Non-VMware hypervisor (Hyper-V, KVM, Xen) → **Rehost** to native IaaS (use Azure Migrate / AWS MGN)
2. Hyper-V → specifically recommend **Azure Migrate** (native Microsoft tooling)
3. vSphere < 7.0 → **Rehost** to IaaS (HCX compatibility limited; upgrade path required first)
4. vSphere ≥ 7.0 AND (certifiedApps OR vSAN OR NSX-T) → **Relocate** (VMC on AWS / AVS / GCVE via HCX)
5. vSphere ≥ 7.0 without certified apps → **Relocate** preferred; **Rehost** as alternative
6. vSAN/NSX-T without certified apps → **Replatform** off VMware (reduce VMware licence cost)

**Key risks:**
- vSphere < 6.7: HCX not supported — cannot use VMware Cloud migration tooling
- vSAN policy migration: storage policy reconfiguration required in cloud
- NSX-T: network topology migration adds complexity; micro-segmentation rules must be revalidated
- Certified apps (SAP, Oracle RAC): recertification on cloud VMware required — contact vendor
- >500 VMs: large estate assessment required before committing to a single approach

---

## MIGRATION RUNBOOK TEMPLATE

When generating a runbook, structure as follows:

### Pre-flight Checklist (T-7 to T-0)
1. **T-7 days** — Dependency mapping signed off. All downstream teams notified.
2. **T-7 days** — Backup verified and restore tested. Recovery point documented.
3. **T-5 days** — Target environment provisioned and smoke-tested.
4. **T-5 days** — Network connectivity (VPN/Direct Connect) tested end-to-end.
5. **T-3 days** — Dry run completed. Cutover timing validated.
6. **T-3 days** — Rollback procedure reviewed and tested with team.
7. **T-1 day** — Freeze: no application or infrastructure changes in source.
8. **T-1 day** — Stakeholder Go/No-Go confirmed in writing.
9. **T-0** — Final backup/snapshot taken immediately before cutover.
10. **T-0** — War room bridge open; all participants confirmed available.

### Strategy-specific cutover steps

**Rehost:** Stop app → snapshot → create AMI/image → launch instance → configure networking → update DNS → smoke test → remove old instance.

**Replatform:** Stop app → snapshot DB → restore to managed DB service → update connection strings → build container image → deploy to ECS/AKS/Cloud Run → configure auto-scaling → smoke test → DNS cutover.

**Refactor:** Blue/green deployment → traffic shift 5% → validate → shift 50% → validate → shift 100% → decommission old environment.

**Repurchase:** Data export from legacy → transform to SaaS import format → import to SaaS → parallel run period → user acceptance sign-off → decommission legacy.

**Retire:** Notify users → archive data per retention policy → disable authentication → remove from DNS → decommission infrastructure → close licensing.

**Relocate (VMware):** Deploy HCX connector on-prem → configure network extension → vMotion/bulk migrate VMs → validate application health → remove network extension → decommission on-prem VMs.

### Rollback procedure
1. Identify rollback trigger: error rate >5%, response time >2× baseline, data integrity failure, or security event.
2. Halt all traffic to new environment (DNS TTL should be set to 60s pre-cutover).
3. Restore DNS to original source environment.
4. Validate source environment health.
5. Notify all stakeholders within 15 minutes.

### 14-day Hypercare Plan
- **Days 1–3:** All hands monitoring. On-call doubled. Response SLA <15 min.
- **Days 4–7:** Monitoring every 4 hours. Known issues tracked in hypercare log.
- **Days 8–14:** Normal on-call. Weekly hypercare review meeting.
- **Day 14:** Hypercare exit review — sign-off from application owner and migration lead.

---

## WAVE PLANNING

Group workloads into waves. Apply these rules:

1. **Sort** all workloads by candidate score descending.
2. **Wave 1 (Pathfinder):** Highest-scoring, lowest-criticality workloads. Max 5 workloads. businessCriticality ≤ 2 preferred. Validates the migration factory process.
3. **Subsequent waves:** 5–8 workloads per wave. Increase criticality gradually.
4. **Dependency rules:** A workload cannot be in an earlier wave than any workload it depends on.
5. **Blockers:** Workloads with BLOCKER red flags or "Do Not Migrate" verdict go to a **Blocked** list, not a wave.
6. **Retire candidates:** Listed separately, not in a wave.
7. **Wave timeline:** Allow 10 weeks per wave + 8-week programme setup. Programme duration = (waves × 10) + 8 weeks.

---

## COST ESTIMATION (ROM)

Use these ROM figures when no actual data is provided:

| Item | Default |
|---|---|
| Cloud annual run cost | 35% of current annualCostUsd (cloud efficiency saving) |
| Migration one-time cost per workload | $45,000 |
| Annual savings per workload | $28,000 |
| 1-year net position | savings − migration cost |
| 3-year net position | (3 × savings) − migration cost |
| ROI break-even | migration cost ÷ annual savings (months) |

If annualCostUsd is provided, calculate:
- Cloud annual cost = annualCostUsd × 0.65
- Annual saving = annualCostUsd × 0.35
- Migration one-time cost = $45,000 per workload (Rehost) — scale up 2× for Replatform, 5× for Refactor
- Break-even months = migration cost ÷ (annual saving ÷ 12)

---

## CARBON IMPACT ESTIMATION

Constants (IEA 2023 / Uptime Institute / cloud provider data):
- On-prem grid intensity: **0.357 kgCO₂/kWh** (IEA 2023 global average)
- Cloud grid intensity: **0.088 kgCO₂/kWh** (hyperscaler renewable commitments)
- On-prem PUE: **1.58** (Uptime Institute 2023 global average)
- Cloud PUE: **1.12** (hyperscaler average)
- Default server power: **300W** at average utilisation
- Cloud utilisation improvement factor: **2× efficiency** (shared infrastructure)

Calculation:
- On-prem annual kWh = servers × 300W × 8,760h × PUE_onprem ÷ 1,000
- Cloud annual kWh = (on-prem kWh ÷ 2) × (PUE_cloud ÷ PUE_onprem)
- On-prem CO₂ = on-prem kWh × 0.357
- Cloud CO₂ = cloud kWh × 0.088
- Reduction % = (on-prem CO₂ − cloud CO₂) ÷ on-prem CO₂ × 100
- Car km equivalent = CO₂ saved kg ÷ 0.171 (avg passenger car, IEA)

---

## OUTPUT FORMATS

### Full Assessment Output
```
# Migration Assessment: [workload name]

## Summary
| Field | Value |
|---|---|
| Migration Candidate Score | XX/100 |
| Readiness | [Cloud Ready / Conditionally Ready / Needs Preparation / Not Ready] |
| Recommended Strategy | [Strategy] (Effort: X, Risk: X) |
| Alternative Strategies | [A], [B] |
| Estimated Effort | [Low/Medium/High] |

## Strategy Rationale
[Bulleted rationale]

## Guardrail Violations
[Table of violations with severity and remediation, or ✅ None detected]

## Scoring Breakdown
[Table of criteria with score contribution]
```

### Red Flag Output
```
# Red Flag Triage: [workload name]

## Overall Verdict: [emoji] [verdict]
| Severity | Count |
|---|---|
| 🔴 BLOCKER | N |
| 🟠 HIGH | N |
| 🟡 MEDIUM | N |
| 🟢 WARNING | N |

## Red Flags
### 🔴 BLOCKER
#### [RF-BLOCKER-001] [title]
**Detail:** ...
**Recommendation:** ...
**Source:** ...
```

### Portfolio Report Output
```
# Portfolio Migration Report — [N] workloads

## Readiness Summary
| Band | Count | % |
| Cloud Ready (≥75) | N | X% |
| Conditionally Ready (55–74) | N | X% |
| Needs Preparation (35–54) | N | X% |
| Not Ready (<35) | N | X% |

## Strategy Distribution
[Table of strategy counts]

## Score Heatmap
[Table: workload name | score | strategy | readiness]

## Top Blockers
[Most common guardrail violations across portfolio]

## ROM Cost Estimate
| Item | Value |
|---|---|
| Total migration cost | $X |
| Total annual saving | $X/yr |
| Average break-even | X months |

## Wave Plan Summary
[N waves, estimated programme duration: X weeks]
```

---

## SOURCES

All criteria, red flags, and guardrails are sourced from: AWS MAP, AWS Prescriptive Guidance, Azure Cloud Adoption Framework (CAF), GCP Cloud Adoption Framework, Gartner (6 Ways Cloud Migration Costs Go Off the Rails; 10 Common Cloud Strategy Mistakes), IBM Garage methodology, IBM Rapid Assessment, DXC Technology, TCS Mainframe Factory, BMC (Top 5 Reasons Mainframe Migrations Fail), mLogica, Uptime Institute 2025, PCI DSS v4.0, CIS Docker Benchmark, 12factor.net, CNCF, IEA 2023.
