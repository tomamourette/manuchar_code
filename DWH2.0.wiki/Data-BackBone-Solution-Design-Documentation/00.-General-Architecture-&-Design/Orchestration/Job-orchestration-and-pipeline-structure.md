# Job orchestration and pipeline structure
This page provides the detailed structure of the orchestration pipelines that coordinate Data BackBone workloads.

## Master orchestration pipeline (`orchestration_pipeline_DBB`)
1. **Initialisation:** Resolve environment metadata (workspace id, connection ids) via Lookup activities and pipeline parameters.
2. **Integration stage:** Invoke `integration_pipeline_DBB` and wait for completion. Failure halts downstream stages.
3. **Transformation stage:** Trigger `transformation_pipeline_DBB` to run dbt models and notebooks.
4. **Monitoring stage:** Kick off the monitoring notebooks to validate load completeness and threshold breaches.
5. **Maintenance stage (optional):** Run scheduled maintenance notebooks (cleanup, optimisation) when flagged.
6. **Semantic refresh:** Call the `refresh_semantic_models` pipeline to update datasets and notify consumers.

## Semantic model refresh pipeline (`refresh_semantic_models`)
- Reads dataset configuration from parameters defined in `fabric/parameter.yml` and the environment variable group.
- Executes Power BI REST API calls (via Fabric activities) to refresh semantic models sequentially.
- Sends notifications to the operations channel if refresh exceeds target duration or fails.

## Design choices
- Pipelines rely on parameterised JSON rather than hard coded identifiers to support multi environment deployments.
- Activities emit monitoring rows to `meta.monitoring_integration` for traceability.
- Retry policies: defaults to 3 attempts with 30 second delay; adjust per activity when higher resilience is required.

## Extending the orchestration
- Add new workloads by inserting additional stages after the monitoring step. Keep each stage in a dedicated Execute Pipeline activity for legibility.
- Use the ForEach pattern when parallelising tasks (for example multiple semantic models) but cap concurrency to avoid capacity spikes.
- Document any manual operator interaction in the release note and update this page accordingly.
