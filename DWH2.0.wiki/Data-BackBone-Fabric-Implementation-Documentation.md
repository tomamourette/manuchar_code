# Fabric Implementation Overview

This section provides a complete overview of how the **Data BackBone (DBB)** is implemented within **Microsoft Fabric**.  
Each chapter maps directly to artefacts stored in the `fabric/` folder of the `data.backbone` repository and describes their configuration, orchestration, and operational purpose.

## Structure

- **00. Orchestration & Components:**  
  Overview of shared Fabric assets such as Lakehouses, Warehouses, and Orchestration Pipelines.  
  Describes how global orchestration coordinates Integration, Transformation, Reconciliation, and Consumption workloads, including environment handling and monitoring dependencies.

- **10. Integration:**  
  Documentation of all ingestion pipelines and their metadata-driven logic.  
  Includes details on the master `integration_pipeline_<Data Product>` and source-specific pipelines, parameter passing, and ingestion logic for full and incremental loads.

- **20. Transformation:**  
  Describes how dbt models and transformation notebooks materialize curated data in the warehouse.  
  Covers `transformation_pipeline_DBB`, environment setup, parameterization, and monitoring.  
  Also includes reconciliation alignment and semantic model refresh dependencies handled via orchestration.

- **30. Reconciliation:**  
  Details the reconciliation pipeline and notebook that validate KPI consistency between source and target data.  
  Explains logic for KPI comparison per company and industry, and how failed checks prevent semantic model refresh.

- **40. Consumption:**  
  Explains how semantic models and Power BI reports are refreshed, versioned, and published to end users.  
  Includes workspace structure, access groups, and the `data_product_refresh_DBB` pipeline logic.

- **50. RLS (Row-Level Security):**  
  Outlines the Dynamic RLS setup across Finance data products.  
  Documents how Entra groups are loaded, parsed, and transformed into an RLS security matrix that enforces access by **Company** and **Industry**.  
  Explains integration with semantic models and global Entra access groups for environment-based model access.

- **60. Monitoring:**  
  Describes monitoring pipelines and notebooks that log execution results, validate data quality, and visualize outcomes in dashboards.

- **70. Maintenance:**  
  Documentation for housekeeping routines, metadata refresh, and semantic optimization notebooks that ensure stable platform operations.

## How to Keep This Section Current

1. Export and commit updated Fabric definitions (pipelines, notebooks, reports) after every change.  
2. Record any configuration updates (workspace IDs, connection strings, environment variables) in `fabric/parameter.yml`.  
3. Update or extend the relevant documentation page with a summary of what changed and why.  
4. Link each documentation update to its corresponding **Azure DevOps work item** or **pull request** for full traceability.

---

## Component Overview Diagram

The following diagram provides a high-level view of how Fabric components interact across the DBB platform:

::: mermaid
graph LR

    %% Orchestreation Workload
    subgraph T1[Orchestration]

        %% order left-to-right
        subgraph Consumption
            C1[data_product_refresh_DBB] --> C2[Semantic Models / Power BI Reports]
        end

        subgraph Reconciliation
            R1[reconciliation_pipeline_DBB] --> R2[reconciliation_notebook]
        end

        subgraph Transformation
            B1[transformation_pipeline_DBB] --> B2[transformation_notebook] --> B3[dbb_warehouse]
            B3 --> S1[RLS Mapping]
        end
  
        subgraph Integration
            A1[integration_pipeline_data_product] --> A2[integration_pipeline_source_system] --> A3[dbb_lakehouse]
        end
    end

    %% Supporting workloads
    subgraph Monitoring
        D1[monitoring_integration]
        D2[monitoring_transformation_dbt]
        D3[monitoring_semantic_model_refresh]
    end

    subgraph Maintenance
        E1[maintenance_notebook_lakehouse_cleanup]
        E2[maintenance_notebook_metadata_refresh]
        E3[maintenance_notebook_optimization]
    end

    subgraph Security
        S[Entra Groups / Users]
    end

%% STYLING (Manuchar colors)
%%{init: { 
  'theme': 'base', 
  'themeVariables': { 
    'background': '#FDF8F7',
    'primaryTextColor': '#B82023',
    'lineColor': '#7E7E7E',
    'fontSize': '14px',
    'tertiaryColor': '#FDF8F7'
}}}%%

%% Main brand colors
classDef brandSolid  fill:#B82023,stroke:#B82023,stroke-width:2px,color:#FFFFFF;
classDef brandSoft   fill:#FEECEA,stroke:#B82023,stroke-width:1px,color:#B82023;
classDef accentLight fill:#ECCDCD,stroke:#7E7E7E,stroke-width:1px,color:#B82023;
classDef neutral     fill:#FFFFFF,stroke:#7E7E7E,stroke-width:1px,color:#B82023;

%% Apply by type
class A1,A2,A3 brandSoft;
class B1,B2,B3,S1 brandSoft;
class R1,R2 brandSoft;
class C1,C2 brandSoft;
class D1,D2,D3 neutral;
class E1,E2,E3 neutral;
class S neutral;
:::
