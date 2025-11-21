---
# Stock Rotation Mapping
---

## Introduction

Stock Rotation is based on a SQL View in DWH called **dbo.Stock Rotation** which will be the _Target_ and it is derived from **dwh.Fact_Stock** which will be the _Source_  and it joins with:
- dwh.Sec_KeyCombinations;
- dwh.Dim_Date; 
- dwh.Fact_ExchangeRates; 
- dwh.Dim_Currency;
- dwh.Fact_Invoices


---

## Data Lineage

::: mermaid
 graph LR;
 A[dwh.Fact_Stock] --> B[dbo.Stock Rotation] -->  C[Stock ROtation];
D[dwh.Sec_KeyCombinations] -->  B;
E[dwh.Dim_Date] -->  B;
F[dwh.Fact_ExchangeRates] -->  B;
G[dwh.Dim_Currency] -->  B;
H[dwh.Fact_Invoices] -->  B;
:::

---

## Source Details
Source Name: `dwh.Fact_Stock` 
Source Type: `Table`
Source System: `DWH SQL Server`

|Table Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|dwh.Fact_Stock|  StockLineNumber |  nvarchar(255) | True||
|dwh.Fact_Stock|  FK_Company |  bigint | True||
|dwh.Fact_Stock|  FK_ClosingDate |  int | True||
|dwh.Fact_Stock|  FK_EntryDate |  int | True||
|dwh.Fact_Stock|  FK_BusinessType |  bigint | True||
|dwh.Fact_Stock|  FK_BusinessUnit |  bigint | True||
|dwh.Fact_Stock|  FK_Location |  bigint | True||
|dwh.Fact_Stock|  FK_Product |  bigint | True||
|dwh.Fact_Stock|  FK_ProductGrouping |  bigint | True||
|dwh.Fact_Stock|  FK_StockAgeGroup |  bigint | True||
|dwh.Fact_Stock|  FK_LocalProduct |  bigint | True||
|dwh.Fact_Stock|  FK_HomeCurrency |  bigint | True||
|dwh.Fact_Stock|  FK_UnitOfMeasure |  bigint | True||
|dwh.Fact_Stock|  WarehouseName |  nvarchar(255) | True||
|dwh.Fact_Stock|  IsCommitted |  nvarchar(30) | True||
|dwh.Fact_Stock|  IsInTransit |  nvarchar(30) | True||
|dwh.Fact_Stock|  StockRotationIndicator |  nvarchar(20) | True||
|dwh.Fact_Stock|  LotNumber |  nvarchar(255) | True||
|dwh.Fact_Stock|  Quantity |  decimal(18,2) | True||
|dwh.Fact_Stock|  QuantityInMetricTon |  decimal(18,2) | True||
|dwh.Fact_Stock|  DaysInStock |  int | True||
|dwh.Fact_Stock|  InventoryCostAmountHomeCurrency |  decimal(18,2) | True||
|dwh.Fact_Stock|  InventoryCostAmountGroupCurrency |  decimal(18,2) | True||
|dwh.Fact_Stock|  SlowInventoryCostAmountHomeCurrency |  decimal(18,2) | True||
|dwh.Fact_Stock|  SlowInventoryCostAmountGroupCurrency |  decimal(18,2) | True||
|dwh.Fact_Stock|  ProblematicInventoryCostAmountHomeCurrency |  decimal(18,2) | True||
|dwh.Fact_Stock|  ProblematicInventoryCostAmountGroupCurrency |  decimal(18,2) | True||

---

Source Name: `dwh.Sec_KeyCombinations`
Source Type: `Table`
Source System: `DWH SQL Server`


|Table Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|dwh.Sec_KeyCombinations|  KDP_SK|  bigint IDENTITY(1,1) | False||
|dwh.Sec_KeyCombinations|  FK_BusinessType|  bigint | False||
|dwh.Sec_KeyCombinations|  FK_BusinessUnit|  bigint | False||
|dwh.Sec_KeyCombinations|  FK_CustomerCountry|  bigint| False||
|dwh.Sec_KeyCombinations|  FK_Company|  bigint| False||

---
Source Name: `dwh.Dim_Date`
Source Type: `Table` 
Source System: `DWH SQL Server`

|Table Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|dwh.Dim_Date|  DateId|  char(30) | False||
|dwh.Dim_Date|  DateFull|  date| True  ||
|dwh.Dim_Date|  DayName|  varchar(9)| True  ||
|dwh.Dim_Date|  DayInWeek|  int | True  ||
|dwh.Dim_Date|  DayInMonth|  int | True  ||
|dwh.Dim_Date|  DayInYear|  int | True  ||
|dwh.Dim_Date|  WeekCode|  varchar(14)| True  ||
|dwh.Dim_Date|  WeekInYear|  int | True  ||
|dwh.Dim_Date|  FirstDayInWeek|  date| True  ||
|dwh.Dim_Date|  LastDayInWeek|  date| True  ||
|dwh.Dim_Date|  MonthCode|  varchar(14)| True  ||
|dwh.Dim_Date|  MonthName|  varchar(9)| True  ||
|dwh.Dim_Date|  MonthInYear|  int | True  ||
|dwh.Dim_Date|  FirstDayInMonth|  date| True  ||
|dwh.Dim_Date|  LastDayInMonth|  date| True  ||
|dwh.Dim_Date|  QuarterCode|  varchar(14)| True  ||
|dwh.Dim_Date|  QuarterFull|  varchar(15)| True  ||
|dwh.Dim_Date|  QuarterInYear|  int | True  ||
|dwh.Dim_Date|  FirstDayInQuarter|  date| True  ||
|dwh.Dim_Date|  LastDayInQuarter|  date| True  ||
|dwh.Dim_Date|  Year|  int | True  ||
|dwh.Dim_Date|  FirstDayInYear|  date| True  ||
|dwh.Dim_Date|  LastDayInYear|  date| True  ||
|dwh.Dim_Date|  KDP_SK|  char(30)| False||
|dwh.Dim_Date|  KDP_checksum|  int | True  ||
|dwh.Dim_Date|  KDP_executionId|  int | True  ||
|dwh.Dim_Date|  KDP_loadDT|  datetime | True  ||

---

Source Name: `dwh.Fact_ExchangeRates` 
Source Type: `Table`
Source System: `DWH SQL Server`

|Table Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|dwh.Fact_ExchangeRates|  uk_field |  nvarchar(34) | False||
|dwh.Fact_ExchangeRates|  FK_Currency |  bigint | False||
|dwh.Fact_ExchangeRates|  FK_ReferenceCurrency |  bigint | False||
|dwh.Fact_ExchangeRates|  FK_ClosingDate |  char(30) | False||
|dwh.Fact_ExchangeRates|  AverageRate |  decimal(28,12) | False||
|dwh.Fact_ExchangeRates|  AverageMonthRate |  decimal(28,12) | False||
|dwh.Fact_ExchangeRates|  ClosingRate |  decimal(28,12) | False||
|dwh.Fact_ExchangeRates|  AverageBudgetRate |  decimal(28,12) | False||
|dwh.Fact_ExchangeRates|  AverageMonthBudgetRate |  decimal(28,12) | False||
|dwh.Fact_ExchangeRates|  ClosingBudgetRate |  decimal(28,12) | False||
|dwh.Fact_ExchangeRates|  KDP_checksum |  int | False||
|dwh.Fact_ExchangeRates|  KDP_executionId |  int | False||
|dwh.Fact_ExchangeRates|  KDP_loadDT |  datetime | False||
---

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

Source Name: `dwh.Fact_Invoices`
Source Type: `Table`
Source System: `DWH SQL Server`

|Table Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|dwh.Fact_invoices|  InvoiceCode|  nvarchar(50) | True||
|dwh.Fact_invoices|  InvoiceLineNumber|  bigint | True  ||
|dwh.Fact_invoices|  FK_Company|  bigint | True  ||
|dwh.Fact_invoices|  FK_InvoiceDate|  int| True  ||
|dwh.Fact_invoices|  FK_ClosingDate|  int| True  ||
|dwh.Fact_invoices|  FK_BusinessUnit|  bigint | True  ||
|dwh.Fact_invoices|  FK_BusinessType|  bigint | True  ||
|dwh.Fact_invoices|  FK_Customer|  bigint | True  ||
|dwh.Fact_invoices|  FK_Industry|  bigint | True  ||
|dwh.Fact_invoices|  FK_InvoiceCurrency|  bigint | True  ||
|dwh.Fact_invoices|  FK_HomeCurrency|  bigint | True  ||
|dwh.Fact_invoices|  FK_DestinationCountry|  bigint | True  ||
|dwh.Fact_invoices|  FK_Product|  bigint | True  ||
|dwh.Fact_invoices|  FK_ProductGrouping|  bigint | True  ||
|dwh.Fact_invoices|  FK_LocalProduct|  bigint | True  ||
|dwh.Fact_invoices|  FK_UnitOfMeasure|  bigint | True  ||
|dwh.Fact_invoices|  FK_Invoice|  bigint | True  ||
|dwh.Fact_invoices|  Quantity|  decimal(38,5) | True  ||
|dwh.Fact_invoices|  QuantityInMetricTon|  decimal(38,5) | True  ||
|dwh.Fact_invoices|  IsNewFile|  bit | True  ||
|dwh.Fact_invoices|  Shares|  decimal(38,5) | True  ||
|dwh.Fact_invoices|  ExternalReference|  nvarchar(1000) | True  ||
|dwh.Fact_invoices|  SalesAmountInvoiceCurrency|  float | True  ||
|dwh.Fact_invoices|  SalesAmountHomeCurrency|  float | True  ||
|dwh.Fact_invoices|  SalesAmountGroupCurrency|  float | True  ||
|dwh.Fact_invoices|  CostOfGoodsSoldAmountInvoiceCurrency|  float | True  ||
|dwh.Fact_invoices|  CostOfGoodsSoldAmountHomeCurrency|  float | True  ||
|dwh.Fact_invoices|  CostOfGoodsSoldAmountGroupCurrency|  float | True  ||
|dwh.Fact_invoices|  ContributionAmountInvoiceCurrency|  float | True  ||
|dwh.Fact_invoices|  ContributionAmountHomeCurrency|  float | True  ||
|dwh.Fact_invoices|  ContributionAmountGroupCurrency|  float | True  ||
|dwh.Fact_invoices|  UnitPriceInvoiceCurrency|  float | True  ||
|dwh.Fact_invoices|  UnitPriceHomeCurrency|  float | True  ||
|dwh.Fact_invoices|  UnitPriceAmountGroupCurrency|  float | True  ||
|dwh.Fact_invoices|  ExternalTransportAmountInvoiceCurrency|  float | True  ||
|dwh.Fact_invoices|  ExternalTransportAmountHomeCurrency|  float | True  ||
|dwh.Fact_invoices|  ExternalTransportAmountGroupCurrency|  float | True  ||
|dwh.Fact_invoices|  InternalTransportAmountInvoiceCurrency|  float | True  ||
|dwh.Fact_invoices|  InternalTransportAmountHomeCurrency|  float | True  ||
|dwh.Fact_invoices|  InternalTransportAmountGroupCurrency|  float | True  ||
|dwh.Fact_invoices|  CostOfGoodsSold2AmountInvoiceCurrency|  float | True  ||
|dwh.Fact_invoices|  CostOfGoodsSold2AmountHomeCurrency|  float | True  ||
|dwh.Fact_invoices|  CostOfGoodsSold2AmountGroupCurrency|  float | True  ||
|dwh.Fact_invoices|  Contribution2AmountInvoiceCurrency|  float | True  ||
|dwh.Fact_invoices|  Contribution2AmountHomeCurrency|  float | True  ||
|dwh.Fact_invoices|  Contribution2AmountGroupCurrency|  float | True  ||


---

## Target Details
Target Name: `dbo.Stock Rotation`
Target Type: `View`
Target System: `DWH SQL Server`

|View Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|dbo.Stock Rotation|  Company Key |  bigint | True||
|dbo.Stock Rotation|  Date Closing Key |  int | True||
|dbo.Stock Rotation|  Business Type Key |  bigint | True||
|dbo.Stock Rotation|  Business Unit Key |  bigint | True||
|dbo.Stock Rotation|  Product Key |  bigint | True||
|dbo.Stock Rotation|  Product Groups Key |  bigint | True||
|dbo.Stock Rotation|  Product Local Key |  bigint | True||
|dbo.Stock Rotation|  M Home Currency Inventory Amount |  decimal(18,2) | True||
|dbo.Stock Rotation|  M Home Currency COGS Amount L3M|   | ||
|dbo.Stock Rotation|  M Days Stock Rotation|   | ||
|dbo.Stock Rotation|  Local Warehouse Name |  nvarchar(255) | True||
|dbo.Stock Rotation|  Committed |  nvarchar(30) | True||
|dbo.Stock Rotation|  In Transit |  nvarchar(30) | True||
|dbo.Stock Rotation| Security Key |   | ||
|dbo.Stock Rotation| KeyCombination Key |  bigint IDENTITY(1,1) | False||


---

## Field Mapping

| Source Table | Source Field  | Target Table  | Target Field  | Transformation Rules  | Data Type | Nullable  |
|--|--|--|--|--|--|--|
| dwh.Fact_Stock | FK_Company |dbo.Stock Rotation|  Company Key | None | bigint |  True|
| dwh.Fact_Stock | FK_ClosingDate |dbo.Stock Rotation|  Date Closing Key | None | int |  True||
| dwh.Fact_Stock | FK_BusinessType |dbo.Stock Rotation| Business Type Key | None | bigint |  True||
| dwh.Fact_Stock | FK_BusinessUnit |dbo.Stock Rotation| Business Unit Key | None | bigint |  True||
| dwh.Fact_Stock | FK_Product |dbo.Stock Rotation| Product Key | None | bigint |  True||
| dwh.Fact_Stock | FK_ProductGrouping |dbo.Stock Rotation| Product Groups Key | None | bigint |  True||
| dwh.Fact_Stock | FK_LocalProduct |dbo.Stock Rotation| Product Local Key | None | bigint |  True||
| dwh.Fact_Stock | InventoryCostAmountGroupCurrency |dbo.Stock Rotation| M Home Currency Inventory Amount | AVG(InventoryCostAmountGroupCurrency) | decimal(18,2) |  True||
| dwh.Fact_Invoices | CostOfGoodsSoldAmountGroupCurrency |dbo.Stock Rotation| M Home Currency COGS Amount L3M | SUM(CostOfGoodsSoldAmountGroupCurrency) |  |  ||
| dwh.Fact_Stock s, dwh.Fact_Invoices i | s.InventoryCostAmountGroupCurrency, i.CostOfGoodsSoldAmountGroupCurrency |dbo.Stock Rotation| M Days Stock Rotation | ,COALESCE(AVG(s.[InventoryCostAmountGroupCurrency])/NULLIF(SUM(i.[CostOfGoodsSoldAmountGroupCurrency]), 0), 0) * (365/4) | |  ||
| dwh.Fact_Stock | WarehouseName |dbo.Stock Rotation| Local Warehouse Name | None | nvarchar(255) |  True||
| dwh.Fact_Stock | IsCommitted |dbo.Stock Rotation| Committed | None | nvarchar(30) |  True||
| dwh.Fact_Stock | IsInTransit |dbo.Stock Rotation| In Transit | None | nvarchar(30) |  True||
| dwh.Fact_Stock | FK_BusinessType, FK_BusinessUnit, FK_Company |dbo.Stock Rotation| Security Key | CONCAT_WS('-', FK_BusinessType, FK_BusinessUnit, FK_Company, '') | nvarchar(30) |  True||
| dwh.Sec_KeyCombinations | KDP_SK |dbo.Stock Rotation| KeyCombination Key | None | bigint IDENTITY(1,1) |  False||


---

## Transformation Rules

### Column Specific Transformation
1. M Home Currency Inventory Amount
`AVG(s.[InventoryCostAmountGroupCurrency])`

2. M Home Currency COGS Amount L3M
`SUM(i.[CostOfGoodsSoldAmountGroupCurrency])`

3. M Days Stock Rotation
`COALESCE(AVG(s.[InventoryCostAmountGroupCurrency])/NULLIF(SUM(i.[CostOfGoodsSoldAmountGroupCurrency]), 0), 0) * (365/4)`

2. Security Key
`CONCAT_WS('-', FK_BusinessType, FK_BusinessUnit, FK_Company, '')`




### Joins 

1. dwh.Fact_Stock s
`FROM`
`(   	SELECT`
		`s.[FK_Company]
		,s.[FK_ClosingDate]
		,d.[DateFull] AS [ClosingDate]`
		`,s.[FK_BusinessType]
		,s.[FK_BusinessUnit]
		,s.[FK_Product]`
		`,s.[FK_ProductGrouping]
		,s.[FK_LocalProduct]
		,s.[FK_HomeCurrency]`
		`,s.[WarehouseName]
		,s.[IsCommitted]
		,s.[IsInTransit]`
		`,SUM(s.[InventoryCostAmountHomeCurrency]) * e.[ClosingRate] AS [InventoryCostAmountGroupCurrency]`
        `,KC.KDP_SK`
	`FROM [dwh].[Fact_Stock] s`
    `INNER JOIN	dwh.Sec_KeyCombinations	AS KC`
			    `ON  s.FK_BusinessType	= KC.FK_BusinessType`
			    `AND s.FK_Company		= KC.FK_Company`
			    `AND s.FK_BusinessUnit	= KC.FK_BusinessUnit`
			    `AND	KC.FK_CustomerCountry = -1`
	`INNER JOIN [dwh].[Dim_Date] d
		ON s.[FK_ClosingDate] = d.[KDP_SK]`
	`LEFT OUTER JOIN `
	`(
		SELECT
			e.[FK_Currency]`
			`,c.[CurrencyCode] AS [ReferenceCurrencyCode]
			,e.[FK_ClosingDate]
			,e.[ClosingRate]`
		`FROM [dwh].[Fact_ExchangeRates] e`
		`INNER JOIN [dwh].[Dim_Currency] c
			ON e.[FK_ReferenceCurrency] = c.[KDP_SK]`
	`) e`
		`ON s.[FK_HomeCurrency] = e.[FK_Currency]`
		`AND e.[ReferenceCurrencyCode] = 'USD'`
		`AND s.[FK_ClosingDate] =  e.[FK_ClosingDate]`
	`GROUP BY
		s.[FK_Company]
		,s.[FK_ClosingDate]
		,d.[DateFull]
		,s.[FK_BusinessType]
		,s.[FK_BusinessUnit]
		,s.[FK_Product]
		,s.[FK_ProductGrouping]
		,s.[FK_LocalProduct]
		,s.[FK_HomeCurrency]
		,s.[WarehouseName]
		,s.[IsCommitted]
		,s.[IsInTransit]
		,e.[ClosingRate]
        ,KC.KDP_SK`
`) s`

2. dwh.Fact_Invoices i
`LEFT OUTER JOIN`
`(
	SELECT
		i.[FK_Company]`
		,`i.[FK_ClosingDate]
		,d.[DateFull] AS [ClosingDate]
		,i.[FK_LocalProduct]`
		`,SUM(i.[CostOfGoodsSoldAmountHomeCurrency]) * e.[AverageMonthRate] AS [CostOfGoodsSoldAmountGroupCurrency]`
	`FROM [dwh].[Fact_Invoices] i`
	`INNER JOIN [dwh].[Dim_Date] d
		ON i.[FK_ClosingDate] = d.[KDP_SK]`
	`LEFT OUTER JOIN 
	(
		SELECT`
			`e.[FK_Currency]
			,c.[CurrencyCode] AS [ReferenceCurrencyCode]`
			`,e.[FK_ClosingDate]
			,e.[AverageMonthRate]`
		`FROM [dwh].[Fact_ExchangeRates] e`
		`INNER JOIN [dwh].[Dim_Currency] c
			ON e.[FK_ReferenceCurrency] = c.[KDP_SK]`
	`) e`
		`ON i.[FK_HomeCurrency] = e.[FK_Currency]`
		`AND e.[ReferenceCurrencyCode] = 'USD'`
		`AND i.[FK_ClosingDate] =  e.[FK_ClosingDate]`
	`GROUP BY
		i.[FK_Company]
		,i.[FK_ClosingDate]
		,d.[DateFull]
		,i.[FK_LocalProduct]
		,e.[AverageMonthRate]`
`) i`
	`ON s.[FK_Company] = i.[FK_Company]`
	`AND s.[FK_LocalProduct] = i.[FK_LocalProduct]`
	`AND s.[ClosingDate] BETWEEN i.[ClosingDate] AND DATEADD(MONTH, 2, i.[ClosingDate])`
`GROUP BY
	s.[FK_Company]
	,s.[FK_ClosingDate]
	,s.[FK_BusinessType]
	,s.[FK_BusinessUnit]
	,s.[FK_Product]
	,s.[FK_ProductGrouping]
	,s.[FK_LocalProduct]
	,s.[WarehouseName]
	,s.[IsCommitted]
	,s.[IsInTransit]
    ,s.KDP_SK
`

---
### [Return to Fact Tables](/Archive/Data-Lineage/Fact-Tables)/Fact-Tables)