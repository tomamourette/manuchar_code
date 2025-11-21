At the moment of writing, different Cost Components can be identified:

- **Microsoft Fabric Capacity** - The _compute_ that is utilized for all workloads done by Fabric components. Expressed in Capacity Units (CU).
 
- **OneLake Storage** - The _storage_ used to persist both data and metadata that is being used by all the processes and components.

- **Mirroring** - When setting up near real-time database replicas in Microsoft Fabric, there is a provisioned _included_ Mirroring storage, for any additional resulting storage, OneLake pricing will be applied.

Official and up-to-date pricing of these components can be found using this link:
[Microsoft Fabric - Pricing](https://azure.microsoft.com/en-us/pricing/details/microsoft-fabric/)

Overall it can be stated that Compute costs linked to the Microsoft Fabric Capacity component will largely exceed all Storage costs and will take up the largest part of the cost of the Microsoft Fabric platform.

In the future, capacity-less or serverless pricing models will be rolled-out for Microsoft Fabric Compute, which should be taken into account once released and a cost re-assessment should be done.

Please note that additional infrastructural components (such as on-premises data gateways, VM's that act as gateway machines, VNET's, VPN tunnels, etc.) will not be taken into account into this calculation, as they are not linked to the scope of the Data BackBone itself.