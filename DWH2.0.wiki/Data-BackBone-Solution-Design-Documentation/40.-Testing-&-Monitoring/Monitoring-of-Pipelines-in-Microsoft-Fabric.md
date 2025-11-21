# Monitoring of pipelines in Microsoft Fabric
This runbook explains how pipeline health is tracked and acted upon across environments.

## Data sources for monitoring
- **Monitoring table (`dbb_warehouse.meta.monitoring_integration`):** Stores activity name, source, table, status, duration and row counts. Integration pipelines append new rows for every load.
- **Fabric pipeline run history:** Provides detailed error messages and retry information. Link run ids from the monitoring table back to Fabric UI when troubleshooting.
- **Monitoring notebooks:**
  - `monitoring_notebook_integration` validates integration freshness and row counts.
  - `monitoring_notebook_integration_validation` reconciles source versus target balances for critical tables.
  - `monitoring_notebook_transformation` checks dbt model freshness and row counts.
  - `monitoring_notebook_transformation_validation` performs business rule checks on curated data.
  - `monitoring_integration_empty_check` ensures mandatory tables are not empty after a run.

## Dashboards and alerts
- The monitoring semantic model and Power BI report (`fabric/monitoring/monitoring_dashboard`) aggregates notebook outputs and monitoring table metrics.
- Configure Fabric alerts on critical measures (for example failed load count > 0, stale data) and route notifications to the data engineering on-call group.

## Standard operating procedure
1. Review the monitoring dashboard after each scheduled run.
2. If an alert fires, open the related Azure DevOps incident and gather context from the monitoring table and Fabric run history.
3. Execute the relevant monitoring notebook to collect diagnostics and attach results to the incident.
4. Remediate (rerun pipeline, fix credential, adjust metadata) and rerun monitoring notebooks to confirm recovery.
5. Update this page with lessons learned once the incident is closed.

## Continuous improvement
- Track false positives and adjust thresholds or exclusion rules accordingly.
- Automate evidence collection by storing notebook results in the monitoring lakehouse folder for audit.
- Expand the dashboard with SLA compliance metrics and trend analysis to identify recurring issues.
