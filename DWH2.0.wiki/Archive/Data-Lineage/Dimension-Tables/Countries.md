---
# Countries Mapping
---

## Introduction

Countries is based on a SQL View in DWH called **dbo.Countries** which will be the _Target_ and it is derived from **dwh.Dim_Country** which will be the _Source_.

---

## Data Lineage

::: mermaid
 graph LR;
 A[dwh.Dim_Country] --> B[dbo.Countries] -->  C[Countries];
:::
---

## Source Details
Source Name: `dwh.Dim_Country`
Source Type: `Table`
Source System: `DWH SQL Server`


|Table Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|dwh.Dim_Country|  CountryCode|  nvarchar(20) | True  ||
|dwh.Dim_Country|  CountryName|  nvarchar(500) | True  ||
|dwh.Dim_Country|  ISOAlphaCode|  nvarchar(20) | True  ||
|dwh.Dim_Country|  ISONumericCode|  nvarchar(20) | True  ||
|dwh.Dim_Country|  CommercialRegionCode|  nvarchar(20) | True  ||
|dwh.Dim_Country|  CommercialRegionName|  nvarchar(500) | True  ||
|dwh.Dim_Country|  CreatedDateTime|  datetime2(3) | True  ||
|dwh.Dim_Country|  ModifiedDateTime|  datetime2(3) | True  ||
|dwh.Dim_Country|  ValidationStatus|  nvarchar(50) | True  ||
|dwh.Dim_Country|  KDP_SK|  bigint IDENTITY(1,1) | False||
|dwh.Dim_Country|  KDP_checksum|  int | True  ||
|dwh.Dim_Country|  KDP_executionId|  int | True  ||
|dwh.Dim_Country|  KDP_loadDT|  datetime| True  ||


---

## Target Details
Target Name: `dbo.Countries`
Target Type: `View`
Target System: `DWH SQL Server`


|View Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|dbo.Countries|  Country Key |  bigint IDENTITY(1,1) | False  ||
|dbo.Countries|  Country Code|  nvarchar(20) | True ||
|dbo.Countries|  Country Name|  nvarchar(500) | True ||
|dbo.Countries|  Commercial Region|  nvarchar(500) | True ||

---

## Field Mapping


| Source Table | Source Field  | Target Table  | Target Field  | Transformation Rules  | Data Type | Nullable  |
|--|--|--|--|--|--|--|
| dwh.Dim_Country| KDP_SK  |dbo.Countries|  Country Key | None | bigint IDENTITY(1,1)  |  False|
| dwh.Dim_Country| CountryCode| dbo.Countries|  Country Code| COALESCE(NULLIF([CountryCode, ''), 'N/A')| nvarchar(20) |  True|
| dwh.Dim_Country| CountryName| dbo.Countries|  Country Name| COALESCE(NULLIF([CountryName, ''), 'N/A')| nvarchar(500) |  True|
| dwh.Dim_Country| CommercialRegionName| dbo.Countries|  Commercial Region| COALESCE(NULLIF([CommercialRegionName, ''), 'N/A')| nvarchar(500) |  True|


---

## Transformation Rules

1. Country Code
`COALESCE(NULLIF(CountryCode, ''), 'N/A') `

2. Country Name
`COALESCE(NULLIF(CountryName, ''), 'N/A')`

3. Commercial Region
`COALESCE(NULLIF(CommercialRegionName, ''), 'N/A')`


---
### [Return to Dimension Tables](/Archive/Data-Lineage/Dimension-Tables)