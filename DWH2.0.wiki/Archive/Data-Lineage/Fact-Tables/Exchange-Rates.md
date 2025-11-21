---
# Exchange Rates Mapping
---

## Introduction

Exchange Rates is based on a SQL View in DWH called **dbo.Exchange Rates** which will be the _Target_ and it is derived from **dwh.Fact_ExchangeRates** which will be the _Source_  and it joins with:
- dwh.Dim_Date; and 
- dwh.Dim_Currency;


---

## Data Lineage

::: mermaid
 graph LR;
 A[dwh.Fact_ExchangeRates] --> B[dbo.Exchange Rates] -->  C[Exchange Rates];
E[dwh.Dim_Date] -->  B;
F[dwh.Dim_Currency] -->  B;
:::

---

## Source Details
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
Target Name: `dbo.Exchange Rates`
Target Type: `View`
Target System: `DWH SQL Server`

|View Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|dbo.Exchange Rates|  Exchange Rate Key|  | ||
|dbo.Exchange Rates|  Date Closing Key|  char(30) | True||
|dbo.Exchange Rates|  Date Closing|  date | True||
|dbo.Exchange Rates|  Currency Key|  bigint | True||
|dbo.Exchange Rates|  Currency |  nvarchar(20) | True||
|dbo.Exchange Rates|  Rate Average |  decimal(28,12) | True||
|dbo.Exchange Rates|  Rate Average Month |  decimal(28,12) | True||
|dbo.Exchange Rates|  Rate Closing |  decimal(28,12) | True||
|dbo.Exchange Rates|  Rate Budget Average |  decimal(28,12) | True||
|dbo.Exchange Rates|  Rate Budget Average Month |  decimal(28,12) | True||
|dbo.Exchange Rates|  Rate Budget Closing |  decimal(28,12) | True||

---

### 1st Exchange Rate Table

| Source Table | Source Field  | Target Table  | Target Field  | Transformation Rules  | Data Type | Nullable  |
|--|--|--|--|--|--|--|
| dwh.Fact_ExchangeRates | FK_ClosingDate |dbo.Exchange Rates|  Exchange Rate Key | ROW_NUMBER() OVER (ORDER BY FK_ClosingDate) |  |  |
| dwh.Fact_ExchangeRates | FK_ClosingDate |dbo.Exchange Rates| Date Closing Key | None | char(30)  |  True|
| dwh.Dim_Date | DateFull |dbo.Exchange Rates| Date Closing | None | date  |  True|
| dwh.Fact_ExchangeRates | FK_Currency |dbo.Exchange Rates| Currency Key | None | bigint  |  True|
| dwh.Dim_Currency | CurrencyCode |dbo.Exchange Rates| Currency | None | nvarchar(20)  |  True|
| dwh.Fact_ExchangeRates | AverageRate |dbo.Exchange Rates| Rate Average | COALESCE(AverageRate, 0) | decimal(28,12)   |  True|
| dwh.Fact_ExchangeRates | AverageMonthRate |dbo.Exchange Rates| Rate Average Month | COALESCE(AverageMonthRate, 0) | decimal(28,12)   |  True|
| dwh.Fact_ExchangeRates | ClosingRate |dbo.Exchange Rates| Rate Closing| COALESCE(ClosingRate, 0) | decimal(28,12)   |  True|
| dwh.Fact_ExchangeRates | AverageBudgetRate |dbo.Exchange Rates| Rate Budget Average| COALESCE(AverageBudgetRate, 0) | decimal(28,12)   |  True|
| dwh.Fact_ExchangeRates | AverageMonthBudgetRate |dbo.Exchange Rates| Rate Budget Average Month| COALESCE(AverageMonthBudgetRate, 0) | decimal(28,12)   |  True|
| dwh.Fact_ExchangeRates | ClosingBudgetRate |dbo.Exchange Rates| Rate Budget Closing| COALESCE(ClosingBudgetRate, 0) | decimal(28,12)   |  True|

---

## Transformation Rules

### Column Specific Transformation
1. Exchange Rate Key
`ROW_NUMBER() OVER (ORDER BY FK_ClosingDate)`

2. Rate Average
`COALESCE(AverageRate, 0)`

2. Rate Average Month
`COALESCE(AverageMonthRate, 0)`

2. Rate Closing
`COALESCE(ClosingRate, 0)`

2. Rate Budget Average
`COALESCE(AverageBudgetRate, 0)`

2. Rate Budget Average Month
`COALESCE(AverageMonthBudgetRate, 0)`

2. Rate Budget Closing 
`COALESCE(ClosingBudgetRate, 0)`


### Joins `dwh.Fact_ExchangeRates er`
1. dwh.Dim_Currency cu
`INNER JOIN [dwh].[Dim_Currency] cu
	ON er.[FK_Currency] = cu.[KDP_SK]`

2. dwh.Dim_Currency rcu
`INNER JOIN [dwh].[Dim_Currency] rcu
	ON er.[FK_ReferenceCurrency] = rcu.KDP_SK`

3. dwh.Dim_Date cd
`INNER JOIN [dwh].[] cd
	ON er.[FK_ClosingDate] = cd.[KDP_SK]`

4. WHERE clause
`WHERE rcu.[CurrencyCode] = 'USD'`

---
---

### 2nd Exchange Rate Table

| Source Table | Source Field  | Target Table  | Target Field  | Transformation Rules  | Data Type | Nullable  |
|--|--|--|--|--|--|--|
| dwh.Fact_ExchangeRates | FK_ClosingDate |dbo.Exchange Rates|  Exchange Rate Key | ROW_NUMBER() OVER (ORDER BY FK_ClosingDate) |  |  |
| dwh.Fact_ExchangeRates | FK_ClosingDate |dbo.Exchange Rates| Date Closing Key | None | char(30)  |  True|
| dwh.Dim_Date | DateFull |dbo.Exchange Rates| Date Closing | None | date  |  True|
| dwh.Fact_ExchangeRates | FK_Currency |dbo.Exchange Rates| Currency Key | None | bigint  |  True|
| dwh.Dim_Currency | CurrencyCode |dbo.Exchange Rates| Currency | None | nvarchar(20)  |  True|
| dwh.Fact_ExchangeRates er, er_usd | AverageRate |dbo.Exchange Rates| Rate Average | COALESCE(er.[AverageRate] / er_usd.[AverageRate], 0) | decimal(28,12)   |  True|
| dwh.Fact_ExchangeRates | AverageMonthRate |dbo.Exchange Rates| Rate Average Month | COALESCE(er.[AverageMonthRate] / er_usd.[AverageMonthRate], 0)  | decimal(28,12)   |  True|
| dwh.Fact_ExchangeRates | ClosingRate |dbo.Exchange Rates| Rate Closing| COALESCE(er.[ClosingRate] / er_usd.[ClosingRate], 0)  | decimal(28,12)   |  True|
| dwh.Fact_ExchangeRates | AverageBudgetRate |dbo.Exchange Rates| Rate Budget Average| COALESCE(er.[AverageBudgetRate] / er_usd.[AverageBudgetRate], 0) | decimal(28,12)   |  True|
| dwh.Fact_ExchangeRates | AverageMonthBudgetRate |dbo.Exchange Rates| Rate Budget Average Month| COALESCE(er.[AverageMonthBudgetRate] / er_usd.[AverageMonthBudgetRate], 0) | decimal(28,12)   |  True|
| dwh.Fact_ExchangeRates | ClosingBudgetRate |dbo.Exchange Rates| Rate Budget Closing| COALESCE(er.[ClosingBudgetRate] / er_usd.[ClosingBudgetRate], 0)  | decimal(28,12)   |  True|

---

## Transformation Rules

### Column Specific Transformation
1. Exchange Rate Key
`ROW_NUMBER() OVER (ORDER BY FK_ClosingDate)`

2. Rate Average
`COALESCE(er.[AverageRate] / er_usd.[AverageRate], 0)`

2. Rate Average Month
`COALESCE(er.[AverageMonthRate] / er_usd.[AverageMonthRate], 0)`

2. Rate Closing
`COALESCE(er.[ClosingRate] / er_usd.[ClosingRate], 0)`

2. Rate Budget Average
`COALESCE(er.[AverageBudgetRate] / er_usd.[AverageBudgetRate], 0)`

2. Rate Budget Average Month
`COALESCE(er.[AverageMonthBudgetRate] / er_usd.[AverageMonthBudgetRate], 0)`

2. Rate Budget Closing 
`COALESCE(er.[ClosingBudgetRate] / er_usd.[ClosingBudgetRate], 0)`



### Joins `dwh.Fact_ExchangeRates er`
1. dwh.Dim_Currency cu
`INNER JOIN [dwh].[Dim_Currency] cu
	ON er.[FK_Currency] = cu.[KDP_SK]`

2. dwh.Dim_Currency rcu
`INNER JOIN [dwh].[Dim_Currency] rcu
	ON er.[FK_ReferenceCurrency] = rcu.KDP_SK`

3. dwh.Dim_Date cd
`INNER JOIN [dwh].[] cd
	ON er.[FK_ClosingDate] = cd.[KDP_SK]`

4. dwh.Fact_ExchangeRates er_usd
`LEFT OUTER JOIN
(`
	`SELECT`
		`er.[FK_ClosingDate]`
		`,er.[AverageRate]`
		`,er.[AverageMonthRate]`
		`,er.[ClosingRate]`
		`,er.[AverageBudgetRate]`
		`,er.[AverageMonthBudgetRate]`
		`,er.[ClosingBudgetRate]`
	`FROM [dwh].[Fact_ExchangeRates] er`
	`INNER JOIN [dwh].[Dim_Currency] cu`
		`ON er.[FK_Currency] = cu.[KDP_SK]`
	`INNER JOIN [dwh].[Dim_Currency] rcu`
		`ON er.[FK_ReferenceCurrency] = rcu.KDP_SK`
	`WHERE`
		`rcu.[CurrencyCode] = 'EUR'`
		`AND cu.[CurrencyCode] = 'USD'`
`) er_usd`
	`ON er.[FK_ClosingDate] = er_usd.[FK_ClosingDate]`

5. Where clause
`WHERE
	rcu.[CurrencyCode] = 'EUR'`

---
These two tables are joined using UNION ALL.

---
### [Return to Fact Tables](/Archive/Data-Lineage/Fact-Tables)