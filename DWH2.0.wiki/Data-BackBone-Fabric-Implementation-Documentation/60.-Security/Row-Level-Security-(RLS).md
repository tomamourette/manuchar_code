# Row-Level Security (RLS) Implementation

[[_TOC_]]

## Overview  

Row-Level Security (RLS) ensures that users only see the data they are authorized to access within the **Finance Data Products** semantic models.  

Access control is managed dynamically based on **Microsoft Entra ID group membership**, ensuring alignment between business requirements and IT governance.

The RLS design applies consistently across **all Finance Data Products**, enforcing security at the following levels (dimensions)
- **Company (Affiliate)**
- **Industry**
  
---

## Why Dynamic RLS  

After evaluating different strategies—**Static**, **Security Role-based**, and **Dynamic RLS**—the **Dynamic RLS** model was selected because it:  

- Scales across multiple affiliates and industries.  

- Automatically adapts when users are added or removed from Entra groups.  

- Supports many-to-many relationships between users and access domains.  

Static or hardcoded RLS rules were rejected, as they do not meet the complexity and flexibility required for Finance group-level access.

---

## Architecture  

The Dynamic RLS implementation combines data and security metadata from multiple layers:

| Component | Description |
|------------|--------------|
| **Microsoft Entra ID Groups** | Define access domains (e.g., by Company or Industry). Users are managed by IT and business owners. |
| **Operational Integration Layer (OIL)** | Loads group and membership data into structured tables. |
| **Transformation Layer (dbt)** | Builds the RLS mapping table through SQL logic that interprets group naming conventions. |
| **Semantic Model (Fabric / Power BI)** | Consumes the RLS mapping table and enforces row-level filters dynamically at query time. | 

---

## Entra Group Design and Loading Logic  

### Data Source  

The Entra group information is sourced from:  

- `OSS_GenericData_MHQ_Warehouse.REF_Entra.MS_Entra_Groups`  

- `OSS_GenericData_MHQ_Warehouse.REF_Entra.MS_Entra_GroupMembers`  

These tables are first loaded into the **Operational Integration Layer** during standard data refresh cycles and are then **mirrored into the `dbb_lakehouse`** for use in downstream transformation and RLS logic.

---

### Naming Convention and Filtering  

Only groups following the **FAB-DP-RLS** prefix are considered relevant for RLS.  

Group names follow this standardized convention:

```

<Company>_<Environment>_SA_FAB-DP-RLS_<Role>

```
| Segment | Description |
|----------|-------------|
| **Company** | The company or affiliate code (use `GLO` for global roles). |
| **Environment** | `P` (Production) or `Q` (Quality). |
| **Role** | Defines the access type, such as `RegionManager`, `Mgroup-`, or `Mindustry-<Industry>`. |

---

### Business Logic  

| Logic Type | Description |
|-------------|-------------|
| **Global Mgroup** | If a user is in a group like `GLO_<env>_SA_FAB-DP-RLS_Mgroup-*`, they are automatically granted access to **all companies** for that role within the same environment.  |
| **Global Mindustry** | If a user belongs to `GLO_<env>_SA_FAB-DP-RLS_Mindustry-<industrycode>`, they gain access to **all data for that industry** across companies in that environment. |
| **Company-Specific** | Users in company-specific groups (e.g., `MNV_P_SA_FAB-DP-RLS_RegionManager`) are restricted to their company data only. |

This logic is not replicated in Entra directly but handled **dynamically** within the Fabric transformation process.

> **Note:** Mgroup “All companies” refers specifically to **the set of companies that exist as Entra groups** in the current environment.

---

## dbt Model Logic
  
The RLS dbt model transforms Entra group and membership data into a **normalized RLS matrix**.  
It applies parsing, validation, and hierarchical rules to determine access scope per user.

### Steps Overview  

  

1. **Parse Groups**  

   - Extract key elements from group names: company, environment, category (`Mgroup`, `Mindustry`, or `Mcompany`), and role.  

   - Identify invalid or malformed group names for logging.  

  ![RLS Parse Groups](/.attachments/image-ad9f6234-0395-446b-b78a-de4b2c25ea3d.png)

2. **Join Members to Groups**  

   - Combine user membership (`GroupMembers`) with parsed group data to assign users to their access attributes.  

  ![RLS Join Members to Groups](/.attachments/image-54d7d7db-17cf-48ba-980c-06deba509055.png)

3. **Expand Access by Logic**  

   - **Mindustry Logic:** Users in Mindustry groups get access to *all companies* within that environment for their industry.  

   - **Mgroup Logic:** Users in Mgroup roles get access to *all RegionManager* companies within the same environment.  

   - **Mcompany Logic:** Direct one-to-one mapping (user-company).  

4. **Combine Results**  

   - Merge all results with defined **precedence rules**:  

     - `Mindustry > Mgroup > Mcompany`  

     - This ensures that higher-level global access supersedes company-specific rules.  

---  

## Final Output

The resulting RLS view contains the key fields used to enforce access filtering:

| Column | Description |
|---------|-------------|
| `user_principal_name` | The user’s Entra login (normalized to lowercase). |
| `company_code` | The company (affiliate) code that defines the user’s company-level access. |
| `industry_code` | The industry to which the user’s access applies, if relevant. |

This view is published in the **Fabric Warehouse** and referenced directly in the **semantic models** to apply dynamic row-level filtering.

---

### Build & Refresh Behavior

Since the **RLS table is implemented as a view**, automatically reflecting the latest Entra group memberships and access mappings.  
This ensures that user-to-company and user-to-industry permissions are always current without requiring manual refreshes.

---

## Integration in the Semantic Model  

The RLS matrix is joined to dimension tables (e.g., `dim_company`, `dim_industry`) using relationships defined in Power BI.  

A single Power BI role applies a dynamic DAX filter:


```DAX

[Username] = USERPRINCIPALNAME()

```

This filters the RLS table for the current user, cascading to related dimensions and fact tables.  

![RLS Integration in the Semantic Model](/.attachments/image-35bb2c92-a6e6-48ba-b01a-dd3fb3488d12.png)  

--- 

### Semantic Model Access Groups

In addition to the dynamic RLS setup, two **Microsoft Entra ID access groups** are assigned directly to the **semantic model** in Power BI / Fabric.  
These groups control **who can access the dataset** per environment:

| Environment | Entra Group Name | Purpose |
|--------------|------------------|----------|
| **QUAL** | `GLO_Q_SA_FAB-DP_FinGroup-FinancialStatements_All` | Grants users access to the Finance semantic models in the **QUAL** workspace. These correspond to Finance **test users** who perform **User Acceptance Testing (UAT)**. |
| **PROD** | `GLO_P_SA_FAB-DP_FinGroup-FinancialStatements_All` | Grants users access to the Finance semantic model in the **PROD** workspace. |

![RLS semantic model configuration](/.attachments/image-712dbe04-fa81-4541-bd47-5f358999a9e3.png)
These groups are added to the **RLS role (`UserBased`)** within the semantic model configuration (see image above).  


## Key Takeaways  

- RLS is **dynamic**, **automated**, and **centrally governed** via Entra.  

- Group naming conventions drive RLS logic across companies and industries.  

- dbt transformations consolidate and expand access according to predefined rules.  

- The final security table powers **dynamic filtering** in all Finance semantic models.  

This approach ensures consistent, secure, and scalable access management aligned with both business needs and Microsoft Fabric best practices.