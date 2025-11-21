---
# Products Local Mapping
---

## Introduction

Products Local is based on a SQL View in DWH called **dbo.Products Local** which will be the _Target_ and it is derived from **dwh.[Dim_LocalProduct]** which will be the _Source_.

---

## Data Lineage

::: mermaid
 graph LR;
 A[dwh.Dim_LocalProduct] --> B[dbo.Products Local] -->  C[Products Local];
:::
---

## Source Details
Source Name: `dwh.Dim_LocalProduct`
Source Type: `Table`
Source System: `DWH SQL Server`

|Table Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|dwh.Dim_LocalProduct|  LocalProductCode|  nvarchar(500) | True  ||
|dwh.Dim_LocalProduct|  LocalProductName|  nvarchar(500) | True  ||
|dwh.Dim_LocalProduct|  GroupProductCode|  nvarchar(50) | True  ||
|dwh.Dim_LocalProduct|  GroupProductName|  nvarchar(500) | True  ||
|dwh.Dim_LocalProduct|  ProductGroupingCode|  nvarchar(50) | True  ||
|dwh.Dim_LocalProduct|  ProductGroupingName|  nvarchar(500) | True  ||
|dwh.Dim_LocalProduct|  ProductBusinessUnitCode|  nvarchar(20) | True  ||
|dwh.Dim_LocalProduct|  ProductBusinessUnitName|  nvarchar(500) | True  ||
|dwh.Dim_LocalProduct|  ProductCategory|  nvarchar(500) | True  ||
|dwh.Dim_LocalProduct|  ProductSubcategory|  nvarchar(500) | True  ||
|dwh.Dim_LocalProduct|  CompanyCode|  nvarchar(1000) | True  ||
|dwh.Dim_LocalProduct|  CompanyName|  nvarchar(500) | True  ||
|dwh.Dim_LocalProduct|  GradeCode|  nvarchar(50) | True  ||
|dwh.Dim_LocalProduct|  GradeDescription|  nvarchar(500) | True  ||
|dwh.Dim_LocalProduct|  PackagingTypeCode|  nvarchar(50) | True  ||
|dwh.Dim_LocalProduct|  PackagingTypeDescription|  nvarchar(500) | True  ||
|dwh.Dim_LocalProduct|  FormCode|  nvarchar(50) | True  ||
|dwh.Dim_LocalProduct|  FormDescription|  nvarchar(500) | True  ||
|dwh.Dim_LocalProduct|  PackagingSize|  decimal(18,2) | True  ||
|dwh.Dim_LocalProduct|  PackagingUnitOfMeasureCode|  nvarchar(20) | True  ||
|dwh.Dim_LocalProduct|  PackagingUnitOfMeasureDescription|  nvarchar(500) | True  ||
|dwh.Dim_LocalProduct|  Quality|  decimal(18,2) | True  ||
|dwh.Dim_LocalProduct|  CAS|  nvarchar(500) | True  ||
|dwh.Dim_LocalProduct|  Chemwatch|  nvarchar(500) | True  ||
|dwh.Dim_LocalProduct|  MSDSDate|  datetime2(3)| True  ||
|dwh.Dim_LocalProduct|  CreatedDateTime|  datetime2(3)| True  ||
|dwh.Dim_LocalProduct|  ModifiedDateTime|  datetime2(3)| True  ||
|dwh.Dim_LocalProduct|  ValidationStatus|  nvarchar(50) | True  ||
|dwh.Dim_LocalProduct|  KDP_SK|  bigint IDENTITY(1,1)| False||
|dwh.Dim_LocalProduct|  KDP_checksum|  int | True  ||
|dwh.Dim_LocalProduct|  KDP_executionId|  int | True  ||
|dwh.Dim_LocalProduct|  KDP_loadDT|  datetime| True  ||

---

## Target Details
Target Name: `dbo.Products Local`
Target Type: `View`
Target System: `DWH SQL Server`

|View Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|dbo.Products Local| Local Product Key |  bigint IDENTITY(1,1) | False  ||
|dbo.Products Local| Local Product Code |  nvarchar(500) | True ||
|dbo.Products Local|Local  Product Name|  nvarchar(500) | True ||
|dbo.Products Local|Local  Product CAS Number |  nvarchar(500) | True ||
|dbo.Products Local|Local  Product Chemwatch Number |  nvarchar(500) | True ||
|dbo.Products Local| Local Product MSDS Date|  datetime2(3)| True  ||


---

## Field Mapping


| Source Table | Source Field  | Target Table  | Target Field  | Transformation Rules  | Data Type | Nullable  |
|--|--|--|--|--|--|--|
| dwh.Dim_LocalProduct| KDP_SK  |dbo.Products Local| Local Product Key | None | bigint IDENTITY(1,1)  |  False|
| dwh.Dim_LocalProduct| LocalProductCode| dbo.Products Local|Local  Product Code | COALESCE(NULLIF(LocalProductCode, ''), 'N/A')| nvarchar(500) |  True|
| dwh.Dim_LocalProduct| LocalProductName| dbo.Products Local|Local  Product Name| COALESCE(NULLIF(LocalProductName, ''), 'N/A')| nvarchar(500) |  True|
| dwh.Dim_LocalProduct| CAS| dbo.Products Local|Local  Product CAS Number| COALESCE(NULLIF(CAS, ''), 'N/A')| nvarchar(500) |  True|
| dwh.Dim_LocalProduct| Chemwatch| dbo.Products Local|Local  Product Chemwatch Number| COALESCE(NULLIF(Chemwatch, ''), 'N/A')| nvarchar(500) |  True|
| dwh.Dim_LocalProduct| MSDSDate| dbo.Products Local|Local  Product MSDS Date| None | datetime2(3) |  True|


---

## Transformation Rules
1. Local Product Code
`COALESCE(NULLIF(LocalProductCode, ''), 'N/A')`

2. Local Product Name
`COALESCE(NULLIF(LocalProductName, ''), 'N/A')`

3. Local Product CAS Number
`COALESCE(NULLIF(CAS, ''), 'N/A')`

2. Local Product Chemwatch Number
`COALESCE(NULLIF(Chemwatch, ''), 'N/A')`



---
### [Return to Dimension Tables](/Archive/Data-Lineage/Dimension-Tables)