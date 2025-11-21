  
---
To set up the Quality Environment, we need 5 main things.
 
1. Fabric Workspace for Quality
2. SPN specific for Quality - FAB_DBB_QUAL
3.  Security of the Workspace - 
4.  Resource Deployment - Includes all the resources in the workspace
5.  Config Deployment -  Includes all the dbt code, source codes and metadata
6.  Data Deployment - Includes all the data that we ingest/transform
---
After that, we can do a smoke test including but not limited to:

1.  Running the whole orchestration pipeline
2.  Checking if everything is running fine with correct data
3.  Creating the semantic model
4.  Compare a report to the values that we generate.
---
##Deployment:
### Resource Deployment

1.  For Workspace access, it should be the same as these. I will be adding them later once everything is done. Or not depending on security.

![==image_0==.png](/.attachments/==image_0==-e833b9a3-83df-4cda-8b17-688ae1c96752.png) 

2.  Having Workspace admin access on FAB_DBB_QUAL has allowed me to create a Deployment pipeline. Where there are now 4 envs, Test, Acceptance, Quality and Production.


![==image_1==.png](/.attachments/==image_1==-9a8647bf-514b-403e-9e01-804d89c94197.png) 

3.  Added the same rights in the DBB resource deployment pipeline.
![==image_2==.png](/.attachments/==image_2==-644f291f-9e43-46df-aa82-9f5edc5af17b.png) 

Now that the resources are deployed. The data and config also needs to be deployed.

---
###Config Deployment
  
1.  I created a quality branch for Quality config deployment.

![==image_3==.png](/.attachments/==image_3==-bb88f2ec-bd08-430c-930e-03a6311bab7f.png) 

2.  So now, there is already a quality branch, but it still needs to be deployed in Fabric. I also added in the Pipelines>> Library>> Variable Group >> variable_fabric_dbb_quality to have all the variables here to use. We can link the secrets to an Azure keyvaut, but it can be for future. Add this to the technical debt.


![==image_4==.png](/.attachments/==image_4==-db5fa3eb-b443-4671-b299-2e77bf041f90.png) 

![==image_5==.png](/.attachments/==image_5==-40820fed-ba99-4e86-95e4-44c789b8d20f.png) 

![==image_6==.png](/.attachments/==image_6==-3cbf18c6-0dd5-41bf-99da-d2c2633bf005.png) 

3.  The config deployment also needs to be adjusted to add the quality environment. Here it is named data.backbone. The yaml file is already adjusted to also update quality with the config files.

Now we have 2 out of 3 deployed. We only need to do the data deployment which takes more time as we need to test the data and run that the pipeline is correct.

---

### Data Deployment

1.  Create the connections in the "[Manage Connections and Gateways](https://app.fabric.microsoft.com/groups/dda19ee2-c492-4ace-a2a0-9dc85489b570/gateways?experience=power-bi)"

1.  dbb_lakehouse_QUAL with SPN
2.  dbb_warehouse_QUAL with SPN
![==image_7==.png](/.attachments/==image_7==-7b169b0d-b958-4697-8db9-afd24d8a358a.png) 

1.  Adding the Quality connections in the dbb_lakehouse >> Files >> integration >> integration_source_connetions.csv ([integration_source_connections.csv - Repos](https://dev.azure.com/manuchar/Databackbone/_git/data.backbone?path=/integration/integration_source_connections.csv))
![==image_8==.png](/.attachments/==image_8==-a16ca924-3b70-47c7-b2bd-52240efd4e4f.png) 

1.  The dbb_warehouse tables are not included when deploying the resource. So the Schemas and tables needs to be added. I just added them manually for now. Still have to check how to do it in a deployment.


![==image_9==.png](/.attachments/==image_9==-97c60d17-aa5e-4c2a-8920-70c2195cbe08.png) 

The current focus now is on testing the pipelines in the QUAL environment to ensure everything functions as expected.

---

## Resources used:
1. [Data Backbone Quality Wokspace](https://app.fabric.microsoft.com/groups/dda19ee2-c492-4ace-a2a0-9dc85489b570/list?experience=power-bi)
2. [Data Backbone Manual Deployment Pipeline](https://app.fabric.microsoft.com/pipelines/f425a554-0428-4316-bf2a-5a4452ea1589?experience=power-bi)
3. [Azure DevOps Repo](https://dev.azure.com/manuchar/Databackbone/_git/data.backbone/branches)
4. [Azure DevOps Pipeline Variable Groups](https://dev.azure.com/manuchar/Databackbone/_library?itemType=VariableGroups)
5. [Azure DevOps Pipelie](https://dev.azure.com/manuchar/Databackbone/_build)
6. [DBB_Warehouse](https://app.fabric.microsoft.com/groups/dda19ee2-c492-4ace-a2a0-9dc85489b570/warehouses/e595f16c-208c-4733-b0ad-158be3db507a?experience=power-bi)
---
