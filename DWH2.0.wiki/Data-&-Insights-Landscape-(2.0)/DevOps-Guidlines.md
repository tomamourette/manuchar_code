# DevOps guidelines
The DevOps operating model keeps the Data BackBone platform consistent across environments while allowing engineers to ship changes quickly. This page summarises the practices that complement the detailed procedures in the sub pages of this section.

## Branch and environment strategy
| Branch | Fabric environment | Variable group | Primary deployment scope |
| --- | --- | --- | --- |
| `test` | TST | `variable_fabric_dbb_test` | Integration, transformation and monitoring assets seeded for system testing |
| `acceptance` | ACC | `variable_fabric_dbb_acceptance` | Acceptance testing of data products with finance users |
| `quality` | QUAL | `variable_fabric_dbb_quality` | Regression and performance testing, dry runs of releases |
| `production` | PRD | `variable_fabric_dbb_production` | Live operation and support |

Each long lived branch maps to a Fabric workspace that shares the same item structure (lakehouse, warehouse, pipelines, notebooks and semantic models). Short lived feature branches are merged into `test` through pull requests with reviewer approval before flowing downstream.

## Azure Pipelines overview
`azure-pipelines.yml` drives continuous delivery. The pipeline is triggered on pushes to the environment branches and performs the following steps:
1. Install the Azure CLI and AzCopy client on the Microsoft hosted agent.
2. Authenticate via the environment specific service principal defined in the variable group.
3. Upload the latest `/integration`, `/transformation` and `/monitoring/monitoring_metadata` folders to OneLake (`https://onelake.blob.fabric.microsoft.com/{workspace}/{lakehouse}/Files`).
4. Prepare the agent workspace so notebooks, dbt artefacts and metadata are aligned with Git.

Use the `fabric-deployment.yml` template together with `cicd/deploy_workspace_items.py` when you need to republish Fabric items (pipelines, notebooks, warehouse, lakehouse) through automation. The helper honours the scope defined in `fabric_cicd_constants.py` and environment specific replacements in `fabric/parameter.yml`.

## Configuration management
- All Fabric artefact identifiers (workspace, lakehouse, warehouse, semantic models) are parameterised through `fabric/parameter.yml`. Update the `find_replace` map whenever a new item is introduced so deployments stay idempotent.
- Connection metadata for integration sources lives in `integration/integration_source_connections.csv`. Keep contact details and rotation dates up to date to avoid broken credentials.
- dbt environment settings are managed via `transformation/dbt/profiles.yml`. Commit changes to thread counts or endpoints alongside a tested run.

## Testing expectations
- Execute `dbt build --select state:modified+` locally in the target environment before opening a pull request. Commit the run results under `transformation/dbt/target` only when required by a release note.
- Monitor `logs/dbt.log` for warnings and re-run models when tests fail. Document remediation in the change request.
- For pipelines, run the Fabric pipeline in the corresponding TST workspace and capture evidence (screenshot or run id) in Azure DevOps.

## Release flow
1. Merge approved work into `test` and allow the CI pipeline to publish to the TST workspace.
2. Execute smoke tests (integration pipeline replay, dbt build, semantic refresh) and record outcomes in the release ticket.
3. Cherry pick or merge into `acceptance`, `quality` and finally `production` once sign-off is obtained. Each merge triggers the same pipeline which replays the asset upload with the environment specific credentials.
4. Tag the repository with the release id once the production deployment is complete.

## Operational runbooks
- Monitoring notebooks in `fabric/monitoring` (integration, validation, transformation) provide standard checks. Follow the procedures in [[Data-BackBone-Fabric-Implementation-Documentation/40.-Monitoring.md]] for alert handling.
- Maintenance notebooks in `fabric/maintenance` deliver diagnostics, clean-up and optimisation. Schedule them via the orchestration pipeline and record any manual interventions in the support log.
- Update the documentation in this wiki whenever runbooks or standard operating procedures change so the team has a single source of truth.
