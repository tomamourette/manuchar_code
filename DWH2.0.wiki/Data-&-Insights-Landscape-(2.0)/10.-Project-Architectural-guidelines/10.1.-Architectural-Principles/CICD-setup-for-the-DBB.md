# CI/CD Process Documentation for the Data Backbone Fabric Workspace

---
## Overview

This document explains the CI/CD process for the Data Backbone Fabric workspace that is connected to Azure DevOps. The pipeline automates the deployment of contents (e.g., datasets, reports, notebooks) across different environments (Development, Test, Production), ensuring smooth and consistent updates.

---

## Table of Contents
1. Objective
2. Architecture Overview
3. Pre-requisites
4. CI/CD Pipeline Setup
o	Source Control Integration
o	Build Pipeline
o	Release Pipeline
5. Environment Configuration
6. Approval Workflow

---
##Objective

The primary goal of this CI/CD pipeline is to streamline and automate the deployment process for the Data Backbone Microsoft Fabric workspace, minimizing manual intervention, reducing errors, and ensuring the consistency of deployments across Development, Test, and Production environments.

---

##Architecture Overview

1. **Source Control**: Azure Repos stores the source code and content definitions (e.g., Power BI datasets, dataflows, notebooks).

2. **CI/CD Pipeline**: Azure Pipelines handles build and release processes. The pipeline is triggered by changes to the codebase, automatically building, testing, and deploying content to the appropriate environments.

3. **Environments**: Separate workspaces for Development, Test, and Production, each managed by the pipeline.

---

##Pre-requisites

1. **Microsoft Fabric Workspace**: Set up and configured with environments for Development, Test, and Production.

2. **Azure DevOps Project**: Configured with Azure Repos for source control and Azure Pipelines for CI/CD.

3. **Service Connections**: Service connections configured in Azure DevOps to access the Microsoft Fabric workspace and Azure resources.

---

##CI/CD Pipeline Setup
---
###Source Control Integration

1.	**Repository Structure**:

The [Databackbone is saved in an Azure Devops Repository](https://dev.azure.com/manuchar/Databackbone/_git/data.backbone) and it includes the content definition files, scripts, and pipeline YAML configurations.


/data.bacbone
├── /integration
│   ├── /datasets
├── /orchestration
│   ├── /components
├── /transformation
│   ├── /dbt
└── azure-pipelines.yml


- **Orchestration**: the MS Fabric workspace items should be correctly linked & synced to the corresponding workspaces of the DBB (D/T/A/P). It should be looked at how and if the Deployment Pipelines in PowerBI / Fabric should be used for deployment over workspaces and parameters / connections 

- **Integration**: changes to source lists, data source definition and source metadata should be managed over the D/T/A/P environments. Should not contain environment specific information, but abstracted to data source info

- **Transformation**: changes to dbt project definitions and models should be synced over environments. Different "profiles" endpoints should be managed over different environments to connect to corresponding SQL endpoint of MS Fabric workspace.



2.	**Branching Strategy**:
The main branch is where the production branch is based and for new features/testing, use develop of ongoing development.

---


===== <TO FILL> =======
## Build Pipeline

1.	**Pipeline Configuration (YAML)**:

2.	**Build Validation**:

---

## Release Pipeline

1.**Pipeline Stages**:

- **_Test_**: Automatically deploys validated content to the Test workspace.

- _**Acceptance**_: Deploys to Acceptance after successful Test deployment, often requiring automated or manual approval.

- _**Quality**_: Deploys to Quality for testing with production data, often requiring automated or manual approval.

- _**Production**_: Final deployment to Production, requiring manual approval.


2.**Deployment Tasks**:

=== <FILL UP TO HERE> ===

---

##Environment Configuration

There are currently 3 environment groups set up in the Library Pipelines with each environment: DevelopmentGroup, TestGroup, and ProductionGroup.

Each Group contains:
- AZCOPY_AUTO_LOGIN_TYPE: `SPN`
- AZCOPY_SPA_APPLICATION_ID: `Environment specific SPA ID`
- AZCOPY_SPA_CLIENT_SECRET: `Environment specific Client Secret`
- AZCOPY_TENANT_ID: `Environment specific TenantID`
- lakehouse_id: `Environment specific lakehouse ID`
- workspace_id: `Environment specific workspace ID`

---

##Approval Workflow

• Implement manual approvals for critical stages (Test to Production).

• Define approvers in Azure DevOps to review and approve the deployments.

---


     