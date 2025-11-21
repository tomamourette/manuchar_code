Technical Design Overview – VNet Data Gateway (VDG) for Microsoft Fabric
------------------------------------------------------------------------

### Component Setup: OPDG vs VDG

::: mermaid
flowchart LR
    %% Network boundaries
    subgraph AzureVNet["Azure Virtual Network"]
        direction TB
        subgraph OPDG_Setup["Current Setup (OPDG on VM)"]
            A1["Fabric Services (Pipelines, Power BI)"]
            A2["OPDG Agent on Azure VM"]
        end

        subgraph VDG_Setup["Future Setup (VNet Data Gateway)"]
            B1["Fabric Services (Pipelines, Power BI)"]
            B2["Microsoft-Managed VNet Data Gateway"]
        end
    end

    subgraph VPN["Site-to-Site VPN Tunnel"]
        Gateway1["Azure VPN Gateway"]
        Gateway2["On-Prem VPN Device"]
    end

    subgraph OnPrem["On-Premises Network"]
        SQL1["SQL Server (10.0.16.12)"]
        SQL2["SQL Server (10.0.16.108)"]
    end

    %% Connections - OPDG path
    A1 --> A2
    A2 --> Gateway1
    Gateway1 --> Gateway2
    Gateway2 --> SQL1
    Gateway2 --> SQL2

    %% Connections - VDG path
    B1 --> B2
    B2 --> Gateway1

:::

### Objective

Transition from legacy On-Premises Data Gateway (OPDG) on Azure VM to Microsoft-managed VNet Data Gateway (VDG) for secure, scalable, and low-maintenance connectivity from Microsoft Fabric to on-premises SQL Servers, accessible via existing VPN tunnels.

### Current Setup (OPDG)

*   An Azure VM hosts the On-Premises Data Gateway.
    
*   The VM resides in a subnet that is connected to the on-premises environment via a site-to-site VPN.
    
*   Fabric services (Pipelines, Dataflows, Power BI) route data requests through the OPDG agent running on the VM.
    
*   This setup requires VM management, gateway updates, and is limited in scalability.
    

### Proposed Setup (VDG)

*   Two Microsoft-managed VNet Data Gateways will be deployed:
    *   **One for non-production environments**
        
    *   **One for production environments**
        
*   Each VDG is injected into a **dedicated subnet** within a **corresponding Azure subscription** (non-prod versus prod).
    
*   These subnets must already have or inherit:
    *   VPN-based connectivity to on-prem SQL Servers (e.g. `10.0.16.x`)
        
    *   Outbound rules to allow SQL traffic (port 1433)
        
    *   DNS resolution to either IP or hostname of SQL Servers
        

### Requirements from Infra Team

| Requirement | Description |
| --- | --- |
| Subnet access | Fabric must be able to deploy a managed gateway VM into the target subnet. Subnet must not have conflicting delegations. |
| VPN access | Subnet must be routed via the existing site-to-site VPN to reach on-prem IPs. This is already in place for the OPDG subnet. |
| NSG and UDR validation | Confirm that NSG allows outbound traffic to SQL Servers over port 1433, and that UDR routes to VPN Gateway are in place. |
| Region alignment | Subnet must be in the same Azure region as the Microsoft Fabric tenant. |
| Resource provider | Ensure that `Microsoft.ManagedNetwork` is registered in the Azure subscription. |

### Comparison: OPDG vs VDG

| Feature | OPDG on Azure VM | VNet Data Gateway |
| --- | --- | --- |
| Hosting | Self-managed Azure VM | Microsoft-managed gateway |
| Setup effort | Manual install, config, and VM provisioning | Subnet selection in Fabric UI |
| Maintenance | Requires patching, gateway upgrades | Zero maintenance (fully managed) |
| Scalability | Limited, single VM bottleneck | Scales automatically per workload |
| Security | Public outbound traffic via tunnel | Stays within Azure VNet |
| SLA and reliability | VM-based availability | Microsoft-managed high availability |
| Updates | Manual | Automatic |
| Resource cost | Azure VM cost (e.g., B4ms) + ops | Included in Fabric capacity billing |

