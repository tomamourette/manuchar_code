# General introduction

Throughout the Data BackBone, source data is refined, enriched and transformed in order to increase the data quality and the insights gained from the information inside the source data. 
This is done in multiple layers, where each layer has its own general purpose, and where additional technical layers can be used to fulfil another purpose.

The Data BackBone is built using Medallion Architecture, where each schema is designated towards the Bronze, Silver or Gold layer. In general, following rules apply across these overarching three "medallion layers":
- The **Bronze** layer will contain only data as-is from the source, without any enrichment or transformations. This is beneficial in order to promote traceability, auditability and historization efforts.
- The **Silver** layer will contain only data that flows through it from the Bronze layer to enable full transparency on lineage. Multiple transformations, combinations and enrichments will be done to this data, in order to knead it into several intermediate schema's that can either be source-aligned or entity-aligned, according to the requirements of the layer definitions.
- The **Gold** layer will contain our Data Products. The data inside the Gold layer can take multiple forms, to best fit the requirements put forward in the delivery and usage of the Data Product. In some way it will contain curated, transformed and aggregated business-relevant information. It will host the Domain Data Stores (DDS), flat tables for analysis, etc.

# The Manuchar Information Model (MIM)

The Manuchar Information Model is a conceptual entity model, based on the business information model that can consolidated from the different operational flows inside the organization.
It should be designed and maintained by business stakeholders, as it directly reflects the core operations within the different business units, affiliates, etc.

The MIM can and should be used as an input towards entity-aligned modeling in both the Silver and Gold layer. The entities in the ERD of the MIM should be present in the Data Vault structure of the Silver layer. The Gold layer Domain Data Stores (DDS) should also be aligned to these same entities and concepts.

Please refer to the dedicated MIM documentation for a more thorough explanation of the different concepts and design logic.

# End-to-end explanation across all layers

Throughout the platform, we can identify following layers, as is in line with the agreed upon architecture design.
Each layer is separated physically in a schema in a database, but also logically by the data it contains.
For each layer we will provide following information:
- **Medallion layer**: does the layer belong to Bronze, Silver or Gold
- **Purpose**: what is the logical purpose of this layer, what is the end result you can expect
- **Physical location**: in what physical database and schema is the data stored
- **Naming convention**: what naming conventions and prefixes are used
- **Keys**: what business and technical keys are used in order to distinguish records and information across tables
- **Modeling technique**: which modeling technique is applied e.g. Data Vault, Kimball, 3NF,...

## Source data
- _Medallion layer_: **Bronze**
- _Purpose_: as-is source data, full historized layer of all source data for lineage, traceability, auditability
- _Physical location_: **dbo** schema in the **dbb_lakehouse** (Fabric Lakehouse in DBB Workspace)
- _Naming convention_: <**source name**>__<**schema name**>_<**table name**>
- _Keys_: no specific keys are defined, as this is source data as-is and not managed or conformed in any other way
- _Modeling technique_: /

## Source views
- _Medallion layer_: **Silver**
- _Purpose_: deduplicated, conformed and trusted source-aligned endpoints of all source tables. Rudimentary enrichment when required 
- _Physical location_: **silver** schema in the **dbb_warehouse** (Fabric Data Warehouse in DBB Workspace)
- _Naming convention_: sv_<**source name**>_<**table name**>
- _Keys_: in order to perform deduplication, we require a **technical field or combination of fields** that is used to partition on unique records
- _Modeling technique_: /

## Raw vault (Physical implementation of the Manuchar Information Model)
- _Medallion layer_: **Silver**
- _Purpose_: source-aligned & entity-aligned satellites will consolidate all information of an entity that can be found in a physical source. These can be linked to an entity-aligned hub that contains all business keys of that entity
- _Physical location_: **silver** schema in the **dbb_warehouse** (Fabric Data Warehouse in DBB Workspace)
- _Naming convention_: rv_sat_<entity name>_<source name> and rv_hub_<entity name>
- _Keys_: the raw vault **satellites** are the transition between the source-aligned and entity-aligned views. Therefore, two keys will be required: **tkey_<satellite table name>** will make sure that we have unique technical records in the table. This key is _equal to the technical key used in the source view_ of the leading table(s) that define the granularity of the satellite. A **bkey_<entity>** will always be added in both satellite and hub, so every record can be linked to the corresponding business entity. Note that the hub will only contain all unique bkey values, but the satellite will possibly contain multiple values for each key
- _Modeling technique_: Data Vault

## Business vault (Physical implementation of the Manuchar Information Model)
- _Medallion layer_: **Silver**
- _Purpose_: source-aligned & entity-aligned satellites will consolidate all information of an entity that can be found in a physical source. These can be linked to an entity-aligned hub that contains all business keys of that entity
- _Physical location_: **silver** schema in the **dbb_warehouse** (Fabric Data Warehouse in DBB Workspace)
- _Naming convention_: bv_<**entity name**>
- _Keys_: every record will have a **bkey_<entity>**. Note that there can be multiple records for each entity ID, as the business vault will be built up over the temporal dimension
- _Modeling technique_: Data Vault

## Domain Data Store
- _Medallion layer_: **Gold**
- _Purpose_: business aggregated normalized schema optimized for analytics and reporting using PowerBI
- _Physical location_: **dds_<domain>** schema in the **dbb_warehouse** (Fabric Data Warehouse in DBB Workspace) + Semantic Model in the Domain Fabric Workspace
- _Naming convention_: dim/fact_<**entity name**>
- _Keys_: As modeling is done using Kimball dimensional modeling design principles, **tkeys** and **bkeys** will be added accordingly to dimensions and facts, to fulfill best practice implementation of this approach
- _Modeling technique_: star model (Kimball)

# Example: building up the entity "Supplier"

As an example, we will have a look at how the entity "Supplier" can be built up out of its source tables, and will ultimately result in a denormalized Business Vault table in our gold layer. This table can in turn be used towards e.g. the domain data stores, where data is stored in a dimensional star model, or be used in direct query analysis or as input towards an AI/ML model.
As mentioned before, we will take abstraction of the technical integration flow of the data itself, and focus on the different transformations done to the data after ingestion to the Bronze layer Lakehouse.
We will also make a simplification that Supplier information only comes from the VendTable and VendGroup tables in D365.

![E2E-example-DBB-Supplier.png](/.attachments/E2E-example-DBB-Supplier-3f09c6c1-a57c-4af1-8f80-34b78faf0351.png)
