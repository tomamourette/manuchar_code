---
# Invoices Mapping
---

## Introduction

Invoices is based on a SQL View in DWH called **dbo.Invoices** which will be the _Target_ and it is derived from **dwh.Dim_Invoice** which will be the _Source_.

---

## Data Lineage

::: mermaid
 graph LR;
 A[dwh.Dim_Invoice ] --> B[dbo.Invoices ] -->  C[Invoices ];
:::
---

## Source Details
Source Name: `dwh.Dim_Invoice `
Source Type: `Table`
Source System: `DWH SQL Server`

|Table Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|dwh.Dim_Invoice |  InvoiceCode|  nvarchar(1000) | True  ||
|dwh.Dim_Invoice |  DueDate|  date | True  ||
|dwh.Dim_Invoice |  InvoiceDate|  date | True  ||
|dwh.Dim_Invoice |  PaymentTerm|  nvarchar(1000) | True  ||
|dwh.Dim_Invoice |  IsCADLC|  bit| True  ||
|dwh.Dim_Invoice |  IsDeclarable|  bit| True  ||
|dwh.Dim_Invoice |  LegalNumber|  nvarchar(1000) | True  ||
|dwh.Dim_Invoice |  FileNumber|  nvarchar(1000) | True  ||
|dwh.Dim_Invoice |  JuniorTrader|  nvarchar(50) | True  ||
|dwh.Dim_Invoice |  SeniorTrader|  nvarchar(50) | True  ||
|dwh.Dim_Invoice |  OrderNumber|  int| True  ||
|dwh.Dim_Invoice |  Team|  nvarchar(50) | True  ||
|dwh.Dim_Invoice |  ExternalReference|  nvarchar(500) | True  ||
|dwh.Dim_Invoice |  Responsible|  nvarchar(10) | True  ||
|dwh.Dim_Invoice |  Coordinator|  nvarchar(10) | True  ||
|dwh.Dim_Invoice |  KDP_SK|  bigint IDENTITY(1,1) | False||
|dwh.Dim_Invoice |  KDP_checksum|  int | True  ||
|dwh.Dim_Invoice |  KDP_executionId|  int | True  ||
|dwh.Dim_Invoice |  KDP_loadDT|  datetime | True  ||

---

## Target Details
Target Name: `dbo.Invoices`
Target Type: `View`
Target System: `DWH SQL Server`

|View Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|dbo.Invoices|  Invoice Key |  bigint IDENTITY(1,1) | False  ||
|dbo.Invoices| AR Invoice Number|  nvarchar(1000) | True ||
|dbo.Invoices| Invoice Number|  nvarchar(1000) | True ||
|dbo.Invoices| Date Due |  date | True ||
|dbo.Invoices| Date Invoice|  date | True ||
|dbo.Invoices| Payment Term|  nvarchar(1000) | True ||
|dbo.Invoices| Legal Number|  nvarchar(1000) | True ||
|dbo.Invoices| Flag CADLC|  |  ||
|dbo.Invoices| Flag Declarable|  |  ||
|dbo.Invoices| File Number|  nvarchar(1000) | True ||
|dbo.Invoices| Junior Trader|  nvarchar(50) | True ||
|dbo.Invoices| Senior Trader|  nvarchar(50) | True ||
|dbo.Invoices| Order Number|  int | True ||
|dbo.Invoices| Team |  nvarchar(50) | True ||
|dbo.Invoices| External Reference|  nvarchar(500) | True ||

---

## Field Mapping


| Source Table | Source Field  | Target Table  | Target Field  | Transformation Rules  | Data Type | Nullable  |
|--|--|--|--|--|--|--|
| dwh.Dim_Invoice | KDP_SK  |dbo.Invoices|  Invoice Key | None | bigint IDENTITY(1,1)  |  False|
| dwh.Dim_Invoice | InvoiceCode | dbo.Invoices|  AR Invoice Number | None | nvarchar(1000) |  True|
| dwh.Dim_Invoice | InvoiceCode | dbo.Invoices|  Invoice Number | None | nvarchar(1000) |  True|
| dwh.Dim_Invoice | DueDate| dbo.Invoices|  Date Due| None | date |  True|
| dwh.Dim_Invoice | InvoiceDate| dbo.Invoices|  Date Invoice| None | date |  True|
| dwh.Dim_Invoice | PaymentTerm| dbo.Invoices|  Payment Term | None | nvarchar(1000) |  True|
| dwh.Dim_Invoice | LegalNumber| dbo.Invoices|  Legal Number| ISNULL(LegalNumber, 'N/A')| nvarchar(1000) |  True|
| dwh.Dim_Invoice | IsCADLC| dbo.Invoices|  Flag CADLC| WHEN [IsCADLC] = 1 THEN 'Yes', ELSE 'No'|  | |
| dwh.Dim_Invoice | IsDeclarable| dbo.Invoices|  Flag Declarable| WHEN [IsDeclarable] = 1 THEN 'Yes', ELSE 'No'|  | |
| dwh.Dim_Invoice | FileNumber| dbo.Invoices|  File Number| ISNULL(FileNumber, 'N/A')| nvarchar(1000) |  True|
| dwh.Dim_Invoice | JuniorTrader| dbo.Invoices|  Junior Trader| ISNULL(JuniorTrader, 'N/A')| nvarchar(50) |  True|
| dwh.Dim_Invoice | SeniorTrader| dbo.Invoices|  Senior Trader| ISNULL(SeniorTrader, 'N/A')| nvarchar(50) |  True|
| dwh.Dim_Invoice | OrderNumber| dbo.Invoices|  Order Number| ISNULL(LTRIM(OrderNumber), 'N/A')| int|  True|
| dwh.Dim_Invoice | Team| dbo.Invoices|  Team| ISNULL(Team, 'N/A')| nvarchar(50) |  True|
| dwh.Dim_Invoice | ExternalReference| dbo.Invoices|  External Reference| ISNULL(ExternalReference, 'N/A')| nvarchar(500) |  True|


---

## Transformation Rules
1. Legal Number
`ISNULL(LegalNumber, 'N/A')`

2. Flag CADLC
`WHEN [IsCADLC] = 1 `
`THEN 'Yes' `
`ELSE 'No'`

3. Flag Declarable
`WHEN [IsDeclarable] = 1 `
`THEN 'Yes' `
`ELSE 'No'`

4. File Number
`ISNULL(FileNumber, 'N/A')`

5. Junior Trader
`ISNULL(JuniorTrader, 'N/A')`

6. Senior Trader
`ISNULL(SeniorTrader, 'N/A')`

7. Order Number
`ISNULL(LTRIM(OrderNumber), 'N/A')`


8. Team
`ISNULL(Team, 'N/A')`

6. External Reference
`ISNULL(ExternalReference, 'N/A')`

---
### [Return to Dimension Tables](/Archive/Data-Lineage/Dimension-Tables)