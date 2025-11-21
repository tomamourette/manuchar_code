As described in the Cost Components section, we have two main cost drivers in a Microsoft Fabric analytics platform:

- **Compute** - The compute resources needed in order to realize all Fabric component workloads. Done by the selected _Microsoft Fabric Capacity_
- **Storage** - The OneLake storage that is used to persist all data and metadata of the Microsoft Fabric platform

The built-in functionality in Microsoft Fabric called the [Fabric Capacity Metrics App](https://learn.microsoft.com/en-us/fabric/enterprise/metrics-app) can be used in order to devise a cost allocation strategy for Manuchar.

The cost allocation will be done using the follow hierarchy and rules.
A Fabric Workspace contains Fabric components that utilize compute, and save data towards the OneLake enterprise storage. A Workspace always has a 1-to-1 relation to its connected Fabric Capacity.

- Utilized compute in the _Workspace_ can be expressed in Capacity Units (CU). This amount of CU can be expressed as a percentage of the total CU being used in the Fabric Capacity. **This should be the basis of the cost allocation for Compute**.
- Every _Workspace_ has dedicated folder space in the OneLake storage of the enterprise. **This should be the basis of the cost allocation for Storage**.
- Every Workspace should have a 1-to-1 relationship to a Domain. This Domain can be defined and assigned in Microsoft Fabric (more information can be found [here](https://learn.microsoft.com/en-us/fabric/governance/domains)). **This should be the basis of cost allocation between Workspaces**.
- The combination of Workspaces and Domains can be linked to different Cost Centers. **This will be used to allocate their portion of the utilized Cost Components**.

Beneath two screenshots can be found that display the available data and definitions in the Fabric Capacity Metrics App. The first is linked to Compute and the second is linked to Storage.

**Compute**

![image001.png](/.attachments/image001-63c3d00d-d429-4890-8b64-f8d0f304d2e1.png)

**Storage**

![image002.png](/.attachments/image002-f16fca6c-104e-4c27-9e4e-967c2a10551d.png)

The datasets provided by the Microsoft Fabric platform that are used to build this reporting will be used as a basis of allocation over recurring periods, such as on a monthly basis.