_(Work in progress)_

In the Data BackBone (DBB), a layered medallion architecture is deployed combined with a decoupled-system approach. In order to validate each step of the ELT-flow, a multi-tiered Data Quality framework will be implemented.

This multi-tiered approach will make sure every step of the decoupled data integration and transformation is validated, without introducing dependencies on subsequent layers. The framework will aim to inform both BI and business teams, without having a blocking impact on the recurrent loads of the DBB.

## TIER 1 DATA QUALITY CHECKS

In the Bronze layer, we will perform basic Data Integrity checks.
When the source data lands in the Lakehouse of the DBB, we need to ensure that the data conforms to the structure and rules of the Data Source Agreement (DSA) set up for that specific source endpoint. This is required as our transformations depend on structurally sound and stable data.

Again, these checks will not have an active impact on the pipelines. As we work with decoupled systems, we want to inform the stakeholders and owners of the data instead of actively intervening in pipeline action.

### Checks performed in Tier 1

We will mainly perform Data Schema Validation in the bronze layer Tier 1 Data Quality checks, to ensure that incoming data adheres to the expected schema as defined in the Data Source Agreement.

Data Schema Validation consists of the following checks:
- Column completeness -> are the correct columns retrieved
- Column structure -> are there changes in the structure or order of the columns, for instance any switched columns or added columns not in the DSA
- Data types -> do these columns have data in the expected data types
- Data retrieval checks -> is the amount of selected records at the source equal to the amount of written records in the lakehouse, and are there any records selected/written or not

### Checks NOT performed in Tier 1

- Source-target (unique) record counts or comparisons
- Content-specific checks
- Timing or sync checks between source and target 
- Layer interdependent checks

## TIER 2 DATA QUALITY CHECKS

The second tier of Data Quality checks is aimed at the Silver layer of the DBB medallion architecture. Data Vault 2.0 modelling techniques (split up into a Raw Vault and Business Vault) are used in the Silver layer of the DBB, so we will make sure that data conforms to be integrated into this common enterprise data model.

### Checks performed in Tier 2

In the **Raw Vault**, where we ingest data from the Bronze layer into the first repository of the Silver layer, we will perform mostly technical Data Integrity checks. These are required as ingested data needs to be conformed to the structure of the Common Data (Vault) Model:

- Hash key and business key uniqueness: ensure that business keys and its generated hash keys are unique
- Hash key and business key completeness: ensure that business keys and its generated hash keys are filled in for every component of the Raw Vault
- Referential integrity: validate the technical referential integrity relationships between Hubs, Links and Satellites

In the **Business Vault**, where we prepare data from the Raw Vault to the Business Vault that contains , we will also perform Data Integrity checks, so the data conforms to the structure put forward in the Business layer of the Common Data (Vault) Model:

- Business key uniqueness: ensure that business keys are unique in all Business Vault tables such as Hubs, Satellites and Bridges
- Business key completeness: ensure that business keys are complete in all Business Vault tables such as Hubs, Satellites and Bridges
- Referential integrity: validate the technical referential integrity relationships between all Business Vault tables such as Hubs, Satellites and Bridges
- Referential integrity between Raw and Business Vault: ensure that Business Vault entities are properly linked back to their corresponding Raw Vault entities
- Data transformations validation: Validate that the required transformation logic is correctly applied and produces the expected results

### Checks NOT performed in Tier 2

As all data will be ingested from the Bronze layer into the Silver layer Raw Vault, we will not perform any initial checks on data cleansing, deduplication and business rule conformation. This is important as we want to be able to fully rebuild the source data itself, and trace it back to the initial source and ingestion timestamps. This will allow us to avoid accountability and traceability discussions between the DBB and the data source owners.

## TIER 3 DATA QUALITY CHECKS


### Checks performed in Tier 3



### Checks NOT performed in Tier 3