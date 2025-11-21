# Semantic Model Refresh Configuration

## Overview

This document outlines the standard implementation for automating Power BI semantic model refreshes using a Python notebook and the REST API. It also describes an optional, more advanced method for managing refreshes across multiple workspaces using a metadata-driven approach.

---

## Standard Implementation: REST API Refresh Notebook

The primary method for refreshing semantic models is by using the `orchestration_notebook_semantic_model_refresh.py` notebook. This script connects to Power BI and automatically refreshes the data for all semantic models in every workspace that the designated service principal has access to.

### How it Works
The Python script performs the following steps:
1.  **Authenticates**: It uses a service principal's credentials (Client ID and Client Secret) to securely connect to the Power BI service.
2.  **Discovers Workspaces**: It automatically finds all the Power BI workspaces that the service principal has permission to access.
3.  **Refreshes Datasets**: For each workspace found, it identifies all the semantic models (datasets) and sends a command to refresh each one.

This process ensures that all your Power BI reports are consistently updated with the latest data without needing any manual intervention.

### How to Use it in a Pipeline
The notebook is designed to be run within an orchestration pipeline (e.g., in Microsoft Fabric).

1.  **Configure Credentials**: The notebook requires the `TENANT_ID`, `CLIENT_ID`, and `CLIENT_SECRET` of the service principal. These credentials should be stored securely in a service like Azure Key Vault and passed to the notebook as parameters when the pipeline runs.
2.  **Execute the Notebook**: Add the notebook to your pipeline and trigger it. The script will handle the rest of the process automatically.

### File Locations
-   **Python Notebook**: [`Data-BackBone-Fabric-Implementation-Documentation/00.-Orchestration-&-Components/orchestration_notebook_semantic_model_refresh.py`](Data-BackBone-Fabric-Implementation-Documentation/00.-Orchestration-&-Components/orchestration_notebook_semantic_model_refresh.py)
-   **Azure DevOps Scheduler (Example)**: [`Data-BackBone-Fabric-Implementation-Documentation/00.-Orchestration-&-Components/fabric-pipeline-scheduler-daily.yaml`](Data-BackBone-Fabric-Implementation-Documentation/00.-Orchestration-&-Components/fabric-pipeline-scheduler-daily.yaml)

### Prerequisites
-   The service principal must have the necessary permissions on each target Power BI workspace.
-   In the Power BI tenant settings, the "Allow service principals to use Power BI APIs" option must be enabled.

---

## Optional Enhancement: Metadata-Driven Refresh for Multiple Workspaces

For more complex environments, such as managing different service principals for different workspaces (e.g., in TST, ACC, and PRD environments), a metadata-driven approach is recommended. This provides greater flexibility and centralized control.

### How it Works
This method uses a central configuration table to define which workspaces should be refreshed and which credentials should be used for each one. The orchestration pipeline reads this table and dynamically executes the refreshes.

### Configuration Table: `meta.semantic_model_refresh_config`
A central table, `meta.semantic_model_refresh_config`, stores the configuration. **Crucially, this table does not store actual secrets.** It only stores the *names* of the secrets, which are kept securely in Azure Key Vault.

#### Table Schema
| Column Name                         | Data Type | Description                                                                    |
| ----------------------------------- | --------- | ------------------------------------------------------------------------------ |
| `config_id`                         | `INT`     | Primary key for the configuration entry.                                       |
| `workspace_id`                      | `STRING`  | The Power BI workspace ID to be refreshed.                                     |
| `environment`                       | `STRING`  | The environment this configuration applies to (e.g., `TST`, `ACC`, `PRD`).       |
| `key_vault_secret_name_client_id`   | `STRING`  | The **name** of the secret in Azure Key Vault that holds the Client ID.          |
| `key_vault_secret_name_client_secret` | `STRING`  | The **name** of the secret in Azure Key Vault that holds the Client Secret.      |
| `is_active`                         | `BOOLEAN` | A flag to enable or disable the refresh for this entry.                        |
| `description`                       | `STRING`  | A brief description of the workspace or its purpose.                           |

### Pipeline Integration Logic
An orchestration pipeline would be configured to:
1.  Read the active configurations from the `meta.semantic_model_refresh_config` table.
2.  For each configuration, use the secret names to fetch the actual Client ID and Secret from Azure Key Vault.
3.  Use the fetched credentials to authenticate and trigger the refresh for the corresponding `workspace_id`.