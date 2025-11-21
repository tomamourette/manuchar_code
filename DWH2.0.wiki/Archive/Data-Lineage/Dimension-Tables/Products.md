---
# Products Mapping
---

## Introduction

Products is based on a SQL View in DWH called **dbo.Products** which will be the _Target_ and it is derived from **dwh.Dim_Product** which will be the _Source_.

---

## Data Lineage

::: mermaid
 graph LR;
 A[dwh.Dim_Product] --> B[dbo.Products ] -->  C[Products ];
:::
---

## Source Details
Source Name: `dwh.Dim_Product`
Source Type: `Table`
Source System: `DWH SQL Server`

|Table Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|dwh.Dim_Product|  ProductCode|  nvarchar(500) | True  ||
|dwh.Dim_Product|  ProductName|  nvarchar(500) | True  ||
|dwh.Dim_Product|  ServicesCode|  nvarchar(20) | True  ||
|dwh.Dim_Product|  ServicesDescription|  nvarchar(500) | True  ||
|dwh.Dim_Product|  CreatedDateTime|  datetime2(3)| True  ||
|dwh.Dim_Product|  ModifiedDateTime|  datetime2(3)| True  ||
|dwh.Dim_Product|  ValidationStatus|  nvarchar(50) | True  ||
|dwh.Dim_Product|  KDP_SK|  bigint IDENTITY(1,1)| False||
|dwh.Dim_Product|  KDP_checksum|  int | True  ||
|dwh.Dim_Product|  KDP_executionId|  int | True  ||
|dwh.Dim_Product|  KDP_loadDT|  datetime| True  ||

---

## Target Details
Target Name: `dbo.Products `
Target Type: `View`
Target System: `DWH SQL Server`

|View Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|dbo.Products |  Product Key |  bigint IDENTITY(1,1) | False  ||
|dbo.Products |  Product Code |  nvarchar(500) | True ||
|dbo.Products |  Product Name|  nvarchar(500) | True ||


---

## Field Mapping


| Source Table | Source Field  | Target Table  | Target Field  | Transformation Rules  | Data Type | Nullable  |
|--|--|--|--|--|--|--|
| dwh.Dim_Product| KDP_SK  |dbo.Products |  Product Key | None | bigint IDENTITY(1,1)  |  False|
| dwh.Dim_Product| ProductCode| dbo.Products |  Product Code | COALESCE(NULLIF(ProductCode, ''), 'N/A')| nvarchar(500) |  True|
| dwh.Dim_Product| ProductName| dbo.Products |  Product Name| COALESCE(NULLIF(ProductName, ''), 'N/A')| nvarchar(500) |  True|



---

## Transformation Rules
1. Product Code
`COALESCE(NULLIF(ProductCode, ''), 'N/A')`

2. Product Name
`COALESCE(NULLIF(ProductName, ''), 'N/A')`

---
### [Return to Dimension Tables](/Archive/Data-Lineage/Dimension-Tables)