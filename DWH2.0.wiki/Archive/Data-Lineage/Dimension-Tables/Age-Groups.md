---
# Age Groups Mapping
---

## Introduction

Age Groups is based on a SQL View in DWH called **dbo.Age Groups** which in this case will be our _Target_ and it is derived from **dwh.Dim_AgeGroup** which will be the _Source_.

---

## Data Lineage

::: mermaid
 graph LR;
 A[dwh.Dim_AgeGroup] --> B[dbo.Age Groups] -->  C[Age Groups];
:::
---

## Source Details
Source Name: `dwh.Dim_AgeGroup`
Source Type: `Table`
Source System: `DWH SQL Server`


|Table Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|dwh.Dim_AgeGroup  |  AgeGroupCode|  nvarchar(20) | True  ||
|dwh.Dim_AgeGroup  |  AgeGroupName|  nvarchar(500) | True  ||
|dwh.Dim_AgeGroup  |  AgeGroupDescription|  nvarchar(500) | True  ||
|dwh.Dim_AgeGroup  |  AgeGroupPosition|  int | True  ||
|dwh.Dim_AgeGroup  |  MinimumDays|  int | True  ||
|dwh.Dim_AgeGroup  |  MaximumDays|  int | True  ||
|dwh.Dim_AgeGroup  |  CreatedDateTime|  datetime2(3) | True  ||
|dwh.Dim_AgeGroup  |  ModifiedDateTime|  datetime2(3) | True  ||
|dwh.Dim_AgeGroup  |  ValidationStatus|  nvarchar(50) | True  ||
|dwh.Dim_AgeGroup  |  KDP_SK|  bigint IDENTITY(1,1)| False||
|dwh.Dim_AgeGroup  |  KDP_checksum|  int | True  ||
|dwh.Dim_AgeGroup  |  KDP_executionId|  int | True  ||
|dwh.Dim_AgeGroup  |  KDP_loadDT|  datetime | True  ||

---

## Target Details
Target Name: `dbo.Age Groups`
Target Type: `View`
Target System: `DWH SQL Server`


|View Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|dbo.Age Groups |  Age Group Key |  bigint IDENTITY(1,1) | False  ||
|dbo.Age Groups |  Age Group Min Days |  int | True ||
|dbo.Age Groups |  Age Group Max Days |  int | True ||
|dbo.Age Groups |  Age Group Position |  int | True ||
|dbo.Age Groups |  Age Group Description |  nvarchar(500) | True ||

---

## Field Mapping


| Source Table | Source Field  | Target Table  | Target Field  | Transformation Rules  | Data Type | Nullable  |
|--|--|--|--|--|--|--|
| dwh.Dim_AgeGroup |KDP_SK  |dbo.Age Groups  |  Age Group Key | None | bigint IDENTITY(1,1)  |  False|
| dwh.Dim_AgeGroup |MinimumDays  |dbo.Age Groups  |  Age Group Min Days | None | int |  True|
| dwh.Dim_AgeGroup |MaximumDays  |dbo.Age Groups  |  Age Group Max Days | None |  int |  True|
| dwh.Dim_AgeGroup |AgeGroupPosition  |dbo.Age Groups  |  Age Group Position | None |int  |  True|
| dwh.Dim_AgeGroup |AgeGroupDescription  |dbo.Age Groups  |  Age Group Description | None |nvarchar(500)  |  True|

---

## Transformation Rules

For this table, it is currently set as one to one copy. No transformations needed.


---
### [Return to Dimension Tables](/Archive/Data-Lineage/Dimension-Tables)