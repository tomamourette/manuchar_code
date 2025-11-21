# HQ applications feeding the DBB
Core ERP and master data systems owned by headquarters supply the bulk of finance data. This page captures their role, ownership and integration specifics.

## Systems in scope
| Source | Business owner | Technical owner | Notes |
| --- | --- | --- | --- |
| Dynamics | Group Finance | Dynamics platform team | Main ERP for finance. Incremental loads based on `_timestamp` columns captured in the monitoring metadata table. |
| MDS | Data Governance | Master Data team | Provides reference data (companies, cost centres, hierarchies). Loaded nightly as full snapshots. |
| DWH | Business Intelligence | Data Engineering | Legacy SQL Server warehouse used for backfills and historic comparisons. Will be phased out once Fabric history is complete. |
| dbb_lakehouse | Data Engineering | Data Engineering | Fabric Lakehouse to Lakehouse shortcut used to share curated tables between workspaces.

## Integration specifics
- Pipelines read table scope from `integration/Dynamics/integration_source_list.csv` and equivalent files per system.
- Connection identifiers are managed in `integration/integration_source_connections.csv`. Each environment has its own Fabric connection id to isolate credentials.
- For Dynamics, incremental loads rely on `monitoring_integration` watermark values. Verify the view `sv_dynamics_*` in the dbt project when adding new tables.

## Change management
1. Log incoming change requests (new modules, tables, fields) in Azure DevOps and link them to this page.
2. Update the relevant `integration_source_list.csv` and dbt models. Run dbt tests in TST before promoting.
3. Communicate cutover plans to the finance reporting team and document in the release note.

## Open actions
- Align Dynamics data contracts with the Operations team to ensure new legal entities are onboarded within two sprints.
- Define retention rules for the legacy DWH once Fabric becomes the system of record.
