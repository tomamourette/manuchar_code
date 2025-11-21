## GENERAL 

The Power BI Semantic Models in Microsoft Fabric will form the Data Products that will be delivered to the Data Domains by the Data BackBone (DBB).

These Gold layer datasets will be modelled according to the best practices of Kimball dimensional modelling into a one-dimensional star model. This means the relationships between dimension and fact will always be singular in a one-to-many setup and snowflaking will not be allowed. The model will only include a subset of fact and dimension tables that were generated in the Gold layer dimensional model for the Data Domain, augmented with information so the model is usable for both standardized reports and self-service BI in the Data Domain at hand.

Following information will be added to semantic model, on top of the selected tables from the DBB:
- required relationships between dimension and fact tables
- additional calculations in the form of measures
- presentation layer renaming of measures and attributes
- hiding and unhiding of relevant business data
- row-level security rules for the Data Access configuration

Please note that the semantic model of the Domain Data Stores (DDS) will only include data from the selected subset of the DBB. The additional information will always be a variation in calculation and/or presentation of the same core data. External data sources will not be added through the visualization layer. If this is done, it will be managed and owned by the Data Domain Owners and falls out of scope of the centralized DBB.  

## TABLE STRUCTURE AND RELATIONSHIPS

The structure of the star model in the Semantic Model should always follow the following guidelines (example added below):
- Date dimensions (and time dimension, if applicable) should be placed at the top of the model, on the same horizontal level
- Fact table(s) should be placed directly under the date and time dimension, on the same horizontal level
- Common dimension tables should be placed directly under the fact table(s), on the same horizontal level
- All dimension tables should ONLY be connected to the fact table with a one-to-many relationship, and having a Single filter direction flowing from dimension to fact
- Intermediate RLS dimension table(s) should be connected to the required common dimension table(s)
- The RLS dimension should be connected to the common dimension using a many-to-many relationship

![DBB semantic model - Star model design.drawio.png](/.attachments/DBB%20semantic%20model%20-%20Star%20model%20design.drawio-5d3ee955-6c12-47b5-9686-aa89a179a515.png)


## CALCULATIONS / MEASURES 

All record-level data should be available in the DBB data model itself. This entails that all data used as input will be coming from the physical tables in the DBB Data Warehouse available in Microsoft Fabric.
All record-level attributes and measures will therefore be pre-calculated in the transformation layer, which means that (DAX) Calculated Columns should not be required in the Semantic model.

However, there is of course a need to summarize and aggregate the data in these records using specific rules. These rules can be a summarization that groups and combines different records, or it can be a time intelligence function. The definition of these calculations will be done using Measures in the Power BI Semantic model, using DAX as the definition language.

To summarize the addition of calculations (in the form om Power BI Measures), we can state the following:
- No new data is added to the model
- Measures will be used to define e.g. aggregation, summarization and time intelligence functions
- Measures will be added either to the relevant source table in a separate Measures/Calculations folder, or to a Measures table in the Semantic model
 
## VISIBILITY AND NAMING OF RELEVANT FIELDS

Only the fields relevant to the business users of the Data Domain will be made available for consumption in the Semantic model:

- For dimension tables, only attributes will be visible
- For fact tables, only numeric measures will be visible
- Of course, all defined calculations (in the form of DAX Measures) will be visible

All visible fields will be formatted to a pre-defined structure and naming convention. No technical fields or field names will be included.
Some examples:
- Technical keys (tkey) and business keys (bkey) will never be visible. The business key should be added as a separate attribute when relevant and/or required.
- In the Gold dimensional model, technical naming convention using snake case is used. This will be converted to a standard implementation of readable end-user fields: "customer_name" will be reformatted to "Customer Name".
- All report-level filters, measures and legends should also be reformatted to the semantic naming convention.
- All field names should be validated and confirmed with key business users to promote readability and clarity.

This way, the business user can only see the fields relevant in the context of the report or semantic model. Naming conventions in the semantic layer are discussed with business and validated throughout UAT phases.

## ROW-LEVEL SECURITY IMPLEMENTATION 

Row-level Security (RLS) will be implemented according to best practices documented here. Please refer to the dedicated documentation page of RLS for more information regarding both the functional and technical setup. 

## DOCUMENTATION PAGES

- Power BI Semantic Models ([link](https://learn.microsoft.com/en-us/power-bi/connect-data/service-datasets-understand))
- Relationships in Power BI Semantic Models ([link](https://learn.microsoft.com/en-us/power-bi/transform-model/desktop-create-and-manage-relationships))
- Row-level security in Power BI Semantic Models ([link](https://learn.microsoft.com/en-us/fabric/security/service-admin-row-level-security))
- Measures in Power BI Semantic Models ([link](https://learn.microsoft.com/en-us/power-bi/transform-model/desktop-measures))
- DAX functions in Power BI Semantic Models ([link](https://learn.microsoft.com/en-us/dax/dax-function-reference))
- Time intelligence functions in Power BI DAX ([link](https://learn.microsoft.com/en-us/dax/time-intelligence-functions-dax))