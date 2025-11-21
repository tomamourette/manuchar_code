---
# Industry Mapping
---

## Introduction

Industry is based on a SQL View in DWH called **dbo.Industry** which will be the _Target_ and it is derived from **dwh.Dim_Industry** which will be the _Source_.

---

## Data Lineage

::: mermaid
 graph LR;
 A[dwh.Dim_Industry] --> B[dbo.Industry] -->  C[Industry];
:::
---

## Source Details
Source Name: `dwh.Dim_Industry`
Source Type: `Table`
Source System: `DWH SQL Server`

|Table Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|dwh.Dim_Industry|  IndustryCode|  nvarchar(20) | True  ||
|dwh.Dim_Industry|  IndustryDescription|  nvarchar(500) | True  ||
|dwh.Dim_Industry|  IndustryGroupDescription|  nvarchar(500) | True  ||
|dwh.Dim_Industry|  CreatedDateTime|  datetime2(3)| True  ||
|dwh.Dim_Industry|  ModifiedDateTime|  datetime2(3)| True  ||
|dwh.Dim_Industry|  ValidationStatus|  nvarchar(50) | True  ||
|dwh.Dim_Industry|  KDP_SK|  bigint IDENTITY(1,1)| False||
|dwh.Dim_Industry|  KDP_checksum|  int | True  ||
|dwh.Dim_Industry|  KDP_executionId|  int | True  ||
|dwh.Dim_Industry|  KDP_loadDT|  datetime| True  ||


---

## Target Details
Target Name: `dbo.Industry`
Target Type: `View`
Target System: `DWH SQL Server`

|View Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|dbo.Industry|  Industry Key |  bigint IDENTITY(1,1) | False  ||
|dbo.Industry|  Industry Code |  nvarchar(20) | True ||
|dbo.Industry|  Industry Name|  nvarchar(500) | True ||
|dbo.Industry|  Industry Group|  nvarchar(500) | True ||


---

## Field Mapping


| Source Table | Source Field  | Target Table  | Target Field  | Transformation Rules  | Data Type | Nullable  |
|--|--|--|--|--|--|--|
| dwh.Dim_Industry| KDP_SK  |dbo.Industry|  Industry Key | None | bigint IDENTITY(1,1)  |  False|
| dwh.Dim_Industry| IndustryCode| dbo.Industry|  Industry Code | None | nvarchar(20) |  True|
| dwh.Dim_Industry| IndustryDescription| dbo.Industry|  Industry Name| COALESCE(NULLIF(IndustryDescription, ''), 'N/A')| nvarchar(500) |  True|
| dwh.Dim_Industry| IndustryGroupDescription| dbo.Industry|  Industry Group| COALESCE(NULLIF(IndustryGroupDescription, ''), 'N/A')| nvarchar(500) |  True|

---

## Transformation Rules
1. Industry Name
`COALESCE(NULLIF(IndustryDescription, ''), 'N/A')`

2.  Industry Group
`COALESCE(NULLIF(IndustryGroupDescription, ''), 'N/A')`

---
### [Return to Dimension Tables](/Archive/Data-Lineage/Dimension-Tables)