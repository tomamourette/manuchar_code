# Orchestration strategy
Orchestration coordinates all workloads (integration, transformation, consumption, monitoring and maintenance) so the platform runs predictably.

## Design goals
- Separate business schedules from technical implementation so we can reuse the same pipelines across environments.
- Allow partial replays (per source, per table) without redeploying code.
- Capture operational metadata at every step for observability and audit.

## Fabric orchestration components
- **Master pipeline:** `fabric/orchestration/orchestration_pipeline_DBB.DataPipeline` chains integration, transformation and semantic refresh activities. It is parameterised by environment, schedule and scope.
- **Refresh pipeline:** `fabric/orchestration/refresh_semantic_models.DataPipeline` standardises dataset refresh and post processing (notifications, cache clearing).

## Control tables and parameters
- Pipeline parameters are defined in JSON and resolved at runtime via `fabric/parameter.yml` replacements.
- Scheduling metadata (frequency, dependencies, windows) is stored in Azure DevOps work items and mirrored in Fabric pipeline triggers.
- Environment specific connection ids are injected through pipeline variables set by lookup activities.

## Operational patterns
1. Trigger master pipeline according to the agreed cadence (daily, weekly, month-end). Fabric handles retries with exponential backoff.
2. If a stage fails, the pipeline halts. Operators remediate, rerun the failed activity and document the incident.
3. Manual overrides (e.g. backfills) leverage the same pipeline with scoped parameters to avoid ad-hoc scripts.

Refer to [[Data-BackBone-Solution-Design-Documentation/00.-General-Architecture-&-Design/Orchestration/Job-orchestration-and-pipeline-structure.md]] for detailed diagrams.
