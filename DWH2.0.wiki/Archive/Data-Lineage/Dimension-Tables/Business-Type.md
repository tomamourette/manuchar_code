---
# Business Type Mapping
---

## Introduction

Business Type is based on a SQL View in DWH called **dbo.Business Types** which will be the _Target_ and it is derived from **dwh.Dim_BusinessType** which will be the _Source_.

---

## Data Lineage

::: mermaid
 graph LR;
 A[dwh.Dim_BusinessType] --> B[dbo.Business Types] -->  C[Business Type];
:::
---

## Source Details
Source Name: `dwh.Dim_BusinessType`
Source Type: `Table`
Source System: `DWH SQL Server`


|Table Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|dwh.Dim_BusinessType|  BusinessTypeCode|  nvarchar(20) | True  ||
|dwh.Dim_BusinessType|  BusinessTypeDescription|  nvarchar(500) | True  ||
|dwh.Dim_BusinessType|  CreatedDateTime|  datetime2(3) | True  ||
|dwh.Dim_BusinessType|  ModifiedDateTime|  datetime2(3) | True  ||
|dwh.Dim_BusinessType|  ValidationStatus|  nvarchar(50) | True  ||
|dwh.Dim_BusinessType|  KDP_SK|  bigint IDENTITY(1,1) | False||
|dwh.Dim_BusinessType|  KDP_checksum|  int | True  ||
|dwh.Dim_BusinessType|  KDP_executionId|  int | True  ||
|dwh.Dim_BusinessType|  KDP_loadDT|  datetime | True  ||

---

## Target Details
Target Name: `dbo.Business Types`
Target Type: `View`
Target System: `DWH SQL Server`


|View Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|dbo.Business Types|  Business Type Key |  bigint IDENTITY(1,1) | False  ||
|dbo.Business Types|  Business Type  Description |  nvarchar(500) | True ||


---

## Field Mapping


| Source Table | Source Field  | Target Table  | Target Field  | Transformation Rules  | Data Type | Nullable  |
|--|--|--|--|--|--|--|
| dwh.Dim_BusinessType| KDP_SK  |dbo.Business Types|  Business Type Key | None | bigint IDENTITY(1,1)  |  False|
| dwh.Dim_BusinessType| BusinessTypeCode/BusinessTypeDescription | dbo.Business Types|  Business Type Description | WHEN BusinessTypeCode = 2 THEN 'DIS/DOS', ELSE BusinessTypeDescription | nvarchar(500) |  True|

---

## Transformation Rules

1. Filter dwh.Dim_BusinessType
`WHERE BusinessTypeCode!= '5'`

2. Business Type Description
`CASE
		WHEN BusinessTypeCode = 2
		THEN 'DIS/DOS'
		ELSE BusinessTypeDescription
	END AS Business Type Description`


---
### [Return to Dimension Tables](/Archive/Data-Lineage/Dimension-Tables)