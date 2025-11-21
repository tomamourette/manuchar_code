# Security setup across layers
Security is embedded in every layer of the Data BackBone. This page connects platform level controls with implementation specifics documented in [[Data-BackBone-Solution-Design-Documentation/60.-Security.md]].

## Identity and access management
- **Authentication:** All users authenticate via Entra ID. Service principals handle automation (CI/CD, pipelines) with least privilege access.
- **Workspace roles:** Admin, Member and Viewer roles separate engineering, operations and consumer responsibilities. Grant Admin only to platform engineers.
- **Item permissions:** Sensitive notebooks, pipelines and lakehouse folders restrict access to the operations group only. Consumption items expose Viewer access to approved audiences.

## Data protection
- **Lakehouse zones:** Raw (restricted), curated and shared folders apply different access groups. Personal data stays within restricted zones and is masked before reaching gold layers.
- **Warehouse schemas:** Schemas (`mim`, `ods`, `dds_finance`) map to responsibility areas. Apply schema level grants to restrict access for non engineering personas.
- **Semantic models:** Implement Row Level Security and Object Level Security to enforce finance confidentiality. Reference groups managed by Finance IT.

## Secrets management
- Service principal credentials live in Azure Key Vault and surface through Azure DevOps variable groups. Never store secrets in Git.
- Fabric connections use managed identities where available; rotate secrets at least every 90 days.

## Monitoring and audit
- Pipeline logs and monitoring tables capture who triggered what and when. Retain telemetry for at least 13 months.
- Use Azure AD sign-in logs and Fabric activity logs for investigative support.
- Raise security incidents through the corporate SOC and document remediation in the security runbook.

## Change control
- Security impacting changes require review by the security champion and sign-off from the platform owner.
- Update this page and linked runbooks whenever access groups change or new controls are introduced.
