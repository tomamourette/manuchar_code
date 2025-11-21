# General approach 


A dimensional model is one type of output of our ETL/data pipelines. It is commonly used by e.g. reporting and BI teams, and available in self-service BI scopes. It is a data product where the output is defined by the consumption layer (consumer aligned). This means that the content of the data model should reflect the requirements of the consumer(s) of this data model. 

In dimensional modeling, there are two main concepts to be generated: dimensions and facts.  

We adhere to following best practices when setting up a dimensional data model: 

## DIMENSIONS

A dimension contains all attributes that are relevant to an entity throughout time  

There will only be one singular dimension for every separate entity type that can be identified in the conceptual model of the source/application 

A dimension will always contain following fields 

bkey → a business key that contains a unique ID for this entity 

tkey → a technical key that is generated and uniquely depicts every row of this dimension, meaning it will combine the unique business ID and a specific status throughout time of that entity 

attributes → all attributes that are required by the consumer(s) of this model that are relevant to the entity at that point in time, and that can be attributed to that entity in a 1-to-1 manner  

from date → the moment from which this entity contains the attributes defined in this state of the entity 

to date → the moment up until this entity contains the attributes defined in this state of the entity. This will be NULL for the latest/current state of the entity 

Even when a dimension is not time dependent, and therefore only persists the current state of the entity, the same structure applies. The "from" date will be an explicit creation date when available in the source, or the first time this entity is observed by the data platform. The "to" date will always be NULL as it will always display the latest/current state of the entity   

Naming convention: dim_<entity> 

## FACTS

A fact contains all occurrences relevant to be shown in the required aggregation, on the lowest level of granularity that is needed  

Multiple facts can exists linked to multiple common dimensions. The requirements of the consumer of the dimensional model will define the necessary fact tables 

A fact will always contain following fields: 

tkey_date (and/or tkey_time) → technical key for the relationship with the dim_date table, it depicts the moment this fact happened for the entities involved. Date and time should always be stored separately. Date and time keys are obsolete when working with current/latest views of entities.  

tkey_<entity> → technical key for the relationship with every dimension required in this level of granularity 

numeric measures → a numeric value that depicts what happened in that level. These fields should all be summarizable. A date or time is not numeric or summarizable, and should be added as a count of occurrences on a specific date or time 

Naming convention: fact_<entity>_<aggregation/scope> 

 

When these best practices are implemented, there should always be an explicit link between dimension and fact. This significantly reduces complexity in the visualization layer, stimulates re-use of the dimensional model through multiple consumers and technologies, and promotes clarity of the data model. 

 

However, it should be noted one should never blindly implement the best practice without additional analysis and thought. 

_→ Always communicate with your colleagues and challenge each others vision in order to validate and optimize the model!_  

 

----------------------------------------------------------------------------- 

----------------------------------------------------------------------------- 

# Example use case 

## Subject and requirements 

Our client, Mickeysoft, has requested to provide some insightful dashboards on information from our Jira software, to provide better follow-up for all projects and clients. Together with the business, we have identified a use case for which a dimensional model should be created. This first use case should provide follow-up on creation and resolution of Jira issues. The data analyst made a prototype after identifying business requirements, and has validated this iteratively with the client. 

This prototype will always contain following elements: 

Visuals - These will correspond to the numeric measures available in the fact table(s), as well as the granularity of the fact table(s). Every numeric measure should be summarizable, such as a "sum" or "average" summarization, depending on the business logic required in the visual. You should be able to populate each visual with a field available in the fact table(s), with or without additional logic provided in the visualization logic.   

What metrics need to be visualized for the client? 

Filters - These will correspond to the dimension keys included in the fact table(s), on which we will be able to slice and roll up the  

What fields need to be available to filter the dashboard?  

Temporal context - This will correspond whether or not keys to the date and/or time dimension are included. In an overview of the current status, a date indication is irrelevant as we are watching the latest available information for each entity. It will also determine the required date and/or time granularity of the visuals.    

Do we want to view a current state of our source system, or do we want to visualize information throughout a granularity of time? 

 

→ As you can see, all requirements can be covered by the three types of fields available in the fact table(s): date and/or time key, dimension key(s), numeric measures. 

## Deliverables 

We will create a dimensional model to fulfill the requirements of following dashboard requested by our client.  

For this dashboard, we will create a combination of dimension and fact tables. Dimension tables should be common dimensions that can be re-used throughout the scope of the project, and the fact should be created in a granularity that covers as many (future) questions and requirements from the client. 

Following requirements can be identified: 

**VISUALS** 

Chart that displays amount of issues created by day throughout the selected date range 

Chart that displays amount of issues resolved by day throughout the selected date range 

Table that shows a row-level overview of issues in the selected scope  

**FILTERS** 

Possibility to filter on project → project in which the issue is created 

Possibility to filter on billing key → billing key that is linked to the issue 

Possibility to filter on pod → primary pod connected to the issue project  

**TEMPORAL CONTEXT** 

The client wants to be able to select a date range and have a drilldown overview on day, week, month and year level 

Way of working 

**DIMENSION TABLES** 

First of all, we will set up our dimension tables so we are able to populate our fact table(s). 

From our filters and visuals, we have determined we will need to be able to slice on following dimensions: 

_Issue_

_Project_ 

_Billing key_ 

_Date_

We will generate our dimension tables according to the best practices describe on this page. 

For example, our Issue dimension will be called dim_issue and will contain following fields: 

tkey_issue (technical key generated at creation of the dimension, based on row number) 

bkey_issue (business key generated from the unique identifier of this entity) 

<all relevant attributes, using lower case and underscores only e.g. creation_date, resolution_date> 

from_date (01/01/1970 if first status of the issue) 

to_date (NULL if latest status of the issue) 

**FACT TABLES** 

First of all, we will identify the temporal context of our fact table, before adding the numeric measures. 

We want to see changes over time, so we will have to include a date dimension key 

We want to see information with day as our lowest level of granularity, so records in our fact table will be aggregated on day level  

Next to that, we require following numeric measures: 

Amount of issue creations. Summarization will be "sum" 

Amount of issue resolutions. Summarization will be "sum" 

We will generate our fact table according to the best practices describe on this page. 

We can use a table called fact_issue to answer all requirements: 

tkey_date (data type INT, Day on which the fact happened in the selected granularity) 

tkey_issue (data type INT) 

tkey_project (data type INT) 

tkey_billing_key (data type INT) 

tkey_pod (data type INT) 

issue_creations (data type INT) 

issue_resolutions (data type INT) 

**RELATIONSHIPS BETWEEN DIMENSION AND FACT TABLES → STAR MODEL** 

As defined in our standard approach, we will have following relationships in our data model: 

one-to-many relationship from dim_date to fact_issue 

one-to-many relationships from all remaining dimension tables to fact_issue 

----------------------------------------------------------------------------- 

----------------------------------------------------------------------------- 
 
 
 

# Sidenotes and edge cases 

Of course, a best practice can never be used 100% of the time, as there will always be edge cases that require a specific approach. We aim to solve 80% of all possible use cases with this approach, and we will try to identify as many edge cases as possible with their accompanying best practices. These edge cases can be found below, and will be gradually expanded as we encounter these in our projects. 

## Edge case - Large amount of status identifiers to be visualized independently 

 A dimension can contain one or multiple status fields that have an extensive list of possible values (large field dictionary). In this case, our approach to explicitly define a column in the fact for every possible status will possibly generate a very wide fact if the functional requirements depict these statuses to be visualized independently. This causes efficiency losses regarding both readability and storage.  

**Approach**: 

We will store the status as an attribute in the fact. This means that the status will most likely be stored as a text field. 

A numeric measure should be added to show the count of the status over the required granularity/aggregation. 

This goes against our general best practice of never including attributes or text fields in our facts. However, it is a more efficient approach for this edge case 

Alternatively, the status can also be persisted as a separate dimension and a key to that dimension can be added to the fact. 

This goes against our general best practice of only creating a singular dimension for every entity that can be identified in the conceptual model of the source/application 

**Example**: when visualizing customer lifecycle or customer journey, multiple statuses can be defined that we want to visualize individually through time. Instead of persisting a column for each customer lifecycle status, which means 20 columns would need to be added for 20 relevant statuses, we can add the status as an attribute 

Another way to solve this is to add the 20 statuses to a specific dimension for the attribute of that entity e.g. dim_customer_status. However, we prefer the approach to add the status as an attribute to the fact whenever possible. 

----------------------------------------------------------------------------- 

----------------------------------------------------------------------------- 

# Additional information 

**What is dimensional modeling?** 

Dimensional modeling, as conceptualized by Ralph Kimball, is a methodology for organizing and structuring data in a data warehouse to facilitate effective business intelligence. At its core, it involves the creation of fact and dimension tables, providing a clear and accessible framework for analyzing and understanding complex datasets. The approach is designed to simplify data representation, enhance user comprehension, and optimize query performance. 

**Why do we use dimensional modeling?** 

Dimensional modeling is employed to address the specific needs of business intelligence and analytical processes. By organizing data into easily comprehensible fact and dimension tables, this methodology promotes simplicity and accessibility. It enables users, such as business analysts, to extract meaningful insights efficiently. The separation of facts and dimensions in this approach allows for streamlined data analysis, providing a solid foundation for decision-making and strategic planning within organizations. 

**What are facts and dimensions?** 

In dimensional modeling, facts and dimensions are fundamental components. Fact tables serve as repositories for quantitative, numeric data representing key performance metrics, while dimension tables contain descriptive attributes providing context to the data. Facts are measurable and numeric, such as sales figures, while dimensions add layers of understanding by categorizing data based on criteria like time, geography, or product details. 

**What is a slowly changing dimension?** 

A Slowly Changing Dimension (SCD) is a concept within dimensional modeling that addresses changes in dimensional data over time. Different types of SCDs handle these changes: 

- **Type 0 SCD:** In this type, no change is allowed in the dimension. Historical data remains unaffected, ensuring consistency over time. 
   
- **Type 1 SCD:** Changes in dimensional data overwrite existing values without preserving historical versions. This type is suitable when historical accuracy is not a critical consideration. 

- **Type 2 SCD:** This type introduces a new record for each change in the dimension, preserving historical versions. It includes attributes like start and end dates to manage the validity period of each version, allowing for comprehensive historical analysis. 

**What is a slowly changing dimension type 2 and why do we use it?** 

Slowly Changing Dimension Type 2 (SCD Type 2) is a technique used in data warehousing to track historical changes to data over time. Imagine you have a database storing information about products, and you want to keep track of changes like price updates or product descriptions over time. SCD Type 2 allows you to do this in a structured way. 

SCD2 maintains dimension history by creating newer ‘versions’ of a dimension record whenever its source changes. SCD2 does not delete or modify existing data. Basically when the source data changes you expire the existing record in the dimension table via an indicator (boolean or date or any standard technique of marking a record as expired by setting a flag). 

If history is not needed, we talk about a SCD type 1. This updates dimension records by overwriting the existing data — no history of the records is maintained. SCD1 is normally used to directly rectify incorrect data. Basically when the source data changes you directly apply an update on that record in dimension table. 

**How to tackle SCD type 2 as our standard approach of dimension modeling?** 

_Basic principles_ 

For each entity of which we want to hold the history, we will have at least 2 tables 

first table: {{name}}_updates (silver layer) → a table (preferably incremental table) which has the change history of the source table 

this is a (incremental) table storing all changes happening the the source table 

For example, all CDC rows coming from a source database 

second table: dim_{{name}}_history (gold layer)→ a view/derived table with a scd_valid_from and scd_valid_to fields 

this view/derived table wil be recalculated on each run. This can be daily, hourly, ... depending on the reporting needs and the frequency of which updates in underlying layers happen 

so for each entity (eg "JIra issues") we have 1 dim_{{name}}_history table concluding ALL attributes of that entity given a point in time 

Probably a one on one fact table with the dim_{{name}}_history will be of value for reporting (eg: I want to see the amount of issues in status X over time) 

Probably a fact_{{name}}_current will be of value for reporting: a fact which just has the current version of all issues 

For other aggregations on ANYTHING, a new fact table is needed 

eg: I want to know the average time period a ticket is in a status, of statuses that can be recurrent → new fact table: fact_issue_status_duration, this can be a dimensionless fact table, of it can include the tkey of dim_issue_history of the last version of the issue 

# FAQ 

**What should a dimension table look like?** 

The dimension table should be called "dim_<entity>_history", there is no additional current status dimension table by default. A dimension table should be directly linked to a conceptual entity, and contain all changes to all relevant attributes. It contains one entry for every unique entity ID for every update timestamp available. It contains "from" and "to" fields that display the time interval for which the . If the "to" field is NULL, the row contains the current status of the entity ID of that row.  

Example: the dim_issue_history table contains all changes of every attribute of the corresponding issue entity. 

What if the attributes of an entity do not change over time? 

The dimension table should be called "dim_<entity>", there is no additional history dimension table. It contains one entry for every unique entity ID. It does not contain "from" and "to" time intervals, every row contains the current status of the entity ID. 

Example: the dim_geo table contains all attributes relevant for the corresponding geo entity. 

**What should a fact table look like?** 

The fact table should contain the granularity and aggregation needed in a report/dashboard. Its row level should be equal to the lowest level of granularity needed in a (collection of) visualizations. It contains a combination of dimension keys, (numeric) measures and a date/time indication. 

Example: the fact_sales_monthly table contains one row for every month, the keys to every relevant entity such as product, store,... and the amount of sales. 

**What if I have to create a factless fact?** 

A factless fact will show changes that happen over time, without a numeric measure linked to the event or update being showed. It is often used to display status changes or events linked to underlying entities. It contains a combination of dimension keys and a date/time indication and contains no (numeric) measures. 

Example: the fact_issue_status contains one row for every change to the status of every issue, and when that change happened. It does not contain a numeric measure value. 

**I want to lower complexity in my data model by including as little dimensional tables as possible, how should I do this?** 

You should not. If a business use case or the underlying conceptual model contains a certain degree of complexity, this will always be present in either the data model or the visualization. As a data team, we have less control over the visualization layer compared the data transformation layer, and transformation logic can be re-used. Visualizations are not part of our data product, but are a consumer of the data product itself. Therefore, we choose to incorporate the "complexity" in the data model. 

Example: rather than building complex measures in our visualizations on a generic dimensional model, we will make "tailor-made" facts that will populate our visuals. The underlying dimensions will be used as slicers on our visualized data. 

**Our source data only provides attribute changes rather than entity changes, how should we process this in all different layers?** 

The bronze layer contains the raw data as-is, the silver layer contains all this data in a conformed manner. It should also always contain an aggregated view on the entity containing all relevant attributed changes/updates. 

Example: if an application sends issue_status updates and issue_name updates, these should be made available in our silver layer as attributes of an entity. Additionally, all change information to relevant attributes of the issue entity itself should also be available in an entity level table in the silver layer. The information of this entity can then be displayed in an SCD type 2 dimension table in the gold layer. 