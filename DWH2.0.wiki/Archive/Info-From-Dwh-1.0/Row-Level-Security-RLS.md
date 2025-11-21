
# Intro
Row Level Security is used to control access to data on a row - level. At Manuchar, the actual RLS is enforced in the PowerBI tentant.
The attributes that are used to create RLS are: 
- BusinessType
- BusinessUnit
- Company
- CustomerCountry

##PowerBI:
RLS is enforced by using the emailaddress/domainname of the user accessing the report/dataset.

This is done in the report itself by using the DAX variable that refers to the user's emailaddress or domainname.
The domainname is listed in a SQL table called 'dwh.Sec_RLS_Mapping' in which the user is mapped to an integer.

This Integer represents a set of combinations of Foreign keys in the fact table, in such a way that the Integer related to the user acts as a filter on the data of the fact table.


::: mermaid
sequenceDiagram
    user->>PowerBIreport: requests data
    PowerBIreport-->>dwh.sec_RLS_Mapping: takes username and looks up the security combinations
    dwh.sec_RLS_Mapping->> FactTable : applies security keys to fact table
    FactTable ->> PowerBIreport : filters data
    PowerBIreport->>user : shows filtered data
:::



##SQL
Much like in a star diagram, the logic of RLS can be interpreted as a Dimension table and its related Fact table.
###RLS-Dimension
the RLS-Dimension is built by combining 
- all the possible key combinations of the 4 attributes (BusinessType, BusinessUnit, Company & CustomerCountry) from the dwh.fact_ tables [dwh.sec_KeyCombinations]
- the group settings, configured in MDS, combined with all 4 Dimensional keys [dwh.sec_groupsettings]
- the combination of above 2 tables results in the following table: [dwh.MappingGroupKeyCombination]
- mapping of the users to the applicable groups [dwh.sec_MappingGroupUser]
- the combination of the above 2 tables results in the final group [dwh.sec_RLS_Mapping]

###RLS-Fact
in the fact_tables (or the appropriate views) the dimensional table [dwh.sec_keyCombinations] is joined again using the FK-keys of the 4 attributes (-1 if the attribute key does not exist in the facttable).
This will give us the key of that specific Key-combination per row, allowing us to relate every user to their applicable key combinations.

**note:**
in the previous iteration, the Customer-attribute was used instead of CustomerCountry. The latter reduces the amount of resulting combinations a lot smaller.
In case a fact-table can deliver the customer-key, an addition join needs to be created to deliver the distinct countries related to that customer. (see key-schema below)


## Logical Schema: 

::: mermaid
graph LR
H(dwh.Fact_AccountsPayable) --> T{dwh.Sec_KeyCombinations}
I[dwh.Fact_AccountsReceivable] --> T{dwh.Sec_KeyCombinations}
J[dwh.Fact_AccountsReceivableWeeklySnapshot] -->  T{dwh.Sec_KeyCombinations}
K[dwh.Fact_Consolidations] --> T{dwh.Sec_KeyCombinations}
L[dwh.Fact_InvoiceGuarantees] -->  T{dwh.Sec_KeyCombinations}
M[dwh.Fact_InvoiceProvisions] -->  T{dwh.Sec_KeyCombinations}
N[dwh.Fact_Invoices] -->  T{dwh.Sec_KeyCombinations}
O[dwh.Fact_SalesPlans] -->  T{dwh.Sec_KeyCombinations}
P[dwh.Fact_Stock] -->  T{dwh.Sec_KeyCombinations}
Q[dwh.Fact_TradingOrderIntakes] -->  T{dwh.Sec_KeyCombinations}
R[dwh.Fact_FXExposures] -->  T{dwh.Sec_KeyCombinations}
A[MDS_Security_Group_settings] --> B{dwh.sec_groupsettings}
C[Dim_BusinessUnit] --> A
D[Dim_BusinessType] --> A
E[Dim_Company] --> A
F[Dim_Customer] --> A
G[Dim_Country] --> F
T --> B
B --> S{dwh.MappingGroupKeyCombination}
U[dwh.sec_mappingGroupUser] --> S
S --> V{dwh.sec_RLS_Mapping}
:::

## Key-schema:

|  |FK_Company|FK_BusinessType|FK_BusinessUnit|FK_Customer(country)|
|--|--|--|--|--|
|Fact_Consolidations     | X |  |  |  |
|Fact_InvoiceGuarantees  | X |  |  | X |
|Fact_Stock              | X | X | X |  |
|Fact_InvoiceProvisions  | X |  |  | X |
|Fact_invoices           | X | X | X | X |
|Fact_AccountsPayable    | X | X |  |  |
|Fact_AccountsReceivableWeeklySnapshot| X | X | X | X |
|Fact_FXExposures        | X | X |  |  |
|Fact_AccountsReceivable | X | X | X | X |
|Fact_TradingOrderIntakes| X | X | X | X |
|Fact_SalesPlans         | X | X | X | X |
|... All New Facts         | X | X | X | X |
|Fact_EFA - (related)         | X | X | X | X |

#Development UserStories & Work
#27215

##Explination with related Stored Procedures and Tables below:
###Security Groups are maintained in MDS - Normally Thomas Voet
select * from ds.mds_Security_Mapping sm
where [security groups_name] = 'Trading STEEL SAM'

###Security User Groups are maintained in MDS - Normally Thomas Voet this indicates to which security groups a user should belong to
select * from ds.mds_Security_User_Group_Mapping

###Creates all possible instances for the specific security groups
Procedure [dwh].[prcFillSecGroupSettings]

select * from dwh.Sec_GroupSettings
where groupname = 'Trading STEEL SAM'

###Creates the Security Key combination for all the possible values of businessType, BusinessUnit, CustomerCountry and Company.

Procedure [dwh].[prcFillSecKeyCombinations]
select * from dwh.Sec_KeyCombinations

*when EFA Facts (or any other facts) are created they will need to be added to this procedure to allow for updated Security Keys*

###this uses the dwh.Sec_GroupSettings table to build all possible options for a specific security group. so if a user belongs to this  group, they will be able to access those security Key Combinations
Procedure [dwh].[prcFillSecMappingGroupKeyCombination]

select * from dwh.sec_mappinggroupkeycombination
where groupname = 'Trading STEEL SAM'

###Creating a user table, adding correct email addresses and domain users and shows to what groups they are allowed to view
Procedure [dwh].[prcFillSecMappingGroupUser]

select * From [dwh].[Sec_MappingGroupUser]
where mailAdres like 'Arthur.vanmi%'

###allocates Key Combinatio values by joining the user to the security group and displays all the security keys they should be able to view
Procedure [dwh].[prcFillSecRLS_UserMapping]

select	* 
from [dwh].[Sec_RLS_Mapping]
where mailAddress like 'Arthur.vanmi%'

###Procedure to execute all the SP's that was created in sequence. also to add a few updates to data that does not filter through correct from AAD - -Azure Active Directory
Procedure [dwh].[prcFillSecTables]