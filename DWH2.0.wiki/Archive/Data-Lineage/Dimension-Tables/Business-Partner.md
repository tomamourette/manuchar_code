---
# Business Partner Mapping
---

## Introduction

Business Partner is based on a SQL View in DWH called **dbo.Business Partner** which in this case will be our _Target_ and it is derived from **dwh.Dim_BusinessPartner** table which will be the _Source_.

---

## Data Lineage

::: mermaid
 graph LR;
 A[dwh.Dim_BusinessPartner] --> B[dbo.Business Partner] -->  C[Business Partner];
:::
---

## Source Details
Source Name: `dwh.Dim_BusinessPartner`
Source Type: `Table`
Source System: `DWH SQL Server`


|Table Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|dwh.Dim_BusinessPartner  |  BusinessPartnerCode|  nvarchar(500) | True  ||
|dwh.Dim_BusinessPartner  |  BusinessPartnerName|  nvarchar(500) | True  ||
|dwh.Dim_BusinessPartner  |  OriginalLegalNumber|  nvarchar(50) | True  ||
|dwh.Dim_BusinessPartner  |  LegalNumber|  nvarchar(50) | True  ||
|dwh.Dim_BusinessPartner  |  CountryCode|  nvarchar(20) | True  ||
|dwh.Dim_BusinessPartner  |  CountryName|  nvarchar(500) | True  ||
|dwh.Dim_BusinessPartner  |  CommercialRegionName|  nvarchar(500) | True  ||
|dwh.Dim_BusinessPartner  |  Address|  nvarchar(500) | True  ||
|dwh.Dim_BusinessPartner  |  ZIPCode|  nvarchar(20) | True  ||
|dwh.Dim_BusinessPartner  |  City|  nvarchar(500) | True  ||
|dwh.Dim_BusinessPartner  |  IntercompanyCode|  nvarchar(20) | True  ||
|dwh.Dim_BusinessPartner  |  IntercompanyDescription|  nvarchar(500) | True  ||
|dwh.Dim_BusinessPartner  |  IsIntercompany|  bit | True  ||
|dwh.Dim_BusinessPartner  |  IndustryTypeCode|  nvarchar(20) | True  ||
|dwh.Dim_BusinessPartner  |  IndustryTypeDescription|  nvarchar(500) | True  ||
|dwh.Dim_BusinessPartner  |  MultinationalBusinessPartnerCode|  nvarchar(500) | True  ||
|dwh.Dim_BusinessPartner  |  MultinationalBusinessPartnerName|  nvarchar(500) | True  ||
|dwh.Dim_BusinessPartner  |  MultinationalLegalNumber|  nvarchar(50) | True  ||
|dwh.Dim_BusinessPartner  |  MultinationalCountryCode|  nvarchar(20) | True  ||
|dwh.Dim_BusinessPartner  |  MultinationalCountryName|  nvarchar(500) | True  ||
|dwh.Dim_BusinessPartner  |  CreatedDateTime|  datetime2(3) | True  ||
|dwh.Dim_BusinessPartner  |  ModifiedDateTime|  datetime2(3) | True  ||
|dwh.Dim_BusinessPartner  |  ValidationStatus|  nvarchar(50) | True  ||
|dwh.Dim_BusinessPartner  |  KDP_SK|  bigint IDENTITY(1,1) | False||
|dwh.Dim_BusinessPartner  |  KDP_checksum|  int | True  ||
|dwh.Dim_BusinessPartner  |  KDP_executionId|  int | True  ||
|dwh.Dim_BusinessPartner  |  KDP_executionId|  int | True  ||
|dwh.Dim_BusinessPartner  |  KDP_loadDT|  datetime | True  ||

---

## Target Details
Target Name: `dbo.Business Partner`
Target Type: `View`
Target System: `DWH SQL Server`


|View Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|dbo.Business Partner |  Business Partner Key |  bigint IDENTITY(1,1) | False  ||
|dbo.Business Partner |  Business Partner GK |  nvarchar(50) | True ||
|dbo.Business Partner | Business Partner Legal Number | nvarchar(50)| True||
|dbo.Business Partner | Business Partner Name |  nvarchar(500) | True ||
|dbo.Business Partner |  Business Partner Address|  nvarchar(500) | True||
|dbo.Business Partner |  Business Partner ZIP Code |  nvarchar(20) | True ||
|dbo.Business Partner | Business Partner City | nvarchar(500)| True||
|dbo.Business Partner | Business Partner Country Code |  nvarchar(20) | True ||
|dbo.Business Partner |  Business Partner Country Name |  nvarchar(500) | True ||
|dbo.Business Partner |  Business Partner Commercial Region |  nvarchar(500) | True ||
|dbo.Business Partner | Business Partner Intercompany?| nvarchar(500)| True||
|dbo.Business Partner | Business Partner Parent Name |  nvarchar(500) | True ||
|dbo.Business Partner |  Business Partner Legal Number|  nvarchar(50) | True||
|dbo.Business Partner |  Business Partner Country Name |  nvarchar(500) | True ||
|dbo.Business Partner | Business Partner Customer Default Industry | nvarchar(500)| True||

---

## Field Mapping

| Source Table | Source Field  | Target Table  | Target Field  | Transformation Rules  | Data Type | Nullable  |
|--|--|--|--|--|--|--|
| dwh.Dim_BusinessPartner |KDP_SK  |dbo.Business Partner  |  Business Partner Key | None | bigint IDENTITY(1,1)  |  False|
| dwh.Dim_BusinessPartner |Country Code, Legal Number  |dbo.Business Partner   |  Business Partner GK | CONCAT_WS('-', CountryCode, LegalNumber) | nvarchar(50)  |  True|
| dwh.Dim_BusinessPartner | LegalNumber  |dbo.Business Partner   |  Business Parter Legal Number | None |  nvarchar(50) |  True|
| dwh.Dim_BusinessPartner | BusinessPartnerName  |dbo.Business Partner   |  Business Parter Name| None |  nvarchar(500) |  True|
| dwh.Dim_BusinessPartner | Address  |dbo.Business Partner   |  Business Parter Address| None |  nvarchar(500) |  True|
| dwh.Dim_BusinessPartner | ZIPCode  |dbo.Business Partner   |  Business Parter ZIP Code| None |  nvarchar(20) |  True|
| dwh.Dim_BusinessPartner | City  |dbo.Business Partner   |  Business Parter City| UPPER(City)|  nvarchar(500) |  True|
| dwh.Dim_BusinessPartner | CountryCode  |dbo.Business Partner   |  Business Parter Country Code| none|  nvarchar(20) |  True|
| dwh.Dim_BusinessPartner | CountryName  |dbo.Business Partner   |  Business Parter Country Name| UPPER(CountryName) |  nvarchar(500) |  True|
| dwh.Dim_BusinessPartner | CommercialRegionName  |dbo.Business Partner   |  Business Parter Commercial Region| None |  nvarchar(500) |  True|
| dwh.Dim_BusinessPartner | IntercompanyDescription  |dbo.Business Partner   |  Business Parter Intercompany?| None |  nvarchar(500) |  True|
| dwh.Dim_BusinessPartner | MultinationalBusinessPartnerName  |dbo.Business Partner   |  Business Partner Parent Name| None |  nvarchar(500) |  True|
| dwh.Dim_BusinessPartner | MultinationalLegalNumber  |dbo.Business Partner   |  Business Partner Parent Legal Number| None |  nvarchar(50) |  True|
| dwh.Dim_BusinessPartner | MultinationalCountryName  |dbo.Business Partner   |  Business Partner Parent Country Name | None |  nvarchar(500) |  True|
| dwh.Dim_BusinessPartner | IndustryTypeDescription  |dbo.Business Partner   |  Business Partner Customer Default Industry| COALESCE([IndustryTypeDescription], '') |  nvarchar(500) |  True|

---

## Transformation Rules

For this table, there are minimal change:

1.  Business Parter GK 
`CONCAT_WS(' - ', [CountryCode], [LegalNumber])`

2. Business Parter City
`UPPER([City])`

3. Business Parter Country Name
`UPPER([CountryName])`

4. Business Partner Customer Default Industry
`COALESCE([IndustryTypeDescription], '')`



---
### [Return to Dimension Tables](/Archive/Data-Lineage/Dimension-Tables)