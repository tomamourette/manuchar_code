---
# Companies Mapping
---

## Introduction

Companies is based on a SQL View in DWH called **dbo.Companies** which will be the _Target_ and it is derived from **dwh.Dim_Company** which will be the _Source_.

---

## Data Lineage

::: mermaid
 graph LR;
 A[dwh.Dim_Company] --> B[dbo.Companies] -->  C[Companies];
:::
---

## Source Details
Source Name: `dwh.Dim_Company`
Source Type: `Table`
Source System: `DWH SQL Server`


|Table Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|dwh.Dim_Company|  CompanyID|  int | False ||
|dwh.Dim_Company|  CompanyCode|  nvarchar(20) | True  ||
|dwh.Dim_Company|  CompanyName|  nvarchar(500) | True  ||
|dwh.Dim_Company|  ConsolidationMethod|  nvarchar(1) | True  ||
|dwh.Dim_Company|  CurrencyCode|  nvarchar(20) | True  ||
|dwh.Dim_Company|  IsConsolidatedCompany|  bit | False ||
|dwh.Dim_Company|  LegalNumber|  nvarchar(50) | True  ||
|dwh.Dim_Company|  BusinessType|  nvarchar(50)| True  ||
|dwh.Dim_Company|  CountryCode|  nvarchar(20) | True  ||
|dwh.Dim_Company|  CountryName|  nvarchar(250) | True  ||
|dwh.Dim_Company|  CountryISOAlphaCode|  nvarchar(3)| True  ||
|dwh.Dim_Company|  CountryISONumericCode|  nvarchar(3) | True  ||
|dwh.Dim_Company|  CommercialRegion|  nvarchar(50)| True  ||
|dwh.Dim_Company|  HomeCurrency|  nvarchar(20) | True  ||
|dwh.Dim_Company|  IsActive|  bit | True  ||
|dwh.Dim_Company|  Controller |  nvarchar(500)| True  ||
|dwh.Dim_Company|  Whitelist|  nvarchar(500) | True  ||
|dwh.Dim_Company|  TrustDataFlag|  nvarchar(250)| True  ||
|dwh.Dim_Company|  ConnectionTypeCode|  nvarchar(250) | True  ||
|dwh.Dim_Company|  ConnectionTypeDescription|  nvarchar(250)| True  ||
|dwh.Dim_Company|  DebtorReportingFlag|  bit | True  ||
|dwh.Dim_Company|  SalesReportingFlag|  bit | True  ||
|dwh.Dim_Company|  StockReportingFlag|  bit| True  ||
|dwh.Dim_Company|  PayablesReportingFlag |  bit | True  ||
|dwh.Dim_Company|  ConsolidationPointOfView|  nvarchar(100)| True  ||
|dwh.Dim_Company|  ConsolidationPointOfViewOrder|  decimal(38,0) | True  ||
|dwh.Dim_Company|  ConsolidationSegment|  nvarchar(100)| True  ||
|dwh.Dim_Company|  ConsolidationSegmentOrder|  decimal(38,0) | True  ||
|dwh.Dim_Company|  KDP_SK|  bigint IDENTITY(1,1)| False||
|dwh.Dim_Company|  KDP_checksum|  int | True  ||
|dwh.Dim_Company|  KDP_executionId|  int| True  ||
|dwh.Dim_Company|  KDP_loadDT|  datetime| True  ||
|dwh.Dim_Company|  ConsolidationSegmentGroup|  nvarchar(100)| True  ||

---

## Target Details
Target Name: `dbo.Companies`
Target Type: `View`
Target System: `DWH SQL Server`


|View Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|dbo.Companies |  Company Key |  bigint IDENTITY(1,1) | False  ||
|dbo.Companies |  Company Code|  nvarchar(20) | True  ||
|dbo.Companies |  Company Name|  nvarchar(500) | True  ||
|dbo.Companies |  Company Currency|  nvarchar(20) | True  ||
|dbo.Companies |  Company Legal Number |  nvarchar(50) | True  ||
|dbo.Companies |  Company Business Type|  nvarchar(50)| True  ||
|dbo.Companies | Company Commercial Region|  nvarchar(50)| True  ||
|dbo.Companies |  Company Country |  nvarchar(250) | True  ||
|dbo.Companies |  Company Country Manager|  | ||
|dbo.Companies | Company HR Contact|  | ||
|dbo.Companies |  Company IT Contact |   | ||
|dbo.Companies |  Company Active Flag|  | ||
|dbo.Companies |Company Debtor Reporting Flag|  | ||
|dbo.Companies |  Company Sales Reporting Flag |   | ||
|dbo.Companies |Company Stock Reporting Flag|  | ||
|dbo.Companies |  Company Payables Reporting Flag |   | ||
|dbo.Companies |  Company Consolidation Segment |  nvarchar(100) |True||
|dbo.Companies |  Company Consolidation Segment Group |  nvarchar(100) |True||
|dbo.Companies |  Company Consolidation Point Of View |  nvarchar(100)| True  ||
|dbo.Companies |  Company Consolidation Method|  nvarchar(1) | True  ||
|dbo.Companies |  Company Segment Sort Order |   | ||
|dbo.Companies | Company Consolidation Point Of View Sort Order |   | ||

---

## Field Mapping


| Source Table | Source Field  | Target Table  | Target Field  | Transformation Rules  | Data Type | Nullable  |
|--|--|--|--|--|--|--|
| dwh.Dim_Company| KDP_SK  |dbo.Companies |  Company Key | None | bigint IDENTITY(1,1)  |  False|
| dwh.Dim_Company| CompanyCode | dbo.Companies |  Company Code| None | nvarchar(20) |  True|
| dwh.Dim_Company| CompanyName| dbo.Companies |  Company Name| None | nvarchar(20) |  True|
| dwh.Dim_Company| HomeCurrency| dbo.Companies |  Company Currency| COALESCE(HomeCurrency, '')| nvarchar(20) |  True|
| dwh.Dim_Company| LegalNumber| dbo.Companies |  Company Legal Number| COALESCE(LegalNumber, '')| nvarchar(50) |  True|
| dwh.Dim_Company| BusinessType| dbo.Companies |  Company Business Type| COALESCE(BusinessType, '')| nvarchar(50) |  True|
| dwh.Dim_Company| CommercialRegion | dbo.Companies |  Company Commercial Region| None| nvarchar(50) |  True|
| dwh.Dim_Company| CountryName| dbo.Companies |  Company Country| None| nvarchar(250) |  True|
| | | dbo.Companies |  Company Country Manager| Added as new column with Null value|  |  |
| | | dbo.Companies |  Company HR Contact|Added as new column with Null value|  |  |
| | | dbo.Companies |  Company IT Contact|Added as new column with Null value|  |  |
| dwh.Dim_Company| IsActive| dbo.Companies |  Company Active Flag | WHEN IsActive = 1 THEN 'ACTIVE', ELSE 'NOT ACTIVE'|  |  |
| dwh.Dim_Company| DebtorReportingFlag| dbo.Companies |  Company Debtor Reporting Flag | WHEN DebtorReportingFlag= 1 THEN 'YES', ELSE 'NO'|  |  |
| dwh.Dim_Company| SalesReportingFlag| dbo.Companies |  Company Sales Reporting Flag | WHEN SalesReportingFlag = 1 THEN 'YES', ELSE 'NO'|  |  |
| dwh.Dim_Company| StockReportingFlag| dbo.Companies |  Company Stock Reporting Flag | WHEN StockReportingFlag= 1 THEN 'YES', ELSE 'NO'|  |  |
| dwh.Dim_Company| PayablesReportingFlag| dbo.Companies |  Company Payables Reporting Flag | WHEN PayablesReportingFlag= 1 THEN 'YES', ELSE 'NO'|  |  |
| dwh.Dim_Company| ConsolidationSegment| dbo.Companies |  Company Consolidation Segment | NULLIF(ConsolidationSegment, '') nvarchar(100) ||True|    
| dwh.Dim_Company| ConsolidationSegmentGroup| dbo.Companies |  Company Consolidation Segment Group| NULLIF(ConsolidationSegmentGroup, '') nvarchar(100) ||True|  
| dwh.Dim_Company| ConsolidationPointOfView | dbo.Companies |  Company Consolidation Point Of View | None| nvarchar(100) |  True|
| dwh.Dim_Company| ConsolidationMethod| dbo.Companies |  Company Consolidation Method | None| nvarchar(1) |  True|
| dwh.Dim_Company| ConsolidationSegment | dbo.Companies |  Company Segment Sort Order | WHEN ConsolidationSegment IN 'Cost & Freight','Others','Steel','Polymers') THEN 1, WHEN ConsolidationSegment = 'Local Distribution' THEN 2, ELSE 3|  |  |
| dwh.Dim_Company| ConsolidationPointOfView| dbo.Companies |  Company Consolidation Point Of View Sort Order | WHEN 'Africa' THEN 22, WHEN 'Asia' THEN 23, WHEN 'Caribs' THEN 25, WHEN 'Central America' THEN 24, WHEN 'Central Asia' THEN 28, WHEN 'China' THEN 13, WHEN 'Europe' THEN 11, WHEN 'Hong Kong' THEN 12, WHEN 'Middle East' THEN 26, WHEN 'North America (Dos/Dis/Log)' THEN 27, WHEN 'North America (Trading)' THEN 14, WHEN 'Production' THEN 31, WHEN 'South America' THEN 21, ELSE 99 |  |  |

---

## Transformation Rules

1. Company Currency
`COALESCE(HomeCurrency, '')`

2. Company Legal Number
`COALESCE(LegalNumber, '')`

3. Company Business Type
`COALESCE(LegalNumber, '')`

4. Company Country Manager
`'' AS Company Country Manager`

5. Company  HR Contact
`'' AS Company  HR Contact`

6. Company  IT Contact
`'' AS Company  IT Contact`

7. Company Active Flag
`WHEN IsActive = 1`
		`THEN 'ACTIVE'`
		`ELSE 'NOT ACTIVE'`

8. Company Debtor Reporting Flag
		`WHEN DebtorReportingFlag = 1`
		`THEN 'YES'`
		`ELSE 'NO'`
9. Company Sales Reporting Flag
`WHEN SalesReportingFlag = 1`
		`THEN 'YES'`
		`ELSE 'NO'`

10. Company Stock Reporting Flag 
`WHEN StockReportingFlag = 1`
		`THEN 'YES'`
		`ELSE 'NO'`

11. Company Payables Reporting Flag
		`WHEN PayablesReportingFlag = 1`
		`THEN 'YES'`
		`ELSE 'NO'`

12. Company Consolidation Segment
	`NULLIF(ConsolidationSegment, '')`

13. Company Consolidation Segment Group
      `NULLIF(ConsolidationSegmentGroup, '')`


14.  Company Segment Sort Order     
		`WHEN ConsolidationSegment IN ('Cost & Freight','Others','Steel','Polymers')`
		`THEN 1 `

		`WHEN ConsolidationSegment = 'Local Distribution'`
		`THEN 2`

		`ELSE 3`

15. Company Consolidation Point Of View Sort Order
`CASE ConsolidationPointOfView`

		`WHEN 'Africa'`
		`THEN 22`

		`WHEN 'Asia'`
		`THEN 23`

		`WHEN 'Caribs'`
		`THEN 25`

		`WHEN 'Central America'`
		`THEN 24`

		`WHEN 'Central Asia'`
		THEN 28

		WHEN 'China'
		THEN 13

		WHEN 'Europe'
		THEN 11

		WHEN 'Hong Kong'
		THEN 12

		WHEN 'Middle East'
		THEN 26

		WHEN 'North America (Dos/Dis/Log)'
		THEN 27

		WHEN 'North America (Trading)'
		THEN 14

		WHEN 'Production'
		THEN 31

		WHEN 'South America'
		THEN 21

		ELSE 99


---
### [Return to Dimension Tables](/Archive/Data-Lineage/Dimension-Tables)