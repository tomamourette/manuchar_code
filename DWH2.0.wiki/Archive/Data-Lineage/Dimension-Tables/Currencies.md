---
# Currencies Mapping
---

## Introduction

Currencies is based on a SQL View in DWH called **dbo.Currencies** which will be the _Target_ and it is derived from **dwh.Dim_Currencies** which will be the _Source_.

---

## Data Lineage

::: mermaid
 graph LR;
 A[dwh.Dim_Currency] --> B[dbo.Currencies] -->  C[Currencies];
:::
---

## Source Details
Source Name: `dwh.Dim_Currency`
Source Type: `Table`
Source System: `DWH SQL Server`

|Table Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|dwh.Dim_Currency|  CurrencyCode|  nvarchar(20) | True  ||
|dwh.Dim_Currency|  IsActive|  bit | True  ||
|dwh.Dim_Currency|  Currency|  nvarchar(500) | True  ||
|dwh.Dim_Currency|  KDP_SK|  bigint IDENTITY(1,1) | False||
|dwh.Dim_Currency|  KDP_checksum|  int | True  ||
|dwh.Dim_Currency|  KDP_executionId|  int | True  ||
|dwh.Dim_Currency|  KDP_loadDT|  datetime | True  ||

---

## Target Details
Target Name: `dbo.Currencies`
Target Type: `View`
Target System: `DWH SQL Server`

|View Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|dbo.Currencies|  Currency Key |  bigint IDENTITY(1,1) | False  ||
|dbo.Currencies|  Currency Code |  nvarchar(20) | True ||
|dbo.Currencies|  Currency Name|  nvarchar(500) | True  ||

---

## Field Mapping


| Source Table | Source Field  | Target Table  | Target Field  | Transformation Rules  | Data Type | Nullable  |
|--|--|--|--|--|--|--|
| dwh.Dim_Currency| KDP_SK  |dbo.Currencies|  Currency Key | None | bigint IDENTITY(1,1)  |  False|
| dwh.Dim_Currency| CurrencyCode| dbo.Currencies|  Currency Code | None | nvarchar(20) |  True|
| dwh.Dim_Currency| Currency| dbo.Currencies|  Currency Name | None | nvarchar(500) |  True|


---

## Transformation Rules

No transformations performed for this table. It is currently a one to one copy.

---
### [Return to Dimension Tables](/Archive/Data-Lineage/Dimension-Tables)