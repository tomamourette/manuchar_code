## UC8 – WBS to DevOps mapping (Phases 3–6)

This document lists the User Stories and Tasks for **UC8, Phases 3–6 (WBS 3.x–6.x)** and the information needed to (re)create or validate them via the Azure DevOps MCP.

Common/default field values for all work items:

- `AreaPath`: `Databackbone`
- `IterationPath`: `Databackbone`
- `Tags`: always include `UC8 - Purchase` and the WBS tag `WBS:{WBS id}` (for example `WBS:3.4`)
- `Parent` relationship:
  - All 3.x User Stories are children of Feature **79177** (`[UC8] P3 Solution scope & architectural design`).
  - All 3.x Tasks are children of the corresponding 3.x User Story.
  - All 4.x User Stories are children of Feature **79178** (`[UC8] P4 Impact analysis per UC`).
  - All 4.x Tasks are children of the corresponding 4.x User Story.
  - All 5.x User Stories are children of Feature **79179** (`[UC8] P5 Implement roadmap`).
  - All 5.x Tasks are children of the corresponding 5.x User Story.
  - All 6.x User Stories are children of Feature **79180** (`[UC8] P6 Closure / Business readiness`).
  - All 6.x Tasks are children of the corresponding 6.x User Story.

Additional fields MCP needs when creating items (per row):

- `WorkItemType` (`User Story` or `Task`)
- `Title`
- `Description`
- `OriginalEstimateHours` (for Tasks; 0 or empty for Stories)
- `ParentWbsId` (for Tasks – the WBS id of their parent Story)
- `ParentDevOpsId` (when an existing parent item already exists)

DevOps IDs are filled where the work item already exists in Azure DevOps, otherwise left blank for future creation.

> Note: hours are derived from `PM/WBS tasks.csv` as `days × 8`.

### How to use this mapping with MCP / Azure DevOps

This section is for the next worker or automation using the Azure DevOps MCP.

1. **Creating User Stories**
   - For each row with `WorkItemType = User Story` and empty `DevOpsId`:
     - Call `wit_create_work_item` with:
       - `System.Title` = `Title`
       - `System.AreaPath` and `System.IterationPath` as above
       - `System.Description` = `Description (short)` or a richer HTML description if desired
       - `System.Tags` including `UC8 - Purchase; WBS:{WbsId}`
     - Then call `wit_work_items_link` to set the parent:
       - Feature DevOpsId for:
         - 3.x = `79177`
         - 4.x = `79178`
         - 5.x = `79179`
         - 6.x = `79180`
     - Record the new `DevOpsId` back into this table.

2. **Creating Tasks**
   - For each row with `WorkItemType = Task` and empty `DevOpsId`:
     - Ensure the parent User Story exists (either via an existing `DevOpsId` in the mapping, or by creating it first using the step above).
     - Call `wit_create_work_item` with:
       - `System.Title` = `Title`
       - `System.AreaPath` / `System.IterationPath` as above
       - `System.Description` summarising the role and WBS (you can reuse `Description (short)` and the role)
       - `System.Tags` including `UC8 - Purchase; WBS:{WbsId}`
       - `Microsoft.VSTS.Scheduling.OriginalEstimate` = `OriginalEstimateHours`
       - `Microsoft.VSTS.Scheduling.RemainingWork` = `OriginalEstimateHours`
     - Link the Task to its parent Story via `wit_work_items_link`:
       - Use `ParentDevOpsId` if present; otherwise look up the User Story row with the same `WbsId` to get the parent Story `DevOpsId`.
     - Record the new `DevOpsId` in this table.

3. **Validation**
   - After creation, you can:
     - Re-query the work items by `DevOpsId` and verify `OriginalEstimate`, `Tags` and parent relationships match the mapping.
     - Update this document when new IDs are created or titles are adjusted.

### Phase 3 – Stories and Tasks

| WbsId | WorkItemType | DevOpsId | ParentDevOpsId | ParentWbsId | Title | Description (short) | OriginalEstimateHours |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 3.1 | User Story | 79872 | 79177 |  | \[UC8] 3.1 Describe high-level MIM business requirements (integration with existing data platforms) | Overview in Excel on Manuchar harmonized data model |  |
| 3.1 | Task | 79873 | 79872 | 3.1 | \[UC8] 3.1 \[Functional Analyst] — Describe high-level MIM business requirements (integration with existing data platforms) | Role: Functional Analyst | 2.4 |
| 3.1 | Task | 79874 | 79872 | 3.1 | \[UC8] 3.1 \[Data Domain Architect Integration & Reporting/] — Describe high-level MIM business requirements (integration with existing data platforms) | Role: Data Domain Architect Integration & Reporting/ | 32.0 |
| 3.1 | Task | 79875 | 79872 | 3.1 | \[UC8] 3.1 \[Scrum Master] — Describe high-level MIM business requirements (integration with existing data platforms) | Role: Scrum Master | 0.3 |
| 3.1 | Task | 79876 | 79872 | 3.1 | \[UC8] 3.1 \[PM] — Describe high-level MIM business requirements (integration with existing data platforms) | Role: PM | 1.6 |
| 3.2 | User Story | 79947 | 79177 |  | \[UC8] 3.2 Describe data process (layer definitions, layer requirements and expectations, naming standards, interface agreements, templates) | Solution concept for all capabilities (business & DataOps requirements) |  |
| 3.2 | Task | 79948 | 79947 | 3.2 | \[UC8] 3.2 \[Functional Analyst] — Describe data process… | Role: Functional Analyst | 8.0 |
| 3.2 | Task | 79949 | 79947 | 3.2 | \[UC8] 3.2 \[Data Domain Architect Integration & Reporting/] — Describe data process… | Role: Data Domain Architect Integration & Reporting/ | 64.0 |
| 3.2 | Task | 79950 | 79947 | 3.2 | \[UC8] 3.2 \[Design review] — Describe data process… | Role: Design review | 24.0 |
| 3.2 | Task | 79951 | 79947 | 3.2 | \[UC8] 3.2 \[Scrum Master] — Describe data process… | Role: Scrum Master | 4.0 |
| 3.2 | Task | 79952 | 79947 | 3.2 | \[UC8] 3.2 \[PM] — Describe data process… | Role: PM | 1.6 |
| 3.3 | User Story | 79953 | 79177 |  | \[UC8] 3.3 Describe in detail non-functionals & principals | Solution concept for all capabilities (non-functionals & principles) |  |
| 3.3 | Task | 79955 | 79953 | 3.3 | \[UC8] 3.3 \[Functional Analyst] — Describe in detail non-functionals & principals | Role: Functional Analyst | 2.4 |
| 3.3 | Task | 79956 | 79953 | 3.3 | \[UC8] 3.3 \[Data Domain Architect Integration & Reporting/] — Describe in detail non-functionals & principals | Role: Data Domain Architect Integration & Reporting/ | 24.0 |
| 3.3 | Task | 79957 | 79953 | 3.3 | \[UC8] 3.3 \[Design review] — Describe in detail non-functionals & principals | Role: Design review | 16.0 |
| 3.3 | Task | 79958 | 79953 | 3.3 | \[UC8] 3.3 \[Scrum Master] — Describe in detail non-functionals & principals | Role: Scrum Master | 2.3 |
| 3.3 | Task | 79959 | 79953 | 3.3 | \[UC8] 3.3 \[PM] — Describe in detail non-functionals & principals | Role: PM | 1.6 |
| 3.4 | User Story | 79960 | 79177 |  | \[UC8] 3.4 Security & compliance design (generieke design-patronen) | Security & compliance design patterns |  |
| 3.4 | Task | 79961 | 79960 | 3.4 | \[UC8] 3.4 \[Functional Analyst] — Security & compliance design… | Role: Functional Analyst | 2.4 |
| 3.4 | Task | 79962 | 79960 | 3.4 | \[UC8] 3.4 \[Data Domain Architect Integration & Reporting/] — Security & compliance design… | Role: Data Domain Architect Integration & Reporting/ | 16.0 |
| 3.4 | Task | 79963 | 79960 | 3.4 | \[UC8] 3.4 \[Design review] — Security & compliance design… | Role: Design review | 4.0 |
| 3.4 | Task | 79964 | 79960 | 3.4 | \[UC8] 3.4 \[Scrum Master] — Security & compliance design… | Role: Scrum Master | 0.8 |
| 3.4 | Task | 79965 | 79960 | 3.4 | \[UC8] 3.4 \[PM] — Security & compliance design… | Role: PM | 1.6 |
| 3.5 | User Story | 79966 | 79177 |  | \[UC8] 3.5 Define infra & technology changes (PoC evaluation, infra impact) | Infra/technology PoC evaluation & infra impact |  |
| 3.5 | Task | 79967 | 79966 | 3.5 | \[UC8] 3.5 \[Data Domain Architect Integration & Reporting/] — Define infra & technology changes… | Role: Data Domain Architect Integration & Reporting/ | 4.0 |
| 3.5 | Task | 79968 | 79966 | 3.5 | \[UC8] 3.5 \[Infra  MHQ/Region] — Define infra & technology changes… | Role: Infra  MHQ/Region | 16.0 |
| 3.5 | Task | 79969 | 79966 | 3.5 | \[UC8] 3.5 \[PM] — Define infra & technology changes… | Role: PM | 1.6 |
| 3.6 | User Story | 79970 | 79177 |  | \[UC8] 3.6 Define software development lifecycle changes & CI/CD | SDLC changes & CI/CD requirements |  |
| 3.6 | Task |  | 79970 | 3.6 | \[UC8] 3.6 \[Data Domain Architect Integration & Reporting/] — Define SDLC changes & CI/CD | Role: Data Domain Architect Integration & Reporting/ | 4.0 |
| 3.6 | Task |  | 79970 | 3.6 | \[UC8] 3.6 \[Design review] — Define SDLC changes & CI/CD | Role: Design review | 8.0 |
| 3.6 | Task |  | 79970 | 3.6 | \[UC8] 3.6 \[BI Data Engineer] — Define SDLC changes & CI/CD | Role: BI Data Engineer | 4.0 |
| 3.6 | Task |  | 79970 | 3.6 | \[UC8] 3.6 \[DevOps Engineer/ Automation Expert] — Define SDLC changes & CI/CD | Role: DevOps Engineer/ Automation Expert | 16.0 |
| 3.6 | Task |  | 79970 | 3.6 | \[UC8] 3.6 \[Scrum Master] — Define SDLC changes & CI/CD | Role: Scrum Master | 5.5 |
| 3.6 | Task |  | 79970 | 3.6 | \[UC8] 3.6 \[PM] — Define SDLC changes & CI/CD | Role: PM | 1.6 |
| 3.7 | User Story |  | 79177 |  | \[UC8] 3.7 Define data governance requirements | Data governance requirements and guidelines |  |
| 3.7 | Task |  |  | 3.7 | \[UC8] 3.7 \[Data Domain Architect Integration & Reporting/] — Define data governance requirements | Role: Data Domain Architect Integration & Reporting/ | 4.0 |
| 3.7 | Task |  |  | 3.7 | \[UC8] 3.7 \[Data Governance Manager] — Define data governance requirements | Role: Data Governance Manager | 40.0 |
| 3.7 | Task |  |  | 3.7 | \[UC8] 3.7 \[PM] — Define data governance requirements | Role: PM | 1.6 |
| 3.8 | User Story |  | 79177 |  | \[UC8] 3.8 Organize data-product impact and high-level solution for semantic model & reports | Impact & high-level solution for semantic model & reports |  |
| 3.8 | Task |  |  | 3.8 | \[UC8] 3.8 \[Functional Analyst] — Organize data-product impact & solution | Role: Functional Analyst | 16.0 |
| 3.8 | Task |  |  | 3.8 | \[UC8] 3.8 \[Scrum Master] — Organize data-product impact & solution | Role: Scrum Master | 2.0 |
| 3.8 | Task |  |  | 3.8 | \[UC8] 3.8 \[PM] — Organize data-product impact & solution | Role: PM | 1.6 |
| 3.9 | User Story |  | 79177 |  | \[UC8] 3.9 Define job-orchestration, exception handling & process and quality impact | Job orchestration, exception handling & process/quality impact |  |
| 3.9 | Task |  |  | 3.9 | \[UC8] 3.9 \[Data Domain Architect Integration & Reporting/] — Define job-orchestration & impact | Role: Data Domain Architect Integration & Reporting/ | 8.0 |
| 3.9 | Task |  |  | 3.9 | \[UC8] 3.9 \[Design review] — Define job-orchestration & impact | Role: Design review | 8.0 |
| 3.9 | Task |  |  | 3.9 | \[UC8] 3.9 \[Scrum Master] — Define job-orchestration & impact | Role: Scrum Master | 1.0 |
| 3.9 | Task |  |  | 3.9 | \[UC8] 3.9 \[PM] — Define job-orchestration & impact | Role: PM | 1.6 |
| 3.10 | User Story |  | 79177 |  | \[UC8] 3.10 Receiving input/requirements of the data-model from BI-expert of legacy reports | Transition planning for legacy data processes and reporting |  |
| 3.10 | Task |  |  | 3.10 | \[UC8] 3.10 \[Functional Analyst] — Receive input/requirements from BI expert | Role: Functional Analyst | 8.0 |
| 3.10 | Task |  |  | 3.10 | \[UC8] 3.10 \[Scrum Master] — Receive input/requirements from BI expert | Role: Scrum Master | 1.0 |
| 3.10 | Task |  |  | 3.10 | \[UC8] 3.10 \[PM] — Receive input/requirements from BI expert | Role: PM | 1.6 |
| 3.11 | User Story |  | 79177 |  | \[UC8] 3.11 Define quality criteria (SIT & regression testing, reconciliation checks, …) | Quality criteria for SIT & regression testing, reconciliation |  |
| 3.11 | Task |  |  | 3.11 | \[UC8] 3.11 \[Data Domain Architect Integration & Reporting/] — Define quality criteria | Role: Data Domain Architect Integration & Reporting/ | 16.0 |
| 3.11 | Task |  |  | 3.11 | \[UC8] 3.11 \[Design review] — Define quality criteria | Role: Design review | 4.0 |
| 3.11 | Task |  |  | 3.11 | \[UC8] 3.11 \[Scrum Master] — Define quality criteria | Role: Scrum Master | 0.5 |
| 3.11 | Task |  |  | 3.11 | \[UC8] 3.11 \[PM] — Define quality criteria | Role: PM | 1.6 |

### Phase 4 – Stories and Tasks

| WbsId | WorkItemType | DevOpsId | ParentDevOpsId | ParentWbsId | Title | Description (short) | OriginalEstimateHours |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 4.1 | User Story |  | 79178 |  | \[UC8] 4.1 (Functionele) scope: business requirements, gap analyses & define sources | Scope & gap analysis vs backbone capabilities, define sources |  |
| 4.1 | Task |  |  | 4.1 | \[UC8] 4.1 \[Data Product Owner] — Define scope & gaps | Role: Data Product Owner | 16.0 |
| 4.1 | Task |  |  | 4.1 | \[UC8] 4.1 \[Functional Analyst] — Define scope & gaps | Role: Functional Analyst | 16.0 |
| 4.1 | Task |  |  | 4.1 | \[UC8] 4.1 \[Design review] — Define scope & gaps | Role: Design review | 16.0 |
| 4.1 | Task |  |  | 4.1 | \[UC8] 4.1 \[Scrum Master] — Define scope & gaps | Role: Scrum Master | 4.0 |
| 4.1 | Task |  |  | 4.1 | \[UC8] 4.1 \[PM] — Define scope & gaps | Role: PM | 8.0 |
| 4.2 | User Story |  | 79178 |  | \[UC8] 4.2 Test approach/requirements + list of testers | Test approach, requirements & tester list |  |
| 4.2 | Task |  |  | 4.2 | \[UC8] 4.2 \[Data Product Owner] — Define test approach | Role: Data Product Owner | 24.0 |
| 4.2 | Task |  |  | 4.2 | \[UC8] 4.2 \[Functional Analyst] — Define test approach | Role: Functional Analyst | 32.0 |
| 4.2 | Task |  |  | 4.2 | \[UC8] 4.2 \[Scrum Master] — Define test approach | Role: Scrum Master | 4.0 |
| 4.2 | Task |  |  | 4.2 | \[UC8] 4.2 \[PM] — Define test approach | Role: PM | 8.0 |
| 4.3 | User Story |  | 79178 |  | \[UC8] 4.3 Business readiness and rollout requirements | Business readiness & rollout requirements |  |
| 4.3 | Task |  |  | 4.3 | \[UC8] 4.3 \[Functional Analyst] — Define readiness & rollout requirements | Role: Functional Analyst | 16.0 |
| 4.3 | Task |  |  | 4.3 | \[UC8] 4.3 \[Scrum Master] — Define readiness & rollout requirements | Role: Scrum Master | 2.0 |
| 4.3 | Task |  |  | 4.3 | \[UC8] 4.3 \[PM] — Define readiness & rollout requirements | Role: PM | 8.0 |
| 4.4 | User Story |  | 79178 |  | \[UC8] 4.4 Define Data-Quality checks required to monitor business data-health | Define DQ checks to monitor business data health |  |
| 4.4 | Task |  |  | 4.4 | \[UC8] 4.4 \[Data Product Owner] — Define DQ checks | Role: Data Product Owner | 8.0 |
| 4.4 | Task |  |  | 4.4 | \[UC8] 4.4 \[Functional Analyst] — Define DQ checks | Role: Functional Analyst | 12.0 |
| 4.4 | Task |  |  | 4.4 | \[UC8] 4.4 \[Design review] — Define DQ checks | Role: Design review | 4.0 |
| 4.4 | Task |  |  | 4.4 | \[UC8] 4.4 \[Scrum Master] — Define DQ checks | Role: Scrum Master | 2.0 |
| 4.4 | Task |  |  | 4.4 | \[UC8] 4.4 \[PM] — Define DQ checks | Role: PM | 8.0 |
| 4.5 | User Story |  | 79178 |  | \[UC8] 4.5 Define training requirements for functional analysts/developers | Training requirements on business process & technical background |  |
| 4.5 | Task |  |  | 4.5 | \[UC8] 4.5 \[Data Product Owner] — Define training requirements | Role: Data Product Owner | 2.4 |
| 4.5 | Task |  |  | 4.5 | \[UC8] 4.5 \[Functional Analyst] — Define training requirements | Role: Functional Analyst | 8.0 |
| 4.5 | Task |  |  | 4.5 | \[UC8] 4.5 \[Scrum Master] — Define training requirements | Role: Scrum Master | 1.0 |
| 4.5 | Task |  |  | 4.5 | \[UC8] 4.5 \[PM] — Define training requirements | Role: PM | 8.0 |
| 4.6 | User Story |  | 79178 |  | \[UC8] 4.6 Define resource (capacity) impact for each deliverable | Resource/capacity impact per deliverable |  |
| 4.6 | Task |  |  | 4.6 | \[UC8] 4.6 \[Data Product Owner] — Define capacity impact | Role: Data Product Owner | 2.4 |
| 4.6 | Task |  |  | 4.6 | \[UC8] 4.6 \[Functional Analyst] — Define capacity impact | Role: Functional Analyst | 4.0 |
| 4.6 | Task |  |  | 4.6 | \[UC8] 4.6 \[Scrum Master] — Define capacity impact | Role: Scrum Master | 8.5 |
| 4.6 | Task |  |  | 4.6 | \[UC8] 4.6 \[PM] — Define capacity impact | Role: PM | 8.0 |
| 4.7 | User Story |  | 79178 |  | \[UC8] 4.7 Define risks & dependencies | Risks & dependencies |  |
| 4.7 | Task |  |  | 4.7 | \[UC8] 4.7 \[Design review] — Define risks & dependencies | Role: Design review | 4.0 |
| 4.7 | Task |  |  | 4.7 | \[UC8] 4.7 \[Scrum Master] — Define risks & dependencies | Role: Scrum Master | 0.5 |
| 4.7 | Task |  |  | 4.7 | \[UC8] 4.7 \[PM] — Define risks & dependencies | Role: PM | 8.0 |
| 4.8 | User Story |  | 79178 |  | \[UC8] 4.8 Make budget & benefits estimation | Budget & benefits estimation |  |
| 4.8 | Task |  |  | 4.8 | \[UC8] 4.8 \[Data Product Owner] — Make budget & benefits estimation | Role: Data Product Owner | 4.0 |
| 4.8 | Task |  |  | 4.8 | \[UC8] 4.8 \[Design review] — Make budget & benefits estimation | Role: Design review | 1.6 |
| 4.8 | Task |  |  | 4.8 | \[UC8] 4.8 \[Scrum Master] — Make budget & benefits estimation | Role: Scrum Master | 0.2 |
| 4.8 | Task |  |  | 4.8 | \[UC8] 4.8 \[PM] — Make budget & benefits estimation | Role: PM | 8.0 |
| 4.9 | User Story |  | 79178 |  | \[UC8] 4.9 Task prioritization & sign-off | Task prioritization & sign-off |  |
| 4.9 | Task |  |  | 4.9 | \[UC8] 4.9 \[Data Product Owner] — Prioritize tasks & sign-off | Role: Data Product Owner | 4.0 |
| 4.9 | Task |  |  | 4.9 | \[UC8] 4.9 \[Functional Analyst] — Prioritize tasks & sign-off | Role: Functional Analyst | 2.4 |
| 4.9 | Task |  |  | 4.9 | \[UC8] 4.9 \[Design review] — Prioritize tasks & sign-off | Role: Design review | 2.4 |
| 4.9 | Task |  |  | 4.9 | \[UC8] 4.9 \[Scrum Master] — Prioritize tasks & sign-off | Role: Scrum Master | 0.6 |
| 4.9 | Task |  |  | 4.9 | \[UC8] 4.9 \[PM] — Prioritize tasks & sign-off | Role: PM | 8.0 |
| 4.10 | User Story |  | 79178 |  | \[UC8] 4.10 Define job orchestration impact & approach for UC | Job orchestration impact & approach |  |
| 4.10 | Task |  |  | 4.10 | \[UC8] 4.10 \[Functional Analyst] — Define job orchestration impact | Role: Functional Analyst | 1.6 |
| 4.10 | Task |  |  | 4.10 | \[UC8] 4.10 \[Design review] — Define job orchestration impact | Role: Design review | 2.4 |
| 4.10 | Task |  |  | 4.10 | \[UC8] 4.10 \[Data Engineer] — Define job orchestration impact | Role: Data Engineer | 2.4 |
| 4.10 | Task |  |  | 4.10 | \[UC8] 4.10 \[Scrum Master] — Define job orchestration impact | Role: Scrum Master | 0.8 |
| 4.10 | Task |  |  | 4.10 | \[UC8] 4.10 \[PM] — Define job orchestration impact | Role: PM | 8.0 |
| 4.11 | User Story |  | 79178 |  | \[UC8] 4.11 Define Manuchar readiness | Manuchar readiness |  |
| 4.11 | Task |  |  | 4.11 | \[UC8] 4.11 \[Data Product Owner] — Define readiness | Role: Data Product Owner | 4.0 |
| 4.11 | Task |  |  | 4.11 | \[UC8] 4.11 \[Functional Analyst] — Define readiness | Role: Functional Analyst | 2.4 |
| 4.11 | Task |  |  | 4.11 | \[UC8] 4.11 \[Data Domain Architect Integration & Reporting/] — Define readiness | Role: Data Domain Architect Integration & Reporting/ | 2.4 |
| 4.11 | Task |  |  | 4.11 | \[UC8] 4.11 \[Scrum Master] — Define readiness | Role: Scrum Master | 0.3 |
| 4.11 | Task |  |  | 4.11 | \[UC8] 4.11 \[PM] — Define readiness | Role: PM | 8.0 |

### Phase 5 – Stories and Tasks

| WbsId | WorkItemType | DevOpsId | ParentDevOpsId | ParentWbsId | Title | Description (short) | OriginalEstimateHours |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 5.1 | User Story |  | 79179 |  | \[UC8] 5.1 Develop detail analysis | Develop detailed analysis/backlog |  |
| 5.1.1 | User Story |  | 79179 |  | \[UC8] 5.1.1 Define effort on user story level (DoR) | Effort estimation on story level (DoR) |  |
| 5.1.1 | Task |  |  | 5.1.1 | \[UC8] 5.1.1 \[Design review] — Define effort on story level | Role: Design review | 16.0 |
| 5.1.1 | Task |  |  | 5.1.1 | \[UC8] 5.1.1 \[Scrum Master] — Define effort on story level | Role: Scrum Master | 2.0 |
| 5.1.1 | Task |  |  | 5.1.1 | \[UC8] 5.1.1 \[PM] — Define effort on story level | Role: PM | 4.0 |
| 5.1.2 | User Story |  | 79179 |  | \[UC8] 5.1.2 Define acceptance criteria | Acceptance criteria per story |  |
| 5.1.2 | Task |  |  | 5.1.2 | \[UC8] 5.1.2 \[Design review] — Define acceptance criteria | Role: Design review | 4.0 |
| 5.1.2 | Task |  |  | 5.1.2 | \[UC8] 5.1.2 \[Scrum Master] — Define acceptance criteria | Role: Scrum Master | 0.5 |
| 5.1.2 | Task |  |  | 5.1.2 | \[UC8] 5.1.2 \[PM] — Define acceptance criteria | Role: PM | 4.0 |
| 5.1.3 | User Story |  | 79179 |  | \[UC8] 5.1.3 Task prioritization | Task prioritization |  |
| 5.1.3 | Task |  |  | 5.1.3 | \[UC8] 5.1.3 \[Design review] — Task prioritization | Role: Design review | 4.0 |
| 5.1.3 | Task |  |  | 5.1.3 | \[UC8] 5.1.3 \[Scrum Master] — Task prioritization | Role: Scrum Master | 0.5 |
| 5.1.3 | Task |  |  | 5.1.3 | \[UC8] 5.1.3 \[PM] — Task prioritization | Role: PM | 2.4 |
| 5.2 | User Story |  | 79179 |  | \[UC8] 5.2 Describe Source → MIM data backbone | Source→MIM data backbone description |  |
| 5.2.1 | User Story |  | 79179 |  | \[UC8] 5.2.1 Detail MIM entities for specific UC | Detail MIM entities for UC |  |
| 5.2.1 | Task |  |  | 5.2.1 | \[UC8] 5.2.1 \[Functional Analyst] — Detail MIM entities | Role: Functional Analyst | 16.0 |
| 5.2.1 | Task |  |  | 5.2.1 | \[UC8] 5.2.1 \[Data Domain Architect Integration & Reporting/] — Detail MIM entities | Role: Data Domain Architect Integration & Reporting/ | 40.0 |
| 5.2.1 | Task |  |  | 5.2.1 | \[UC8] 5.2.1 \[Data Engineer] — Detail MIM entities | Role: Data Engineer | 8.0 |
| 5.2.2 | User Story |  | 79179 |  | \[UC8] 5.2.2 Communicate data requirements to affiliates (Source–MIM mapping) | Communicate data requirements & mapping file |  |
| 5.2.2 | Task |  |  | 5.2.2 | \[UC8] 5.2.2 \[Source owner/ Application supporter] — Communicate data requirements | Role: Source owner/ Application supporter | 64.0 |
| 5.2.2 | Task |  |  | 5.2.2 | \[UC8] 5.2.2 \[Data Domain Architect Integration & Reporting/] — Communicate data requirements | Role: Data Domain Architect Integration & Reporting/ | 32.0 |
| 5.2.2 | Task |  |  | 5.2.2 | \[UC8] 5.2.2 \[Data Engineer] — Communicate data requirements | Role: Data Engineer | 16.0 |
| 5.2.2 | Task |  |  | 5.2.2 | \[UC8] 5.2.2 \[Scrum Master] — Communicate data requirements | Role: Scrum Master | 2.0 |
| 5.2.2 | Task |  |  | 5.2.2 | \[UC8] 5.2.2 \[PM] — Communicate data requirements | Role: PM | 2.4 |
| 5.2.3 | User Story |  | 79179 |  | \[UC8] 5.2.3 Set up & implement Qlik | Set up & implement Qlik |  |
| 5.2.3.1 | User Story | 79877 | 79179 |  | \[UC8] 5.2.3.1 Infrastructure system installation (Technical SIT) for Source→MIM backbone | Infra system installation & SourceSync replication |  |
| 5.2.3.1 | Task | 79878 | 79877 | 5.2.3.1 | \[UC8] 5.2.3.1 \[Source owner/ Application supporter] — Infra system installation & SourceSync replication | Role: Source owner/ Application supporter | 280.0 |
| 5.2.3.1 | Task | 79879 | 79877 | 5.2.3.1 | \[UC8] 5.2.3.1 \[Infra  MHQ/Region] — Infra system installation & SourceSync replication | Role: Infra  MHQ/Region | 224.0 |
| 5.2.3.1 | Task | 79880 | 79877 | 5.2.3.1 | \[UC8] 5.2.3.1 \[Design review] — Infra system installation & SourceSync replication | Role: Design review | 128.0 |
| 5.2.3.1 | Task | 79881 | 79877 | 5.2.3.1 | \[UC8] 5.2.3.1 \[Scrum Master] — Infra system installation & SourceSync replication | Role: Scrum Master | 16.0 |
| 5.2.3.1 | Task | 79882 | 79877 | 5.2.3.1 | \[UC8] 5.2.3.1 \[PM] — Infra system installation & SourceSync replication | Role: PM | 2.4 |
| 5.2.3.2 | User Story |  | 79179 |  | \[UC8] 5.2.3.2 Data SourceSync replication (Qlik integration config) | Data SourceSync replication (Qlik config) |  |
| 5.2.3.2 | Task |  |  | 5.2.3.2 | \[UC8] 5.2.3.2 \[Design review] — Data SourceSync replication | Role: Design review | 16.0 |
| 5.2.3.2 | Task |  |  | 5.2.3.2 | \[UC8] 5.2.3.2 \[BI Data Engineer] — Data SourceSync replication | Role: BI Data Engineer | 112.0 |
| 5.2.3.2 | Task |  |  | 5.2.3.2 | \[UC8] 5.2.3.2 \[Scrum Master] — Data SourceSync replication | Role: Scrum Master | 16.0 |
| 5.2.4 | User Story |  | 79179 |  | \[UC8] 5.2.4 Implement bronze → MIM | Implement bronze→MIM |  |
| 5.2.4.1 | User Story |  | 79179 |  | \[UC8] 5.2.4.1 Create queries | Create queries for bronze→MIM |  |
| 5.2.4.1 | Task |  |  | 5.2.4.1 | \[UC8] 5.2.4.1 \[Source owner/ Application supporter] — Create queries | Role: Source owner/ Application supporter | 288.0 |
| 5.2.4.1 | Task |  |  | 5.2.4.1 | \[UC8] 5.2.4.1 \[Data Domain Architect Integration & Reporting/] — Create queries | Role: Data Domain Architect Integration & Reporting/ | 96.0 |
| 5.2.4.2 | User Story |  | 79179 |  | \[UC8] 5.2.4.2 Implement queries (ODS→CDS, mapping to MIM) | Implement ODS→CDS queries |  |
| 5.2.4.2 | Task |  |  | 5.2.4.2 | \[UC8] 5.2.4.2 \[Data Engineer] — Implement queries (ODS→CDS) | Role: Data Engineer | 96.0 |
| 5.2.4.2 | Task |  |  | 5.2.4.2 | \[UC8] 5.2.4.2 \[Scrum Master] — Implement queries (ODS→CDS) | Role: Scrum Master | 12.0 |
| 5.2.4.2 | Task |  |  | 5.2.4.2 | \[UC8] 5.2.4.2 \[PM] — Implement queries (ODS→CDS) | Role: PM | 2.4 |
| 5.2.5 | User Story |  | 79179 |  | \[UC8] 5.2.5 Execute testing | Execute testing |  |
| 5.2.5 | Task |  |  | 5.2.5 | \[UC8] 5.2.5 \[Functional Analyst] — Execute testing | Role: Functional Analyst | 24.0 |
| 5.2.5 | Task |  |  | 5.2.5 | \[UC8] 5.2.5 \[Data Domain Architect Integration & Reporting/] — Execute testing | Role: Data Domain Architect Integration & Reporting/ | 24.0 |
| 5.2.5 | Task |  |  | 5.2.5 | \[UC8] 5.2.5 \[Scrum Master] — Execute testing | Role: Scrum Master | 3.0 |
| 5.2.5 | Task |  |  | 5.2.5 | \[UC8] 5.2.5 \[PM] — Execute testing | Role: PM | 2.4 |
| 5.3 | User Story |  | 79179 |  | \[UC8] 5.3 End-user data product (semantic model & reports) | End-user data product |  |
| 5.3 | Task |  |  | 5.3 | \[UC8] 5.3 \[Data Domain Architect Integration & Reporting/] — End-user data product | Role: Data Domain Architect Integration & Reporting/ | 8.0 |
| 5.3 | Task |  |  | 5.3 | \[UC8] 5.3 \[PM] — End-user data product | Role: PM | 2.4 |
| 5.3.1 | User Story |  | 79179 |  | \[UC8] 5.3.1 Data-product analysis & semantic model mapping | Analysis & mapping to MIM model |  |
| 5.3.1 | Task |  |  | 5.3.1 | \[UC8] 5.3.1 \[Data Product Owner] — Data-product analysis & mapping | Role: Data Product Owner | 32.0 |
| 5.3.1 | Task |  |  | 5.3.1 | \[UC8] 5.3.1 \[Functional Analyst] — Data-product analysis & mapping | Role: Functional Analyst | 32.0 |
| 5.3.1 | Task |  |  | 5.3.1 | \[UC8] 5.3.1 \[Data Domain Architect Integration & Reporting/] — Data-product analysis & mapping | Role: Data Domain Architect Integration & Reporting/ | 32.0 |
| 5.3.1 | Task |  |  | 5.3.1 | \[UC8] 5.3.1 \[Scrum Master] — Data-product analysis & mapping | Role: Scrum Master | 4.0 |
| 5.3.1 | Task |  |  | 5.3.1 | \[UC8] 5.3.1 \[PM] — Data-product analysis & mapping | Role: PM | 16.0 |
| 5.3.2 | User Story |  | 79179 |  | \[UC8] 5.3.2 Back-end data engineering for end-user data product | Back-end data engineering |  |
| 5.3.2 | Task |  |  | 5.3.2 | \[UC8] 5.3.2 \[Data Engineer] — Back-end data engineering | Role: Data Engineer | 32.0 |
| 5.3.2 | Task |  |  | 5.3.2 | \[UC8] 5.3.2 \[Scrum Master] — Back-end data engineering | Role: Scrum Master | 4.0 |
| 5.3.2 | Task |  |  | 5.3.2 | \[UC8] 5.3.2 \[PM] — Back-end data engineering | Role: PM | 2.4 |
| 5.3.3 | User Story |  | 79179 |  | \[UC8] 5.3.3 Create semantic model on front-end | Create semantic model (front-end) |  |
| 5.3.3 | Task |  |  | 5.3.3 | \[UC8] 5.3.3 \[Data Engineer] — Create semantic model | Role: Data Engineer | 4.0 |
| 5.3.3 | Task |  |  | 5.3.3 | \[UC8] 5.3.3 \[Scrum Master] — Create semantic model | Role: Scrum Master | 0.5 |
| 5.3.3 | Task |  |  | 5.3.3 | \[UC8] 5.3.3 \[PM] — Create semantic model | Role: PM | 2.4 |
| 5.3.4 | User Story |  | 79179 |  | \[UC8] 5.3.4 Pre-UAT on content | Pre-UAT on content |  |
| 5.3.4 | Task |  |  | 5.3.4 | \[UC8] 5.3.4 \[Data Product Owner] — Pre-UAT on content | Role: Data Product Owner | 8.0 |
| 5.3.4 | Task |  |  | 5.3.4 | \[UC8] 5.3.4 \[Functional Analyst] — Pre-UAT on content | Role: Functional Analyst | 24.0 |
| 5.3.4 | Task |  |  | 5.3.4 | \[UC8] 5.3.4 \[Reporting expert] — Pre-UAT on content | Role: Reporting expert | 8.0 |
| 5.3.4 | Task |  |  | 5.3.4 | \[UC8] 5.3.4 \[Scrum Master] — Pre-UAT on content | Role: Scrum Master | 3.0 |
| 5.3.4 | Task |  |  | 5.3.4 | \[UC8] 5.3.4 \[PM] — Pre-UAT on content | Role: PM | 16.0 |
| 5.3.5 | User Story |  | 79179 |  | \[UC8] 5.3.5 Security setup complete check | Security setup complete check |  |
| 5.3.5 | Task |  |  | 5.3.5 | \[UC8] 5.3.5 \[Functional Analyst] — Security setup complete check | Role: Functional Analyst | 4.0 |
| 5.3.5 | Task |  |  | 5.3.5 | \[UC8] 5.3.5 \[Infra  MHQ/Region] — Security setup complete check | Role: Infra  MHQ/Region | 4.0 |
| 5.3.5 | Task |  |  | 5.3.5 | \[UC8] 5.3.5 \[BI Data Engineer] — Security setup complete check | Role: BI Data Engineer | 4.0 |
| 5.3.5 | Task |  |  | 5.3.5 | \[UC8] 5.3.5 \[Scrum Master] — Security setup complete check | Role: Scrum Master | 1.0 |
| 5.3.5 | Task |  |  | 5.3.5 | \[UC8] 5.3.5 \[PM] — Security setup complete check | Role: PM | 8.0 |
| 5.3.6 | User Story |  | 79179 |  | \[UC8] 5.3.6 Create reporting (dashboards) on semantic model | Create dashboards on semantic model |  |
| 5.3.6 | Task |  |  | 5.3.6 | \[UC8] 5.3.6 \[Functional Analyst] — Create reporting | Role: Functional Analyst | 8.0 |
| 5.3.6 | Task |  |  | 5.3.6 | \[UC8] 5.3.6 \[Source owner/ Application supporter] — Create reporting | Role: Source owner/ Application supporter | 16.0 |
| 5.3.6 | Task |  |  | 5.3.6 | \[UC8] 5.3.6 \[Scrum Master] — Create reporting | Role: Scrum Master | 120.0 |
| 5.3.6 | Task |  |  | 5.3.6 | \[UC8] 5.3.6 \[PM] — Create reporting | Role: PM | 2.0 |
| 5.4 | User Story |  | 79179 |  | \[UC8] 5.4 Job orchestration & process/quality monitoring | Job orchestration & monitoring |  |
| 5.4 | Task |  |  | 5.4 | \[UC8] 5.4 \[Scrum Master] — Orchestration & monitoring | Role: Scrum Master | 4.0 |
| 5.4.1 | User Story |  | 79179 |  | \[UC8] 5.4.1 Implement/append data processes in parent orchestration | Implement/append data processes |  |
| 5.4.1 | Task |  |  | 5.4.1 | \[UC8] 5.4.1 \[Data Domain Architect Integration & Reporting/] — Implement/append processes | Role: Data Domain Architect Integration & Reporting/ | 2.4 |
| 5.4.1 | Task |  |  | 5.4.1 | \[UC8] 5.4.1 \[Data Engineer] — Implement/append processes | Role: Data Engineer | 24.0 |
| 5.4.1 | Task |  |  | 5.4.1 | \[UC8] 5.4.1 \[Scrum Master] — Implement/append processes | Role: Scrum Master | 3.0 |
| 5.4.1 | Task |  |  | 5.4.1 | \[UC8] 5.4.1 \[PM] — Implement/append processes | Role: PM | 4.0 |
| 5.4.2 | User Story |  | 79179 |  | \[UC8] 5.4.2 Develop integrated quality control to confirm data environment | Develop integrated quality control (reconciliation) |  |
| 5.4.2 | Task |  |  | 5.4.2 | \[UC8] 5.4.2 \[Data Domain Architect Integration & Reporting/] — Develop quality control | Role: Data Domain Architect Integration & Reporting/ | 2.4 |
| 5.4.2 | Task |  |  | 5.4.2 | \[UC8] 5.4.2 \[Data Engineer] — Develop quality control | Role: Data Engineer | 72.0 |
| 5.4.2 | Task |  |  | 5.4.2 | \[UC8] 5.4.2 \[Scrum Master] — Develop quality control | Role: Scrum Master | 9.0 |
| 5.4.2 | Task |  |  | 5.4.2 | \[UC8] 5.4.2 \[PM] — Develop quality control | Role: PM | 4.0 |
| 5.4.3 | User Story |  | 79179 |  | \[UC8] 5.4.3 Develop/integrate business quality checks | Develop/integrate business quality checks |  |
| 5.4.3 | Task |  |  | 5.4.3 | \[UC8] 5.4.3 \[Headnof Data & Integration] — Business quality checks | Role: Headnof Data & Integration | 2.4 |
| 5.4.3 | Task |  |  | 5.4.3 | \[UC8] 5.4.3 \[DevOps Engineer/ Automation Expert] — Business quality checks | Role: DevOps Engineer/ Automation Expert | 8.0 |
| 5.4.3 | Task |  |  | 5.4.3 | \[UC8] 5.4.3 \[PM] — Business quality checks | Role: PM | 1.0 |
| 5.5 | User Story |  | 79179 |  | \[UC8] 5.5 User acceptance testing | User acceptance testing |  |
| 5.5 | Task |  |  | 5.5 | \[UC8] 5.5 \[Headnof Data & Integration] — User acceptance testing | Role: Headnof Data & Integration | 8.0 |
| 5.5.1 | User Story |  | 79179 |  | \[UC8] 5.5.1 Start UAT section | Start UAT section |  |
| 5.5.1 | Task |  |  | 5.5.1 | \[UC8] 5.5.1 \[Functional Analyst] — Start UAT section | Role: Functional Analyst | 80.0 |
| 5.5.1 | Task |  |  | 5.5.1 | \[UC8] 5.5.1 \[Source owner/ Application supporter] — Start UAT section | Role: Source owner/ Application supporter | 32.0 |
| 5.5.1 | Task |  |  | 5.5.1 | \[UC8] 5.5.1 \[Scrum Master] — Start UAT section | Role: Scrum Master | 16.0 |
| 5.5.1 | Task |  |  | 5.5.1 | \[UC8] 5.5.1 \[PM] — Start UAT section | Role: PM | 4.0 |
| 5.5.2 | User Story |  | 79179 |  | \[UC8] 5.5.2 Finalize/organize review with stakeholders | Finalize/organize review with stakeholders |  |
| 5.5.2 | Task |  |  | 5.5.2 | \[UC8] 5.5.2 \[Functional Analyst] — Finalize stakeholder review | Role: Functional Analyst | 8.0 |
| 5.5.2 | Task |  |  | 5.5.2 | \[UC8] 5.5.2 \[Source owner/ Application supporter] — Finalize stakeholder review | Role: Source owner/ Application supporter | 8.0 |
| 5.5.2 | Task |  |  | 5.5.2 | \[UC8] 5.5.2 \[PM] — Finalize stakeholder review | Role: PM | 1.0 |
| 5.6 | User Story |  | 79179 |  | \[UC8] 5.6 Production deployment | Production deployment |  |
| 5.6 | Task |  |  | 5.6 | \[UC8] 5.6 \[Functional Analyst] — Production deployment | Role: Functional Analyst | 4.0 |
| 5.6 | Task |  |  | 5.6 | \[UC8] 5.6 \[Source owner/ Application supporter] — Production deployment | Role: Source owner/ Application supporter | 4.0 |
| 5.6 | Task |  |  | 5.6 | \[UC8] 5.6 \[Data Engineer] — Production deployment | Role: Data Engineer | 8.0 |
| 5.6 | Task |  |  | 5.6 | \[UC8] 5.6 \[DevOps Engineer/ Automation Expert] — Production deployment | Role: DevOps Engineer/ Automation Expert | 8.0 |
| 5.6 | Task |  |  | 5.6 | \[UC8] 5.6 \[PM] — Production deployment | Role: PM | 2.5 |

### Phase 6 – Stories and Tasks

| WbsId | WorkItemType | DevOpsId | ParentDevOpsId | ParentWbsId | Title | Description (short) | OriginalEstimateHours |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 6.1 | User Story |  | 79180 |  | \[UC8] 6.1 Finalize documentation | Finalize documentation |  |
| 6.1 | Task |  |  | 6.1 | \[UC8] 6.1 \[Data Product Owner] — Finalize documentation | Role: Data Product Owner | 2.4 |
| 6.1 | Task |  |  | 6.1 | \[UC8] 6.1 \[Functional Analyst] — Finalize documentation | Role: Functional Analyst | 16.0 |
| 6.1 | Task |  |  | 6.1 | \[UC8] 6.1 \[Scrum Master] — Finalize documentation | Role: Scrum Master | 2.0 |
| 6.1 | Task |  |  | 6.1 | \[UC8] 6.1 \[PM] — Finalize documentation | Role: PM | 8.0 |
| 6.2 | User Story |  | 79180 |  | \[UC8] 6.2 Develop guidelines: preparation handover | Develop handover guidelines |  |
| 6.2 | Task |  |  | 6.2 | \[UC8] 6.2 \[Data Domain Architect Integration & Reporting/] — Develop handover guidelines | Role: Data Domain Architect Integration & Reporting/ | 8.0 |
| 6.2 | Task |  |  | 6.2 | \[UC8] 6.2 \[Data Engineer] — Develop handover guidelines | Role: Data Engineer | 24.0 |
| 6.2 | Task |  |  | 6.2 | \[UC8] 6.2 \[Scrum Master] — Develop handover guidelines | Role: Scrum Master | 3.0 |
| 6.2 | Task |  |  | 6.2 | \[UC8] 6.2 \[PM] — Develop handover guidelines | Role: PM | 4.0 |
| 6.3 | User Story |  | 79180 |  | \[UC8] 6.3 Finalize SLA/SLA activation (per UC) | Finalize SLA/SLA activation |  |
| 6.3 | Task |  |  | 6.3 | \[UC8] 6.3 \[Functional Analyst] — Finalize SLA activation | Role: Functional Analyst | 2.4 |
| 6.3 | Task |  |  | 6.3 | \[UC8] 6.3 \[Data Domain Architect Integration & Reporting/] — Finalize SLA activation | Role: Data Domain Architect Integration & Reporting/ | 2.4 |
| 6.3 | Task |  |  | 6.3 | \[UC8] 6.3 \[Headnof Data & Integration] — Finalize SLA activation | Role: Headnof Data & Integration | 4.0 |
| 6.3 | Task |  |  | 6.3 | \[UC8] 6.3 \[Scrum Master] — Finalize SLA activation | Role: Scrum Master | 0.3 |
| 6.3 | Task |  |  | 6.3 | \[UC8] 6.3 \[PM] — Finalize SLA activation | Role: PM | 4.0 |
| 6.4 | User Story |  | 79180 |  | \[UC8] 6.4 Organize aftercare/retrospective: post-implementation review & lessons learned | Organize aftercare/retrospective |  |
| 6.4 | Task |  |  | 6.4 | \[UC8] 6.4 \[Data Product Owner] — Organize aftercare/retrospective | Role: Data Product Owner | 4.0 |
| 6.4 | Task |  |  | 6.4 | \[UC8] 6.4 \[Functional Analyst] — Organize aftercare/retrospective | Role: Functional Analyst | 12.0 |
| 6.4 | Task |  |  | 6.4 | \[UC8] 6.4 \[Data Domain Architect Integration & Reporting/] — Organize aftercare/retrospective | Role: Data Domain Architect Integration & Reporting/ | 4.0 |
| 6.4 | Task |  |  | 6.4 | \[UC8] 6.4 \[Headnof Data & Integration] — Organize aftercare/retrospective | Role: Headnof Data & Integration | 4.0 |
| 6.4 | Task |  |  | 6.4 | \[UC8] 6.4 \[Design review] — Organize aftercare/retrospective | Role: Design review | 4.0 |
| 6.4 | Task |  |  | 6.4 | \[UC8] 6.4 \[Scrum Master] — Organize aftercare/retrospective | Role: Scrum Master | 2.0 |
| 6.4 | Task |  |  | 6.4 | \[UC8] 6.4 \[PM] — Organize aftercare/retrospective | Role: PM | 8.0 |
| 6.5 | User Story |  | 79180 |  | \[UC8] 6.5 Organize check of project closure (checklist) | Organize project closure check |  |
| 6.5 | Task |  |  | 6.5 | \[UC8] 6.5 \[Data Product Owner] — Organize project closure check | Role: Data Product Owner | 2.4 |
| 6.5 | Task |  |  | 6.5 | \[UC8] 6.5 \[Functional Analyst] — Organize project closure check | Role: Functional Analyst | 2.4 |
| 6.5 | Task |  |  | 6.5 | \[UC8] 6.5 \[Headnof Data & Integration] — Organize project closure check | Role: Headnof Data & Integration | 2.4 |
| 6.5 | Task |  |  | 6.5 | \[UC8] 6.5 \[Scrum Master] — Organize project closure check | Role: Scrum Master | 0.3 |
| 6.5 | Task |  |  | 6.5 | \[UC8] 6.5 \[PM] — Organize project closure check | Role: PM | 4.0 |
| 6.6 | User Story |  | 79180 |  | \[UC8] 6.6 Review final documentation | Review final documentation |  |
| 6.6 | Task |  |  | 6.6 | \[UC8] 6.6 \[Data Product Owner] — Review final documentation | Role: Data Product Owner | 8.0 |
| 6.6 | Task |  |  | 6.6 | \[UC8] 6.6 \[Functional Analyst] — Review final documentation | Role: Functional Analyst | 8.0 |
| 6.6 | Task |  |  | 6.6 | \[UC8] 6.6 \[Data Domain Architect Integration & Reporting/] — Review final documentation | Role: Data Domain Architect Integration & Reporting/ | 4.0 |
| 6.6 | Task |  |  | 6.6 | \[UC8] 6.6 \[Data Engineer] — Review final documentation | Role: Data Engineer | 4.0 |
| 6.6 | Task |  |  | 6.6 | \[UC8] 6.6 \[Scrum Master] — Review final documentation | Role: Scrum Master | 1.5 |
| 6.6 | Task |  |  | 6.6 | \[UC8] 6.6 \[PM] — Review final documentation | Role: PM | 4.0 |
| 6.7 | User Story |  | 79180 |  | \[UC8] 6.7 Operational, functional & technical handover | Operational, functional & technical handover |  |
| 6.7 | Task |  |  | 6.7 | \[UC8] 6.7 \[Functional Analyst] — Handover | Role: Functional Analyst | 8.0 |
| 6.7 | Task |  |  | 6.7 | \[UC8] 6.7 \[BI Data Engineer] — Handover | Role: BI Data Engineer | 8.0 |
| 6.7 | Task |  |  | 6.7 | \[UC8] 6.7 \[Data Engineer] — Handover | Role: Data Engineer | 8.0 |
| 6.7 | Task |  |  | 6.7 | \[UC8] 6.7 \[Reporting expert] — Handover | Role: Reporting expert | 8.0 |
| 6.7 | Task |  |  | 6.7 | \[UC8] 6.7 \[Scrum Master] — Handover | Role: Scrum Master | 3.0 |
| 6.7 | Task |  |  | 6.7 | \[UC8] 6.7 \[PM] — Handover | Role: PM | 4.0 |
| 6.8 | User Story |  | 79180 |  | \[UC8] 6.8 Hypercare and support | Hypercare and support |  |
| 6.8 | Task |  |  | 6.8 | \[UC8] 6.8 \[Data Product Owner] — Hypercare & support | Role: Data Product Owner | 8.0 |
| 6.8 | Task |  |  | 6.8 | \[UC8] 6.8 \[Functional Analyst] — Hypercare & support | Role: Functional Analyst | 24.0 |
| 6.8 | Task |  |  | 6.8 | \[UC8] 6.8 \[BI Data Engineer] — Hypercare & support | Role: BI Data Engineer | 32.0 |
| 6.8 | Task |  |  | 6.8 | \[UC8] 6.8 \[Data Engineer] — Hypercare & support | Role: Data Engineer | 16.0 |
| 6.8 | Task |  |  | 6.8 | \[UC8] 6.8 \[Reporting expert] — Hypercare & support | Role: Reporting expert | 16.0 |
| 6.8 | Task |  |  | 6.8 | \[UC8] 6.8 \[Scrum Master] — Hypercare & support | Role: Scrum Master | 9.0 |
| 6.8 | Task |  |  | 6.8 | \[UC8] 6.8 \[PM] — Hypercare & support | Role: PM | 4.0 |
| 6.9 | User Story |  | 79180 |  | \[UC8] 6.9 Support activation (last day of hypercare) | Support activation |  |
| 6.9 | Task |  |  | 6.9 | \[UC8] 6.9 \[BI Data Engineer] — Support activation | Role: BI Data Engineer | 8.0 |
| 6.9 | Task |  |  | 6.9 | \[UC8] 6.9 \[Data Engineer] — Support activation | Role: Data Engineer | 8.0 |
| 6.9 | Task |  |  | 6.9 | \[UC8] 6.9 \[Scrum Master] — Support activation | Role: Scrum Master | 2.0 |
| 6.9 | Task |  |  | 6.9 | \[UC8] 6.9 \[PM] — Support activation | Role: PM | 16.0 |

