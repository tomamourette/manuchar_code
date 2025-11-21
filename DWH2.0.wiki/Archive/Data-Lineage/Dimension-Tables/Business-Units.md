---
# Business Units Mapping
---

## Introduction

Business Units is based on a SQL View in DWH called **dbo.Business Units** which will be the _Target_ and it is derived from **dwh.Dim_BusinessUnits** which will be the _Source_.

---

## Data Lineage

::: mermaid
 graph LR;
 A[dwh.Dim_BusinessUnits] --> B[dbo.Business Units] -->  C[Business Units];
:::
---

## Source Details
Source Name: `dwh.Dim_BusinessUnits`
Source Type: `Table`
Source System: `DWH SQL Server`


|Table Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|dwh.Dim_BusinessUnit  |  BusinessUnitCode|  nvarchar(20) | True  ||
|dwh.Dim_BusinessUnit  |  BusinessUnitDescription|  nvarchar(500) | True  ||
|dwh.Dim_BusinessUnit  |  CreatedDateTime|  datetime2(3) | True  ||
|dwh.Dim_BusinessUnit  |  ModifiedDateTime|  datetime2(3) | True  ||
|dwh.Dim_BusinessUnit  |  ValidationStatus|  nvarchar(50) | True  ||
|dwh.Dim_BusinessUnit  |  KDP_SK|  bigint IDENTITY(1,1) | False||
|dwh.Dim_BusinessUnit  |  KDP_checksum|  int | True  ||
|dwh.Dim_BusinessUnit  |  KDP_executionId|  int | True  ||
|dwh.Dim_BusinessUnit  |  KDP_loadDT|  datetime | True  ||

---

## Target Details
Target Name: `dbo.Business Units`
Target Type: `View`
Target System: `DWH SQL Server`


|View Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|dbo.Business Units |  Business Unit Key |  bigint IDENTITY(1,1) | False  ||
|dbo.Business Units |  Business Unit Description |  nvarchar(500) | True ||



---

## Field Mapping


| Source Table | Source Field  | Target Table  | Target Field  | Transformation Rules  | Data Type | Nullable  |
|--|--|--|--|--|--|--|
| dwh.Dim_BusinessUnit |KDP_SK  |dbo.Business Units  |  Business Unit Key | None | bigint IDENTITY(1,1)  |  False|
| dwh.Dim_BusinessUnit | BusinessUnitDescription  |dbo.Business Units  |  Business Unit Description | None | nvarchar(500) |  True|

---

## Transformation Rules

1. Filter dwh.Dim_BusinessUnit 
`WHERE BusinessUnitCode != '12'`


---
### [Return to Dimension Tables](/Archive/Data-Lineage/Dimension-Tables)