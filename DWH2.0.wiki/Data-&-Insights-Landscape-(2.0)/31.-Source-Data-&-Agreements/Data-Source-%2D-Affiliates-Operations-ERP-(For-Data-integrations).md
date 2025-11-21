# Affiliate and operations sources
This page summarises the non-HQ operational systems that publish data into the Data BackBone. Each source follows the standard integration playbook so onboarding new affiliates remains predictable.

## Systems in scope
| Source | Primary domain | Landing path | Comments |
| --- | --- | --- | --- |
| Boomi | Affiliate sales and inventory | `integration/Boomi` | SaaS integration platform delivers curated extracts via Azure SQL |
| Mona | Latin America operations | `integration/Mona` | Legacy SQL Server replicated through VPN; migration to Fabric shortcuts planned |
| MTM | Maritime transport | `integration/MTM` | Interfaces capture vessel, shipment and cost data |
| LOG | Global logistics | `integration/LOG` | Tactical SQL Server landing zone for transport events |
| STG | Staging | `integration/STG` | Temporary staging schema for transition projects |
| OSS_GenericData | Miscellaneous | `integration/OSS_GenericData` | Template for other structured feeds (one table per file) |

All sources use the same metadata structure:
- `integration_source_list.csv` identifies enabled tables (`load_enabled = yes`).
- `{table}.json` describes source schema and incremental predicates when available.

## Onboarding checklist
1. Capture business requirements and data sharing agreement; store it in the Azure DevOps epic.
2. Provision connectivity (service principal, firewall, connection id in Fabric) and document in the csv.
3. Populate `integration_source_list.csv` with table level scope, load type and owners.
4. Test the `integration_pipeline_source_{Source}` pipeline in TST. Record run ids and sample record counts.
5. Publish the monitoring notebook thresholds and playbook entries for support.

## Data quality expectations
- Validate record counts and primary keys against the source before enabling incremental loads.
- Define SLA for data arrival (for example Boomi deliveries by 07:00 UTC) and codify checks in monitoring notebooks.
- Communicate schema change windows with the affiliate IT team and update metadata ahead of time.

## Security and compliance
- Use dedicated service principals per affiliate system. Rotate credentials every 90 days and update secrets in Azure Key Vault.
- Encrypt data in transit via TLS 1.2+. Validate that extracts do not contain PII beyond the agreed scope.
- Where local regulations apply (LATAM, APAC), confirm retention rules with Legal and reflect them in Lakehouse cleanup notebooks.
