---
# Product Groups Mapping
---

## Introduction

Product Groups is based on a SQL View in DWH called **dbo.Product Groups** which will be the _Target_ and it is derived from **dwh.Dim_ProductGrouping** which will be the _Source_.

---

## Data Lineage

::: mermaid
 graph LR;
 A[dwh.Dim_ProductGrouping] --> B[dbo.Product Groups] -->  C[Products Groups];
:::
---

## Source Details
Source Name: `dwh.Dim_ProductGrouping`
Source Type: `Table`
Source System: `DWH SQL Server`

|Table Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|dwh.Dim_ProductGrouping|  ProductGroupingCode|  nvarchar(500) | True  ||
|dwh.Dim_ProductGrouping|  ProductGroupingName|  nvarchar(500) | True  ||
|dwh.Dim_ProductGrouping|  ProductBusinessUnitCode|  nvarchar(20) | True  ||
|dwh.Dim_ProductGrouping|  ProductBusinessUnitName|  nvarchar(500) | True  ||
|dwh.Dim_ProductGrouping|  ProductCategory|  nvarchar(500) | True  ||
|dwh.Dim_ProductGrouping|  ProductSubcategory|  nvarchar(500) | True  ||
|dwh.Dim_ProductGrouping|  CreatedDateTime|  datetime2(3)| True  ||
|dwh.Dim_ProductGrouping|  ModifiedDateTime|  datetime2(3)| True  ||
|dwh.Dim_ProductGrouping|  ValidationStatus|  nvarchar(50) | True  ||
|dwh.Dim_ProductGrouping|  KDP_SK|  bigint IDENTITY(1,1)| False||
|dwh.Dim_ProductGrouping|  KDP_checksum|  int | True  ||
|dwh.Dim_ProductGrouping|  KDP_executionId|  int | True  ||
|dwh.Dim_ProductGrouping|  KDP_loadDT|  datetime| True  ||

---

## Target Details
Target Name: `dbo.Product Groups  `
Target Type: `View`
Target System: `DWH SQL Server`

|View Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|dbo.Product Groups |  Product Group Key |  bigint IDENTITY(1,1) | False  ||
|dbo.Product Groups   |  Product Group Code |  nvarchar(500) | True ||
|dbo.Product Groups  |  Product Group Name|  nvarchar(500) | True ||
|dbo.Product Groups  |  Product BU|  nvarchar(500) | True ||
|dbo.Product Groups  |  Product  Group Category|  nvarchar(500) | True ||
|dbo.Product Groups  |  Product  Group Subcategory|  nvarchar(500) | True ||

---

## Field Mapping


| Source Table | Source Field  | Target Table  | Target Field  | Transformation Rules  | Data Type | Nullable  |
|--|--|--|--|--|--|--|
| dwh.Dim_ProductGrouping| KDP_SK  |dbo.Product Groups |  Product Group  Key | None | bigint IDENTITY(1,1)  |  False|
| dwh.Dim_ProductGrouping| ProductGroupingCode| dbo.Product Groups |  Product Group Code | COALESCE(NULLIF(ProductGroupingCode, ''), 'N/A')| nvarchar(500) |  True|
| dwh.Dim_ProductGrouping| ProductGroupingName| dbo.Product Groups |  Product Group Name| COALESCE(NULLIF(ProductGroupingName, ''), 'N/A')| nvarchar(500) |  True|
| dwh.Dim_ProductGrouping| ProductBusinessUnitName| dbo.Product Groups |  Product BU| COALESCE(NULLIF(ProductBusinessUnitName, ''), 'N/A')| nvarchar(500) |  True|
| dwh.Dim_ProductGrouping| ProductCategory| dbo.Product Groups |  Product Group Category| COALESCE(NULLIF(ProductCategory, ''), 'N/A')| nvarchar(500) |  True|
| dwh.Dim_ProductGrouping| ProductSubcategory| dbo.Product Groups |  Product Group Subcategory| COALESCE(NULLIF(ProductSubcategory, ''), 'N/A')| nvarchar(500) |  True|


---

## Transformation Rules
1. Product Group Code
`COALESCE(NULLIF(ProductGroupingCode, ''), 'N/A')`

2. Product Group  Name
`COALESCE(NULLIF(ProductGroupingName, ''), 'N/A')`

3. Product BU
`COALESCE(NULLIF(ProductBusinessUnitName, ''), 'N/A')`

4. Product Group Category
`COALESCE(NULLIF(ProductCategory, ''), 'N/A')`

5. Product Group Subcategory
`COALESCE(NULLIF(ProductSubcategory, ''), 'N/A')`



---
### [Return to Dimension Tables](/Archive/Data-Lineage/Dimension-Tables)Dimension-Tables)