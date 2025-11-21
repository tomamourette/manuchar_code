For row-level security, the goal is to restrict access to specific rows in a dataset based on the user’s identity or roles. To achieve this, a security mapping table,that defines which data a user can access, is needed in the data model, consider including a user-to-role or user-to-region mapping that defines which data a user can access.
This security table should link users (via their IDs or email addresses) to specific roles or permissions (e.g., regions, departments, etc.).

At Manuchar, the actual RLS is enforced in the PowerBI tentant. The attributes that are used to create RLS are:
*   BusinessType
*   BusinessUnit
*   Company
*   CustomerCountry



To use Entra ID groups together with Row-Level Security (RLS) in Microsoft Fabric, a strategy that allows those groups to be recognized and leveraged is needed.




Example of a security table:


| GroupName | CustomerCountry   |
|-----------|-------------------|
| MEX       | Mexico            |
| BEL       | Belgium           |
| HQ        | All               |



Link user to Group:

Power BI does not natively expose Entra group memberships 

Option1: Use Power BI's `USERNAME()` or `USERPRINCIPALNAME()` + Security Table

1. Create another table that maps users to groups (generate this from Entra using Graph API or manually maintain a table):
    
| UserPrincipalName      | GroupName           |
|------------------------|---------------------|
| tom@manuchar.com       | BEL|
| bob@manuchar.com       | MEX   |
| an@manuchar.com        | HQ|
        
    
2.  Load this into Power BI and use it to filter the fact table based on the current user with:
    
 [UserPrincipalName] = USERPRINCIPALNAME()
        
    
3.  Then join to your Group-to-Region mapping to apply row-level filters.
    

Option 2: Use Dynamic Lookup with Entra (via Microsoft Graph API or Synapse Link)

Automate the process of populating the `User-to-Group` mapping by:
*   Calling Microsoft Graph API regularly to get user memberships
    
*   Writing them to a Lakehouse `UserGroupMapping` table via Fabric notebooks or pipelines

*   Refresh that periodically (daily/hourly)
    
*   Then using that table for RLS
    
This makes it fully automated and synced with Entra.




