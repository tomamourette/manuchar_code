Implementing Object-Level Security in Microsoft Fabric and Power BI
===================================================================

Introduction
------------

Object-Level Security (OLS) provides the ability to restrict access to specific metadata objects in a semantic model, such as tables or columns, rather than restricting the data itself (as with Row-Level Security). This is useful when you need to hide entire objects from users based on their roles, often for confidentiality, simplification, or compliance reasons.

Key Concepts and Use Cases
--------------------------

*   **Table-level security**: Prevent access to entire tables.
    
*   **Column-level security**: Prevent access to specific columns within a table.
    
*   **Separation of business domains**: Hide sensitive or irrelevant information per user group.
    
*   **Compliance**: Restrict access to PII or financial data based on regulations.
    

How OLS Works
-------------

Object-level security is implemented in the tabular model using **Model Roles** in Power BI Desktop or via **TMSL/XMLA** scripting. It is then deployed to the Power BI Service or Microsoft Fabric workspace.

### Supported Tools

*   Power BI Desktop (via Tabular Editor or scripting)
    
*   Tabular Editor 2 or 3 (recommended)
    
*   Power BI XMLA endpoint (for scripting & automation)
    
*   Power BI Service (for deployment & role testing)
    

Defining Object-Level Security
------------------------------

1.  **Create a Role** (in Tabular Editor or via TMSL)
    
2.  **Assign Metadata Permissions**:
    *   `None`: Fully hide the object from the model
        
    *   `Read`: Allow visibility
        
3.  **Apply at Object Level**:
    *   Entire table: hide from the user
        
    *   Specific columns within a table
        

    {
      "roles": [
        {
          "name": "RestrictedAccess",
          "tablePermissions": {
            "Finance": "None",
            "Sales": "Read"
          },
          "columnPermissions": {
            "Customers": {
              "SSN": "None",
              "Name": "Read"
            }
          }
        }
      ]
    }
    

Applying Roles in Power BI Service
----------------------------------

Once deployed, users are assigned to roles in the Power BI Service. Unlike RLS, OLS is enforced **before** query execution and **removes the object entirely** from the model metadata for the user.

> ⚠️ Users will not be aware that a table or column even exists unless they are granted permission.

### Important:

*   Power BI workspace roles (Viewer, Contributor, Admin) **do not** override OLS.
    
*   OLS is enforced at model level and **affects all connected tools**, including Excel and Power BI.
    

External Tools (Excel, DAX Studio, Connected Services)
------------------------------------------------------

OLS is enforced consistently in external tools when users authenticate via SSO:
*   **Excel / Analyze in Excel**: Hidden tables and columns will not be visible in Pivot Table Fields.
    
*   **DAX Studio**: Users will not be able to discover or query hidden objects.
    
*   **Third-party tools**: Subject to the same enforcement if using user-based authentication.
    

Best Practices
--------------

*   Use OLS for **metadata simplification** and **confidentiality**, not for transactional filtering (use RLS instead).
    
*   Avoid over-fragmenting your model with too many role definitions.
    
*   Document which roles control which objects and why.
    
*   Test with actual user assignments and connected tools (Excel, Power BI Service).
    

Limitations
-----------

*   OLS cannot be defined in Power BI Desktop UI — requires Tabular Editor or scripting.
    
*   OLS applies only to Import or DirectQuery models using the XMLA endpoint (not Live Connection to SSAS).
    
*   There is no dynamic object-level filtering (e.g., no OLS based on dynamic expressions like USERNAME()).
    

When Not to Use OLS
-------------------

*   If you need dynamic visibility based on user identity → use **RLS**.
    
*   If performance is critical and you can redesign the model → consider splitting into separate semantic models.
    
*   For simple visual hiding in reports → use **report-level measures and visibility**, not OLS.
    

Conclusion
----------

Object-Level Security is a powerful tool in the semantic modeling toolkit of Microsoft Fabric and Power BI. When applied properly, it can dramatically simplify user experiences, enhance security, and align with regulatory requirements. Use it selectively and in combination with Row-Level Security where needed for a layered security approach.