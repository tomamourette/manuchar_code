# Integration patterns
This page documents the standard Fabric patterns that drive ingestion into the Data BackBone. Reuse these templates whenever a new source is onboarded.

## Pattern: Metadata driven ingestion
1. The master pipeline (`fabric/integration/integration_pipeline_DBB`) reads `integration_source_list.csv` from the Lakehouse to determine active tables per source.
2. Connection metadata (workspace id, connection id) is resolved through `integration_source_connections.csv`.
3. For each active table the pipeline:
   - Looks up the current watermark in `dbb_warehouse.meta.monitoring_integration`.
   - Loads data from the source using Copy activities or Stored Procedure executions.
   - Writes audit entries (row counts, duration, status) back to the monitoring table.

## Pattern: Source specific pipelines
Each source has a dedicated pipeline in `fabric/integration/integration_sources`. The templates include:
- Initialisation Lookup: loads metadata and sets pipeline variables.
- ForEach activity: iterates tables, applies incremental logic and handles retries.
- Failure path: writes error details to the monitoring table and raises alerts.

When cloning the pattern for a new source, copy the JSON file and update parameters (`source_name`, `database_name`) plus any source specific activities.

## Pattern: Table configuration files
- Store per table schema and load settings in `{Source}/dbo/{Table}.json` inside the `integration` folder.
- Include attributes such as primary keys, natural keys, soft delete flags and incremental predicates.
- Use the configuration in dbt staging models so the same metadata drives ingestion and modelling.

## Pattern: Monitoring notebooks
Monitoring notebooks in `fabric/monitoring` run after each ingestion batch to:
- Validate row counts versus expected ranges.
- Ensure critical tables are not empty.
- Surface alerts through the Power BI monitoring dashboard.

## Checklist for new integrations
- [ ] Metadata created in csv and json files and stored in Git.
- [ ] Pipeline cloned, parameterised and tested in TST.
- [ ] Monitoring thresholds defined and added to notebooks.
- [ ] Documentation updated in the relevant source page and change request closed.
