# Physical architecture in Microsoft Fabric
The Data BackBone uses Microsoft Fabric as the unified analytics platform. This page summarises the deployed components and how they interact.

## Core Fabric items
| Item | Purpose | Repository location |
| --- | --- | --- |
| `dbb_lakehouse` (Lakehouse) | Landing zone for raw and curated delta tables, shortcuts to external sources | `fabric/dbb_lakehouse.Lakehouse` |
| `dbb_dynamics_lakehouse` (Lakehouse) | External Dynamics data exposed via shortcut | `fabric/dbb_dynamics_lakehouse.Lakehouse` |
| `dbb_warehouse` (Warehouse) | SQL analytics endpoint for dbt, monitoring and consumption | `fabric/dbb_warehouse.Warehouse` |
| Integration pipelines | Ingest source systems and populate Lakehouse tables | `fabric/integration` |
| Transformation pipelines | Execute notebooks and dbt transformations | `fabric/transformation` |
| Orchestration pipelines | Coordinate full data product refresh | `fabric/orchestration` |
| Monitoring assets | Notebooks, semantic model and Power BI dashboard for observability | `fabric/monitoring` |
| Maintenance notebooks | Diagnostics, clean-up, metadata refresh | `fabric/maintenance` |

## Data flow overview
1. Source data lands in bronze folders inside `dbb_lakehouse` through Copy activities.
2. Silver layers (raw vault, business vault, ODS) and gold layers are materialised into `dbb_warehouse` via dbt models.
3. Semantic models connect to the warehouse and expose measures to Power BI reports.
4. Monitoring notebooks read pipeline metadata and push metrics into a dedicated semantic model.

## Environment separation
- Each environment runs its own Fabric workspace with the same item structure. Identifiers are parameterised via `fabric/parameter.yml`.
- Data isolation is enforced at workspace level; no cross environment shortcuts are allowed.
- Deployments copy files into OneLake and republish Fabric items per environment.

## Integration with external services
- Azure AD (Entra ID) provides authentication and group based authorisation.
- Azure DevOps manages code, pipelines and access tokens used by deployment scripts.
- Downstream systems connect through the SQL endpoint (for example via `ODBC Driver 18 for SQL Server` as configured in `profiles.yml`).

Keep this page updated when new Fabric items are introduced or when architecture decisions shift the layout.
