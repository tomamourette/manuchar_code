# Azure DevOps Project Management Setup

This guide defines how we structure work in Azure DevOps so it stays in sync with the MS Project WBS, supports role-based execution and time tracking, and reflects delivery priority by Waves and Phases.

## Goals
- Keep 1:1 parity with MS Project WBS at the User Story level (via WBS ID in the title).
- Track delivery and source onboarding in Phase 5 while keeping earlier phases visible.
- Enforce Role at the Task level using the built-in `Activity` field (single assignee, time booking per person).
- Make cross-Wave priority clear and reportable (Epics by Wave).
- Standardise tags for WBS and Use Case so Features, Stories and Tasks are easy to query and report on.

## Backlog Hierarchy
- Epic: Wave container
  - Naming: `Wave {N} — {Name or Timeline}` (e.g., `Wave 1 — Q1 Priority`).
  - Scope: All Features (Phases) and Use Case work that belong to the Wave window.
- Feature: Phase bucket per Use Case
  - Naming: `[UC{ID}] P{Phase} {Short Phase Name}`
  - Examples: `[UC8] P1 Determine Information Needs`, `[UC8] P5 Implement Roadmap`.
  - Note: Phase 5 Features include all delivery and source onboarding stories.
- User Story: Single WBS line instance (deliverable/governance or per-source)
  - Deliverable/governance stories map 1:1 to WBS lines.
  - Source-instance stories (Phase 5, e.g., 5.2.*) are cloned per source but keep the same WBS ID.
- Task: Single person’s unit of work (time booking, role-specific via `Activity`).

## Areas and Iterations
- Areas: one per Use Case (e.g., `UC8`), plus optional cross-cutting areas (e.g., `Shared/Backbone`).
  - We use Area to represent the UC from a team/ownership perspective; no separate `UC` field is needed.
- Iterations: sprint cadence aligned to the MS Project schedule (dates match the plan).

## Fields and Rules (Lean)
- User Story
  - No custom field for `WBS ID`, `UC`, `Phase`, `Source`, or `Deliverable`.
  - Those attributes are expressed through naming, Area and tags:
    - UC → Area path (e.g., `UC8`).
    - WBS ID → in title prefix.
    - Phase → derivable from WBS ID, not a separate field.
    - Source (when applicable) → in title suffix.
    - Deliverable (when applicable) → in title suffix.
    - Tags:
      - `WBS:{ID}` (e.g., `WBS:1.1`) on the Story.
      - `UC{ID} - {Name}` (e.g., `UC8 - Purchase`) matching the owning Feature.
- Task
  - Use `Microsoft.VSTS.Common.Activity` as the required Role field; extend values to match roles (Design, Data Engineering, BI Data Engineering, DevOps, Testing, Documentation, Requirements).
  - No copy-down custom fields from Story; Tasks inherit UC via Area and context via parent link.
  - Tags: copy the Story’s tags so each Task has the same `WBS:{ID}` and `UC{ID} - {Name}` values (e.g., `WBS:2.5; UC8 - Purchase`).
- Validation (recommended)
  - Require `Activity` on Task.
  - Optional: policy to encourage the naming patterns below.

### Use Case Tags (UC)
Use Case tags standardise naming across Features, Stories and Tasks. We use the following tags:
- `UC2 - Sales and Margins`
- `UC3 - Invoices Receivable`
- `UC4 - Invoices Payable`
- `UC5 - Stock`
- `UC6 - Overheads`
- `UC7 - Order Intake`
- `UC8 - Purchase`

Each Feature, Story and Task for a given use case includes the corresponding tag (e.g., `UC8 - Purchase`) alongside its `WBS:{ID}` tag.

## Naming Conventions
- Epic (Wave): `Wave {N} — {Name}` (e.g., `Wave 2 — Q2 Delivery`).
- Feature (Phase per UC): `[UC{ID}] P{N} {Phase Name}`.
- User Story — deliverable/governance: `[UC{ID}] {WBS ID} {Task Name}`.
- User Story — source-instance: `[UC{ID}] {WBS ID} {Task Name} — Source: {System}`.
- Task: `[UC{ID}] {WBS ID} [{Activity}] — {Action/Artifact}`.

## Dependency Model (Story Level)
- Use Predecessor/Successor links between Stories to mirror WBS sequencing. (work item links in devops)

## Definition of Ready (DoR)
- Epic (Wave)
  - Wave scope and timeline agreed; UC list enumerated.
  - Entry criteria: funding/approval recorded; risks and cross-Wave dependencies captured.
  - Delivery Plans updated to include the Epic.
- Feature (Phase per UC)
  - Area set to UC; Phase implied by Feature title.
  - Stakeholders identified; entry/exit criteria defined.
  - Dependencies to previous phases (P1–P4) linked.
- User Story (WBS line / deliverable)
  - Title follows naming: `[UC] {WBS} {Name}` (+ `— Source: …` when applicable).
  - Description includes the WBS Title/Description; acceptance criteria added.
  - Dependencies linked.
  - Sign‑off: use a dedicated WBS story (as per MS Project WBS), not per story fields.
- Task (per person)
  - Title follows naming: `[UC] {WBS} [{Activity}] — {Action/Artifact}`.
  - `Activity` set (required), estimate provided (hours), acceptance notes clear.
  - Links to code/docs/test artifacts as relevant.

## Templates (Work Item Templates)
- Feature template: `[UC{ID}] P{N} {Phase Name}` (Area set to the UC).
- Story template — Deliverable
  - Title pattern: `[UC{ID}] {WBS ID} {Task Name}`.
  - Body seeded with WBS Title/Description.
  - Child Task templates per typical roles (BI DE model; DE orchestration; DevOps release gates).
- Story template — Source Instance
  - Title pattern: `[UC{ID}] {WBS ID} {Task Name} — Source: {System}`.
  - Child Task templates for DE connectivity/config, mapping, DQ, orchestration, testing.
- Task templates (by Activity)
  - Design, Data Engineering, BI Data Engineering, DevOps, Testing, Documentation.

## Boards and Views
- Delivery Plans
  - Plan 1: `Waves` — lanes by Epic (Wave) with Features (Phases) and Stories visible; dependency lines on Stories.
  - Plan 2: `UC Delivery` — lanes by Area (UC), grouped by Feature (Phase); filter to Phase 5 for delivery focus.
- Dashboards
  - Deliverables Status (Phase 5 stories filtered by WBS patterns 5.x or linked to the UC sign‑off story), by UC/Phase.
  - Source Onboarding (Stories with `— Source:` in title, grouped by UC and source).
  - Time vs Estimate (Task Remaining/Completed Work rolled up by WBS tag and `Activity`).

## Reporting
- Use Azure DevOps Analytics (or Power BI). Derive keys from tags first, with title/Area as fallback:
  - UC:
    - Preferred: from tag `UC{ID} - {Name}` (e.g., `UC8 - Purchase`).
    - Fallback: from Area path (e.g., `UC8`).
  - WBS ID:
    - Preferred: from tag `WBS:{ID}` (e.g., `WBS:2.5`).
    - Fallback: parse from title prefix `(\d+(?:\.\d+)*)` after `[UCx]`.
  - Source: parse `— Source: (.+)$` when present.
  - Deliverable: inferred from Phase 5 WBS patterns (5.3/5.4/5.5/5.6) or explicit sign‑off linkage.
- Key reports
  - Baseline vs Actual effort per WBS and Activity.
  - Deliverables done vs planned per UC.
  - Per‑source progress across 5.2.* WBS lines.

## Working Agreements
- One WBS line → one Story; duplicate as source-instance stories where needed in Phase 5.
- Every participating role creates their own Task(s) under the Story; each Task has exactly one assignee and `Activity` set.
- Tasks are sized 4–16 hours; split if they cross sprints.
- Only Phase 5 deliverable Stories require business sign‑off; add a distinct WBS story for final UC sign‑off per the WBS.

## Examples
- Epic: `Wave 1 — Q1 Priority`
- Feature: `[UC8] P5 Implement Roadmap`
- Story (deliverable): `[UC8] 5.3.4 Create semantic model`
- Story (source-instance): `[UC8] 5.2.4.2 Data SourceSync replication — Source: SAPBE`
- Task: `[UC8] 5.2.4.2 [Data Engineering] — Build replication job for Company, Customer tables`

---
This setup keeps MS Project WBS as the reference plan while making DevOps the system of execution. It captures role-based work at the Task level (via Activity), supports per‑source tracking in Phase 5, and enables Wave → Phase → UC visibility for planning and reporting.
