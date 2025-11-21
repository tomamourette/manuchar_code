| Page Status: In Review |
|--|

# Overview
The Data & Insights Landscape 2.0 programme modernises how we ingest, curate and serve data for analytics across the organisation. The Data BackBone (DBB) initiative delivers the first domain on Microsoft Fabric and sets the patterns that every next domain will reuse.

## Why we invest
- Replace fragmented spreadsheet based processes with governed, automated data products.
- Land each source once and expose reusable curated layers instead of duplicating feeds per use case.
- Reduce production support effort by automating operations, monitoring and recovery.
- Enforce security and data ownership in a consistent way across domains.

## 2025 focus
- Deliver the Finance domain on Fabric across ingestion, transformation and consumption workloads.
- Run four managed environments (TST, ACC, QUAL, PRD) with automated deployments and runbooks.
- Document run procedures, SLAs and guardrails so new team members can onboard quickly.

## Guiding principles
- **Single source of truth:** data lands once in the integration layer and flows into curated silver and gold outputs.
- **Automation first:** templates drive pipelines, tests, deployments and documentation.
- **Metadata driven:** connection details, schedules and ownership live in structured metadata (for example `integration_sources.csv`) and are reused by pipelines.
- **Secure by design:** least privilege is enforced by workspace roles, Fabric item permissions and semantic model security.
- **Observable:** health dashboards, alerting notebooks and audit tables are mandatory for every workload.

## Platform building blocks
- [[Data-BackBone-Solution-Design-Documentation]] captures the conceptual architecture, guardrails and patterns.
- [[Data-BackBone-Fabric-Implementation-Documentation]] maps those patterns to concrete Fabric items in the `fabric/` folder.
- [[Data-&-Insights-Landscape-(2.0)/DevOps-Guidlines]] describes branching, CI/CD, approvals and runbooks.
- [[Data-&-Insights-Landscape-(2.0)/31.-Source-Data-&-Agreements]] is the authoritative directory of incoming sources and agreements.

## How to use this wiki
1. Start in this section when you need programme context or stakeholder messaging.
2. Move to the Solution Design section when preparing new work packages or change requests.
3. Use the Fabric Implementation section when you deploy, troubleshoot or extend Fabric assets.
4. Reference DevOps and Monitoring pages for daily operations, incident response and release readiness.

## Revision workflow
- Update the relevant section when changes land in `data.backbone` or Fabric.
- Flag open questions or follow up actions with `TODO` blocks and assign owners in Azure DevOps.
- Raise merge requests for content updates together with code changes so the documentation stays current.
