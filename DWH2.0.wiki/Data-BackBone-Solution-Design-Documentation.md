# Solution design overview
This section captures how the Data BackBone is architected on Microsoft Fabric. Use it when designing new features, onboarding domains or presenting architecture decisions.

## How the content is organised
- **00. General Architecture & Design** explains cross cutting concerns such as physical architecture, orchestration approach and security layering.
- **10. Integration** documents ingestion patterns, CDC strategy and infrastructure connectivity.
- **20. Transformation** describes data modelling standards (Data Vault, dimensional models) together with dbt conventions.
- **30. Consumption** covers semantic models, report certification and distribution patterns.
- **40. Testing & Monitoring** details data quality checks, observability assets and operational workflows.
- **50. Cost Management** explains how Fabric usage is tracked, allocated and optimised.
- **60. Security** sets out authentication, authorisation and privacy controls across the stack.

The sub pages mix target state diagrams, standards and implementation notes. Align code and infrastructure changes with these guidelines to keep the platform coherent across domains and environments.

## When to update
- After approving an Architecture Decision Record.
- When a new pattern is introduced (for example a new integration type or modelling layer).
- When Fabric releases introduce capabilities that change best practices.

Always link updates to the relevant Azure DevOps work item so we retain traceability between decisions and delivery.
