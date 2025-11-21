Implementing Row-Level Security in Microsoft Fabric and Power BI
================================================================

Overview of RLS Options
-----------------------

In our evaluation of row-level security (RLS) strategies within Microsoft Fabric and Power BI, we considered three main approaches:
*   **Static RLS**
    
*   **Security RLS (role-based mapping via Entra ID groups)**
    
*   **Dynamic RLS**
    
Static RLS, while simple to set up using hardcoded rules and linking roles to Microsoft Entra ID groups, was determined to be insufficient for our business requirements. This approach lacks the flexibility needed for dynamic filtering based on the complex, many-to-many relationships between users and security attributes such as country, product, or business unit.
Therefore, we selected **Dynamic RLS** as our implementation strategy.

Dynamic RLS Architecture
------------------------

Dynamic RLS enables fine-grained, flexible access control that adapts to user group membership. Our approach integrates the following components:

### Components

1.  **Semantic Models (Power BI)**
    *   Contain dimension and fact tables for various data domains and use cases.
        
    *   Enforce row-level filtering based on user context.
        
2.  **Microsoft Entra ID Groups**
    *   Created in collaboration with Security and business stakeholders.
        
    *   Contain users who share the same access rights.
        
3.  **Security Mapping Table (Dynamic RLS Matrix)**
    *   Built and maintained in the transformation layer (ETL).
        
    *   Maps user names to access rights across one or more dimensions (e.g., country, product).
        
    *   Derived by extracting user-group mappings from Entra ID and transforming them into user-access combinations.
        

Implementation Flow
-------------------

1.  **Group Setup**
    *   Microsoft Entra ID groups are created for access domains (e.g., `Finance_BE`, `Sales_EU_ProductX`).
        
    *   Users are added to appropriate groups by Security or delegated admins.
        
2.  **ETL Mapping Logic**
    *   Group memberships are extracted and translated into a security mapping matrix.
        
    *   Each row represents a single access rule for a user, such as:
        *   `john.doe@company.com` has access to `Country = BE`
            
        *   `john.doe@company.com` has access to `Product = A`
            
    *   Users may have multiple rows depending on the number of dimensions or combinations they need access to.
        
    *   The mapping between users and groups, as well as groups to roles or filtering rules, will be retrieved via the Microsoft Graph API. This integration will run recurrently alongside other ETL loads to ensure up-to-date synchronization of user-group-role relationships.
        
    *   The mapping between groups and roles (which filtering rules they correspond to) is also maintained in a dedicated table. It is essential that this mapping is properly governed and maintained, as it directly drives the output and structure of the security matrix.
        
    *   **Load frequency of the user-group-role mappings must be carefully monitored.** Any lag in updates may cause users to have incorrect access, resulting in potential security breaches or inconsistent data visibility. Alignment between the security matrix and available data is critical.
        
3.  **Semantic Model Integration**
    *   The security matrix is loaded as a table into the semantic model.
        
    *   It is joined to relevant dimension tables using standard relationships.
        
    *   RLS rules are defined using DAX filters such as:
        
            [Username] = USERPRINCIPALNAME()
            
        
        *   These filters apply to the security matrix table and cascade to dimension tables, and ultimately to fact tables.
            
    *   Power BI roles must be configured with this DAX filter and published to the Power BI Service.
        
    *   In the Power BI Service, only one role is typically defined per semantic model, with the logic for filtering handled dynamically via the security matrix.
        
    *   There is **no need to create separate roles per access scenario**—the matrix and DAX handle this dynamically. However, it is critical to ensure that all filtering logic is captured correctly and that default roles do not result in access to all data unless explicitly intended.
        
    *   To define a role with unrestricted access (e.g., admins or auditors), users can be assigned to a group with a special designation such as `FullAccess = TRUE` in the mapping table, and the DAX filter should explicitly bypass security rules for those users.
        
    *   It is important to understand how access levels in Power BI work: users can be assigned **Viewer**, **Contributor**, **Member**, or **Admin** roles at the workspace or dataset level. These roles affect what they can do in terms of editing and publishing, **they DO override Row-Level Security filters** automatically.
        
    *   Therefore, if a user has a Contributor role or higher in a workspace, **RLS will NOT apply on the semantic model**. If the user can edit the semantic model, RLS does not apply on them.          
        
        
4.  **User Login & Filtering**
    *   When a user opens a report, their Entra username is passed to the semantic model.
        
    *   The security matrix filters down to rows matching the username.
        
    *   Joins filter down relevant dimension records.
        
    *   Fact tables are filtered indirectly via dimension table relationships.
        

Security Matrix Schema Proposal
-------------------------------

The following columns are recommended for optimal clarity and performance in the security matrix:
*   `username` (normalized, e.g. lowercase email address)
    
*   `group_id` or `group_name`
    
*   `role_id` or `role_name`
    
*   `dimension_type` (e.g., `Country`, `Product`, `BusinessUnit`)
    
*   `dimension_key` (technical/surrogate key matching dimension table)
    
*   `full_access_flag` (boolean flag to bypass filters for some users)
    
*   `valid_from`, `valid_to` (for time-bounded access)
    
*   `last_synced` (for ETL monitoring and traceability)
    
Use indexes on `username`, `dimension_key`, and `dimension_type` to ensure efficient filtering.

Design Considerations & Best Practices
--------------------------------------

*   **Always filter on dimensions**, not on fact tables or on composite keys. This approach is strongly recommended by Microsoft for performance and maintainability reasons.
    
*   **Many-to-many relationships** between the security matrix and dimensions allow flexible access modeling (e.g., users accessing multiple countries or products).
    
*   **One-to-many relationships** between dimensions and facts ensure fact table filtering.
    
*   **Role intersection logic** (e.g., combining `Country = BE` and `Product = A`) is modeled via multiple rows in the security matrix. This means default behavior is an **AND (intersection)** logic across filtered dimensions.
    
*   **Role union logic** (e.g., access to either Country A or Product B) requires additional modeling if needed but is not recommended unless absolutely necessary.
    
*   **Use technical keys (surrogate keys) in all joins and relationships**, especially when joining the security matrix to dimension tables. This ensures consistency and performance in filtering logic.
    
*   **Ensure case-insensitive matching for usernames**, especially if your tenant uses mixed-case identifiers. Consider normalizing all usernames (e.g., using `LOWER()`) during ETL.
    
*   **Monitor changes in Entra ID group membership** as part of your data quality checks to validate that users are properly mapped.
    
*   **Include effective dates (valid_from, valid_to)** in the mapping table if security assignments can change over time. This is useful for auditing and historical analysis.
    
*   **Log and alert on failed joins or mismatches** between the security matrix and dimension tables, which may indicate stale or incorrect group-role mappings.
    

Future Flexibility
------------------

While we currently implement standard dimension-based filtering for Dynamic RLS, more advanced security modeling (e.g., direct fact filtering or N-operator combinations) remains possible for specific use cases. However, these should be avoided unless justified by a business or technical requirement, as they introduce additional complexity and can degrade performance.

Conclusion
----------

Our Dynamic RLS strategy ensures scalable and secure access to sensitive data across Microsoft Fabric and Power BI. It aligns with Microsoft best practices, supports flexible business requirements, and allows future extensibility while maintaining semantic clarity and performance.

Disclaimer on Performance and Complexity
----------------------------------------

The effectiveness and performance of Dynamic RLS depend on the complexity and granularity of the implementation. Applying RLS at a very detailed level or directly on fact tables can significantly impact both report performance and ETL load times. Careful architectural planning is required to avoid bottlenecks and ensure a scalable security model.

RLS Behavior in External Tools (e.g., Excel, DAX Studio, Connected Services)
----------------------------------------------------------------------------

When users access semantic models outside of Power BI reports—such as through Excel, DAX Studio, or third-party connected tools—**Row-Level Security still applies** under the following conditions:
*   The user must authenticate via **Single Sign-On (SSO)** using their Microsoft Entra ID credentials.
    
*   The semantic model must be published in the Power BI Service or Microsoft Fabric workspace with RLS roles defined.
    

### Behavior in Excel

When connecting to a dataset from Excel (e.g., via "Analyze in Excel" or a Power BI dataset connection):
*   The user's identity is passed through SSO.
    
*   The security model defined in Power BI, including any Dynamic RLS, is enforced in the same way as when viewing a Power BI report.
    
Users will only see the data they are authorized to access based on the dynamic filters applied in the semantic model.

> ⚠️ Note: If a user downloads the dataset (e.g., through export options) or connects via a service principal with elevated rights, additional safeguards must be in place to ensure RLS is enforced.

### Behavior in Other Clients (DAX Studio, Paginated Reports)

*   If users connect interactively and authenticate with their own Entra ID account, Dynamic RLS will be respected.
    
*   If connections use a service principal or a non-user-based identity (e.g., system-to-system API), RLS will **not** be applied unless explicitly configured.
    
Always test critical access paths for RLS compliance in both visual and non-visual tools.