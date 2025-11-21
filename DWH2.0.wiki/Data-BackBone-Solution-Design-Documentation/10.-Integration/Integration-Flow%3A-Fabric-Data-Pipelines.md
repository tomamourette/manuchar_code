General Overview
----------------

In the implementation of the Data BackBone (DBB) in Microsoft Fabric, Data Pipelines serve as the primary orchestrator for structuring data ingestion. While these pipelines are the standard ingestion method, they also act as a fallback when other integration flows—such as Change Data Capture (CDC) tooling—cannot be used. This is because not all physical data sources and content types can be ingested using alternative methods. Given the extensive integration capabilities of Microsoft Fabric, Data Pipelines provide a flexible and robust ingestion mechanism.
The pipelines adhere to a general structure and flow that remains agnostic of the source, source type, and activity type (e.g., Copy Data activity, Notebook execution). This ensures consistency and standardization across all source-aligned layers within the DBB. The hierarchical structure of the pipelines is as follows:
*   **Source Name**: Defines the physical location from which data is ingested. Each physical location corresponds to exactly one integration source pipeline and one Fabric Connection per source environment.
*   **Schema Name**: A logical grouping of datasets from a single source, which may correspond to a schema in SQL Server, a folder in a file repository, or a group in an API endpoint.
*   **Table Name**: Each dataset is uniquely identified by its combination of source, schema, and table name. This ensures 1-to-1 lineage tracking with the source data. Source names must always be used without abbreviations or simplifications to maintain readability and transparency.

Metadata Management
-------------------

The metadata required for running the parameterized Data Pipelines is stored in the Data BackBone Azure DevOps repository. This metadata includes all necessary configurations to optimally execute the master integration pipeline.
*   **Master Pipeline Metadata**: Contains a list of in-scope data sources, their specifications, and additional configuration details.
*   **Data Source-Specific Metadata**: Organized according to the three-tier hierarchy (source/schema/table) and includes:
    *   A list of all datasets to be integrated from the source, along with relevant configurations.
    *   JSON metadata configurations for each dataset, defining parameters such as description, load type, query content, and integration mode.
    *   A flexible structure that allows for enrichment with additional metadata as needed.
All metadata configurations are templated uniformly and stored in a version-controlled manner within the Azure DevOps repository. Changes to these configurations are managed through Visual Studio Code by developers.

Physical Implementation in Microsoft Fabric
-------------------------------------------

The Data Pipeline structure in Microsoft Fabric is implemented in two levels:
1.  **Integration Pipeline (integration_pipeline)**:
    *   Serves as the master pipeline that initializes global parameters for the integration run.
    *   Iterates through all enabled data sources based on version-controlled integration metadata.
2.  **Source-Specific Integration Pipelines (integration_pipeline_source_<source_name>)**:
    *   Dedicated pipelines responsible for ingesting datasets from a specific physical source location.
    *   Loops through all datasets in scope and executes the required ingestion into the Fabric Lakehouse.
A key design principle is the separation of platform "components" and "content". The provisioned pipelines only facilitate ingestion without embedding content-specific logic. Instead, content configurations are managed through metadata.

### Environment Management

The physical pipelines are maintained in the TST workspace of the Data BackBone and must be fully parameterized to support execution in different environments (ACC and PRD). This enables seamless invocation of pipelines in different workspaces while ensuring that the correct source connections are utilized for each environment.

Example Integration Flow: Dynamics 365 CustTrans Table
------------------------------------------------------

### Metadata Definition

For example, the "CustTrans" table within the "dbo" schema in Dynamics 365 is ingested using this structured approach. The physical source is defined as a mirrored Fabric Lakehouse linked to the appropriate Dynamics environment via the "Link to Fabric" functionality.
The corresponding JSON metadata for "CustTrans" is stored in the integration metadata repository, alongside an entry in the list of ingested datasets for the Dynamics source. This metadata is version-controlled and modified by developers in Visual Studio Code.

### Pipeline Execution

During runtime, the integration pipeline uses the current environment’s metadata version to process the ingestion. Specifically, the **integration_pipeline_source_Dynamics** is executed, looping through the Dynamics datasets configured for that environment.

Screenshots and examples of the metadata configuration and pipeline setup can be referenced below for further technical details.

![integration_flows_fabric_data_pipelines_1.png](/.attachments/integration_flows_fabric_data_pipelines_1-1ba05882-bf6f-4fa0-8cd9-4f3f055a983e.png)

![integration_flows_fabric_data_pipelines_2.png](/.attachments/integration_flows_fabric_data_pipelines_2-023b7b5e-301d-447b-ae15-406fc96467f5.png)

![integration_flows_fabric_data_pipelines_4.png](/.attachments/integration_flows_fabric_data_pipelines_4-37a57725-457a-4d6f-a2ca-95c3cc3a4382.png)

![integration_flows_fabric_data_pipelines_3.png](/.attachments/integration_flows_fabric_data_pipelines_3-5577bf40-4c8e-4dc9-b3e3-718d43ea81de.png)

![integration_flows_fabric_data_pipelines_5.png](/.attachments/integration_flows_fabric_data_pipelines_5-4811d804-e827-428e-8519-50f289f3fa7e.png)

