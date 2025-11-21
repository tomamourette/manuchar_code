---
# Stock Mapping
---

## Introduction

Stock is based on a SQL View in DWH called **dbo.Stock ** which will be the _Target_ and it is derived from **dwh.Fact_Stock** which will be the _Source_  and it joins with:
- dwh.Sec_KeyCombinations;
- dwh.Dim_Date; and 
- dwh.Dim_Currency;


---

## Data Lineage

::: mermaid
 graph LR;
 A[dwh.Fact_Stock] --> B[dbo.Stock] -->  C[Stock];
D[dwh.Sec_KeyCombinations] -->  B;
E[dwh.Dim_Date] -->  B;
F[dwh.Dim_Currency] -->  B;
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
Target Name: `dbo.Stock`
Target Type: `View`
Target System: `DWH SQL Server`

|View Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|dbo.Stock|  Stock Key |  nvarchar(255) | True||
|dbo.Stock|  Company Key |  bigint | True||
|dbo.Stock|  Date Closing Key |  int | True||
|dbo.Stock|  Entry Date |  date | True||
|dbo.Stock|  Business Type Key |  bigint | True||
|dbo.Stock|  Business Unit Key |  bigint | True||
|dbo.Stock|  Location Key |  bigint | True||
|dbo.Stock|  Product Key |  bigint | True||
|dbo.Stock|  Product Groups Key |  bigint | True||
|dbo.Stock|  Stock Agegroup Key |  bigint | True||
|dbo.Stock|  Product Local Key |  bigint | True||
|dbo.Stock|  Stock Currency Key |  bigint | True||
|dbo.Stock|  UOM Key |  bigint | True||
|dbo.Stock|  Local Warehouse Name |  nvarchar(255) | True||
|dbo.Stock|  Committed |  nvarchar(30) | True||
|dbo.Stock|  In Transit |  nvarchar(30) | True||
|dbo.Stock|  LotNumber |  nvarchar(255) | True||
|dbo.Stock|  M Quantity |  decimal(18,2) | True||
|dbo.Stock|  M Volume in MT |  decimal(18,2) | True||
|dbo.Stock|  M Days In Stock |  int | True||
|dbo.Stock|  M Inventory Amount Home Currency |  decimal(18,2) | True||
|dbo.Stock|  M Inventory Amount Group Currency |  decimal(18,2) | True||
|dbo.Stock|  M Inventory Amount Home Currency Slow Stock |  decimal(18,2) | True||
|dbo.Stock|  M Inventory Amount Group Currency Slow Stock |  decimal(18,2) | True||
|dbo.Stock|  M Inventory Amount Home Currency Problematic Stock |  decimal(18,2) | True||
|dbo.Stock| M Inventory Amount Group Currency Problematic Stock |  decimal(18,2) | True||
|dbo.Stock| Security Key |   | ||
|dbo.Stock|  Home Currency |  nvarchar(20) | True||
|dbo.Stock| KeyCombination Key |  bigint IDENTITY(1,1) | False||

---

## Field Mapping

| Source Table | Source Field  | Target Table  | Target Field  | Transformation Rules  | Data Type | Nullable  |
|--|--|--|--|--|--|--|
| dwh.Fact_Stock | LotNumber |dbo.Stock|  Stock Key | ROW_NUMBER() OVER(ORDER BY LotNumber) | nvarchar(255) |  True|
| dwh.Fact_Stock | FK_Company |dbo.Stock|  Company Key | None | bigint |  True|
| dwh.Fact_Stock | FK_ClosingDate |dbo.Stock|  Date Closing Key | None | int |  True||
| dwh.Dim_Date | DateFull |dbo.Stock| Entry Date | None | date |  True|
| dwh.Fact_Stock | FK_BusinessType |dbo.Stock| Business Type Key | None | bigint |  True||
| dwh.Fact_Stock | FK_BusinessUnit |dbo.Stock| Business Unit Key | None | bigint |  True||
| dwh.Fact_Stock | FK_Location |dbo.Stock| Location Key | None | bigint |  True||
| dwh.Fact_Stock | FK_Product |dbo.Stock| Product Key | None | bigint |  True||
| dwh.Fact_Stock | FK_ProductGrouping |dbo.Stock| Product Groups Key | None | bigint |  True||
| dwh.Fact_Stock | FK_StockAgeGroup |dbo.Stock| Stock Agegroup Key | None | bigint |  True||
| dwh.Fact_Stock | FK_LocalProduct |dbo.Stock| Product Local Key | None | bigint |  True||
| dwh.Fact_Stock | FK_HomeCurrency |dbo.Stock| Stock Currency Key | None | bigint |  True||
| dwh.Fact_Stock | FK_UnitOfMeasure |dbo.Stock| UOM Key | None | bigint |  True||
| dwh.Fact_Stock | WarehouseName |dbo.Stock| Local Warehouse Name | None | nvarchar(255) |  True||
| dwh.Fact_Stock | IsCommitted |dbo.Stock| Committed | None | nvarchar(30) |  True||
| dwh.Fact_Stock | IsInTransit |dbo.Stock| In Transit | None | nvarchar(30) |  True||
| dwh.Fact_Stock | LotNumber |dbo.Stock| LotNumber | None | nvarchar(255) |  True||
| dwh.Fact_Stock | Quantity |dbo.Stock| M Quantity | None | decimal(18,2) |  True||
| dwh.Fact_Stock | QuantityInMetricTon |dbo.Stock| M Volume in MT | None | decimal(18,2) |  True||
| dwh.Fact_Stock | DaysInStock |dbo.Stock| M Days In Stock | None | int|  True||
| dwh.Fact_Stock | InventoryCostAmountHomeCurrency |dbo.Stock| M Inventory Amount Home Currency | None | decimal(18,2) |  True||
| dwh.Fact_Stock | InventoryCostAmountGroupCurrency |dbo.Stock| M Inventory Amount Group Currency | None | decimal(18,2) |  True||
| dwh.Fact_Stock | SlowInventoryCostAmountHomeCurrency |dbo.Stock| M Inventory Amount Home Currency Slow Stock | None | decimal(18,2) |  True||
| dwh.Fact_Stock | SlowInventoryCostAmountGroupCurrency |dbo.Stock| M Inventory Amount Group Currency Slow Stock | None | decimal(18,2) |  True||
| dwh.Fact_Stock | ProblematicInventoryCostAmountHomeCurrency |dbo.Stock| M Inventory Amount Home Currency Problematic Stock | None | decimal(18,2) |  True||
| dwh.Fact_Stock | ProblematicInventoryCostAmountGroupCurrency |dbo.Stock| M Inventory Amount Group Currency Problematic Stock | None | decimal(18,2) |  True||
| dwh.Fact_Stock | FK_BusinessType, FK_BusinessUnit, FK_Company |dbo.Stock| Security Key | CONCAT_WS('-', FK_BusinessType, FK_BusinessUnit, FK_Company, '') | nvarchar(30) |  True||
| dwh.Dim_Currency | CurrencyCode |dbo.Stock| Home Currency | None | nvarchar(20) |  True||
| dwh.Sec_KeyCombinations | KDP_SK |dbo.Stock| KeyCombination Key | None | bigint IDENTITY(1,1) |  False||


---

## Transformation Rules

### Column Specific Transformation
1. Stock Key
`ROW_NUMBER() OVER(ORDER BY LotNumber)`

2. Security Key
`CONCAT_WS('-', FK_BusinessType, FK_BusinessUnit, FK_Company, '')`


### Joins `dwh.Fact_Stock s`
1. dwh.Sec_KeyCombinations KC
`INNER JOIN	dwh.Sec_KeyCombinations	AS KC`
			`ON  s.FK_BusinessType	= KC.FK_BusinessType`
			`AND s.FK_Company		= KC.FK_Company`
			`AND s.FK_BusinessUnit	= KC.FK_BusinessUnit`
			`AND KC.FK_CustomerCountry = -1`

2. dwh.Dim_Date ed
`INNER JOIN [dwh].[Dim_Date] ed
	ON s.[FK_EntryDate] = ed.[KDP_SK]`

3. dwh.Dim_Currency cu
`INNER JOIN [dwh].[Dim_Currency] cu
	ON s.[FK_HomeCurrency] = cu.[KDP_SK]`

---
### [Return to Fact Tables](/Archive/Data-Lineage/Fact-Tables)