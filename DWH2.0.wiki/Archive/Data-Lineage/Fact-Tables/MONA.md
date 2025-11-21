---
# MONA Mapping
---

## Introduction

Mona is based on a SQL View in DWH called **dbo.Mona** which will be the _Target_ and it is derived from **dwh.Fact_Consolidations** which will be the _Source_  and it joins with:
- dwh.Dim_Company;
- dwh.Dim_BusinessType; 
- dwh.Dim_Currency;
- dwh.Dim_Company;
- dwh.Dim_Date;
- dwh.Dim_GeneralLedgerAccount; and
- dwh.Sec_KeyCombinations

---

## Data Lineage

::: mermaid
 graph LR;
 A[dwh.Fact_Consolidations] --> B[dbo.Mona] -->  C[Mona];
D[dwh.Dim_Company] -->  B;
E[dwh.Dim_BusinessType] -->  B;
F[dwh.Dim_Currency] -->  B;
G[dwh.Dim_Company] -->  B;
H[dwh.Dim_Date] -->  B;
I[dwh.Dim_GeneralLedgerAccount] -->  B
:::

---

## Source Details
Source Name: `dwh.Fact_Consolidations` 
Source Type: `Table`
Source System: `DWH SQL Server`

|Table Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|dwh.Fact_Consolidations|  ConsolidationCode |  nvarchar(20) | True||
|dwh.Fact_Consolidations|  uk_field |  nvarchar(50) | False||
|dwh.Fact_Consolidations|  ConsolidationLineNumber|  bigint| True||
|dwh.Fact_Consolidations|  FK_GeneralLedgerAccount|  bigint| True||
|dwh.Fact_Consolidations|  FK_Company|  bigint | True||
|dwh.Fact_Consolidations|  FK_PartnerCompany|  bigint | True||
|dwh.Fact_Consolidations|  FK_ConsolidationCompany|  bigint| True||
|dwh.Fact_Consolidations|  FK_ClosingDate|  int| True||
|dwh.Fact_Consolidations|  FK_DestinationCountry|  bigint | True||
|dwh.Fact_Consolidations|  FK_HomeCurrency|  bigint | True||
|dwh.Fact_Consolidations|  OriginalAccountCode|  nvarchar(12)| True||
|dwh.Fact_Consolidations|  CategoryCode|  nvarchar(20)| True||
|dwh.Fact_Consolidations|  CategoryDescription|  nvarchar(50)| True||
|dwh.Fact_Consolidations|  Version|  smallint| False||
|dwh.Fact_Consolidations|  B001|  decimal(38, 6)| True||
|dwh.Fact_Consolidations|  E001|   decimal(38, 6)| True||
|dwh.Fact_Consolidations|  M001|  decimal(38, 6)| True||
|dwh.Fact_Consolidations|  M002|   decimal(38, 6)| True||
|dwh.Fact_Consolidations|  M003|  decimal(38, 6)| True||
|dwh.Fact_Consolidations|  M004|   decimal(38, 6)| True||
|dwh.Fact_Consolidations|  M005|  decimal(38, 6)| True||
|dwh.Fact_Consolidations|  M006|   decimal(38, 6)| True||
|dwh.Fact_Consolidations|  M007|  decimal(38, 6)| True||
|dwh.Fact_Consolidations|  M008|   decimal(38, 6)| True||
|dwh.Fact_Consolidations|  M015|  decimal(38, 6)| True||
|dwh.Fact_Consolidations|  M050|   decimal(38, 6)| True||
|dwh.Fact_Consolidations|  M060|  decimal(38, 6)| True||
|dwh.Fact_Consolidations|  T075|   decimal(38, 6)| True||
|dwh.Fact_Consolidations|  T077|  decimal(38, 6)| True||
|dwh.Fact_Consolidations|  T079|   decimal(38, 6)| True||
|dwh.Fact_Consolidations|  T081|  decimal(38, 6)| True||
|dwh.Fact_Consolidations|  T083|   decimal(38, 6)| True||
|dwh.Fact_Consolidations|  T085|  decimal(38, 6)| True||
|dwh.Fact_Consolidations|  T087|   decimal(38, 6)| True||
|dwh.Fact_Consolidations|  T089|   decimal(38, 6)| True||
|dwh.Fact_Consolidations|  T090|  decimal(38, 6)| True||
|dwh.Fact_Consolidations|  T093|   decimal(38, 6)| True||
|dwh.Fact_Consolidations|  POV|  int| True||
|dwh.Fact_Consolidations|  ConsolidationPointOfView|  nvarchar(500)| True||
|dwh.Fact_Consolidations|  ConsolidationSegment|  nvarchar(500)| True||
|dwh.Fact_Consolidations|  ConsolidationPointOfViewOrder|  int| True||
|dwh.Fact_Consolidations|  ConsolidationSegmentOrder|  int| True||
|dwh.Fact_Consolidations|  ConsolidationMethod|  nvarchar(50)| True||
|dwh.Fact_Consolidations|  Units|  tinyint| True||
|dwh.Fact_Consolidations|  DecimalNumber|  tinyint| True||
|dwh.Fact_Consolidations|  GroupPercentage|  decimal(24, 6)| True||
|dwh.Fact_Consolidations|  MinorPercentage|  decimal(24, 6)| True||
|dwh.Fact_Consolidations|  GroupControlPercentage|  decimal(24, 6)| True||
|dwh.Fact_Consolidations|  InRightsIssued|  bigint| True||
|dwh.Fact_Consolidations|  VotingRightsIssued|  bigint| True||
|dwh.Fact_Consolidations|  IsConsolidationCompany|  bit| True||
|dwh.Fact_Consolidations|  IsAvailableFor Sale|  bit| True||
|dwh.Fact_Consolidations|  IsConsolidatedCompany|  bit| True||
|dwh.Fact_Consolidations|  CalculateDeferredTaxFlag|  bit| True||
|dwh.Fact_Consolidations|  DeferredTaxRate|  decimal(24, 6)| True||
|dwh.Fact_Consolidations|  ConversionMethod|  tinyint| True||
|dwh.Fact_Consolidations|  IsDiscontinued|  bit| True||
|dwh.Fact_Consolidations|  B001_Overdue|  decimal(38, 6)| True||
|dwh.Fact_Consolidations|  T077_Overdue|  decimal(38, 6)| True||
|dwh.Fact_Consolidations|  T079_Overdue|  decimal(38, 6)| True||
|dwh.Fact_Consolidations|  BundleHomeCurrency|  decimal(38, 6)| True||
|dwh.Fact_Consolidations|  BundleLocalAdjustmentsHomeCurrency|  decimal(38, 6)| True||
|dwh.Fact_Consolidations|  B001_Stockaging|  decimal(38, 6)| True||
|dwh.Fact_Consolidations|  T079_Stockaging|  decimal(38, 6)| True||
|dwh.Fact_Consolidations|  B001_StockagingBis|  decimal(38, 6)| True||
|dwh.Fact_Consolidations|  T079_StockagingBis|  decimal(38, 6)| True||
|dwh.Fact_Consolidations|  B001_AcountsPayableAging|  decimal(38, 6)| True||
|dwh.Fact_Consolidations|  T079_AccountsPayableAging|  decimal(38, 6)| True||
|dwh.Fact_Consolidations|  KDP_checksum|  int| True||
|dwh.Fact_Consolidations|  KDP_executionId|  int| True||
|dwh.Fact_Consolidations|  KDP_loadDT|  datetime| True||

---


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

Source Name: `dwh.Dim_GeneralLedgerAccount`
Source Type: `Table` 
Source System: `DWH SQL Server`

|Table Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|dwh.Dim_GeneralLedgerAccount|  AccountCode|  nvarchar(20) | True||
|dwh.Dim_GeneralLedgerAccount|  AccountDescription|  nvarchar(500)| True  ||
|dwh.Dim_GeneralLedgerAccount|  AccountSIgn|  int| True  ||
|dwh.Dim_GeneralLedgerAccount|  CustomGroupingCode|  nvarchar(20) | True||
|dwh.Dim_GeneralLedgerAccount|  CustomGroupingDescription|  nvarchar(500)| True  ||
|dwh.Dim_GeneralLedgerAccount|  RunningTotalSign|  int| True  ||
|dwh.Dim_GeneralLedgerAccount|  ReportSign|  int | True||
|dwh.Dim_GeneralLedgerAccount|  CalculationAccount|  nvarchar(20)| True  ||
|dwh.Dim_GeneralLedgerAccount|  CalculationAccountGroup|  nvarchar(500)| True  ||
|dwh.Dim_GeneralLedgerAccount|  AccountCategory|  nvarchar(500) | True||
|dwh.Dim_GeneralLedgerAccount|  AccountGroup|  nvarchar(500)| True  ||
|dwh.Dim_GeneralLedgerAccount|  CreatedDateTime|  datetime2(3)| True  ||
|dwh.Dim_GeneralLedgerAccount|  ModifiedDateTime|  datetime2(3)| True||
|dwh.Dim_GeneralLedgerAccount|  ValidationStatus|  nvarchar(50)| True  ||
|dwh.Dim_GeneralLedgerAccount|  KDP_SK|  bigint IDENTITY(1, 1)| False||
|dwh.Dim_GeneralLedgerAccount|  KDP_checksum|  int | True||
|dwh.Dim_GeneralLedgerAccount|  KDP_executionId|  int| True  ||
|dwh.Dim_GeneralLedgerAccount|  KDP_loadDT|  datetime| True  ||


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

## Target Details
Target Name: `dbo.Mona`
Target Type: `View`
Target System: `DWH SQL Server`

|View Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|dbo.Mona|  Number | bigint  | True||
|dbo.Mona|  Conso| nvarchar(20) | True||
|dbo.Mona|  Account Key| bigint  | True||
|dbo.Mona|  Company Key| bigint   | True||
|dbo.Mona|  Date Closing Key| int | True||
|dbo.Mona|  Country Key| bigint | True||
|dbo.Mona|  Currency Key| bigint | True||
|dbo.Mona|  Category| nvarchar(50) | True||
|dbo.Mona|  CategoryName| nvarchar(50) | True||
|dbo.Mona|  Consolidation Segment Historical| nvarchar(500) | True||
|dbo.Mona|  Consolidation Point Of View Historical|  nvarchar(500) | True||
|dbo.Mona|  Consolidation Segment Sort Order| int | True||
|dbo.Mona|  Consolidation Point Of View Sort Order| int | True||
|dbo.Mona|  Security Key|  | True||
|dbo.Mona|  Version|  | True||
|dbo.Mona|  _Bundle Local Currency| decimal(38, 6) | True||
|dbo.Mona|  _Bundle Local Currency Monthly| decimal(38, 6) | True||
|dbo.Mona|  _Bundle Local Adjustment Local Currency| decimal(38, 6) | True||
|dbo.Mona|  _Bundle Local Adjustment Local Currency Monthly| decimal(38, 6) | True||
|dbo.Mona|  _Bundle| decimal(38, 6) | True||
|dbo.Mona|  _Bundle Monthly| decimal(38, 6) | True||
|dbo.Mona|  _Intercompany| decimal(38, 6)  | True||
|dbo.Mona|  _Intercompany Monthly| decimal(38, 6) | True||
|dbo.Mona|  _Technical Eliminations| decimal(38, 6) | True||
|dbo.Mona|  _Technical Eliminations Monthly| decimal(38, 6) | True||
|dbo.Mona|  _Manual| decimal(38, 6) | True||
|dbo.Mona|  _Manual Monthly| decimal(38, 6) | True||
|dbo.Mona|  _Allocation| decimal(38, 6) | True||
|dbo.Mona|  _Allocation Monthly| decimal(38, 6) | True||
|dbo.Mona|  _Conso Legal| (38, 6) | True||
|dbo.Mona|  _Conso Legal Monthly| decimal(38, 6) | True||
|dbo.Mona|  _Conso Adjusted| decimal(38, 6) | True||
|dbo.Mona|  _Conso Adjusted Monthly| decimal(38, 6) | True||
|dbo.Mona|  _Bundle Stock Aging| decimal(38, 6) | True||
|dbo.Mona|  _Conso Adjusted Stock Aging|  | True||
|dbo.Mona|  _Bundle Stock Aging > 90|  | True||
|dbo.Mona|  _Conso Adjusted Stock Aging > 90|  | True||
|dbo.Mona|  _IC Current Bundle|  | True||
|dbo.Mona|  _IC Current Technical|  | True||
|dbo.Mona|  _Bundle AP Aging|  | True||
|dbo.Mona|  _Conso Adjusted AP Aging|  | True||
|dbo.Mona|  Local Currency Code|  | True||
|dbo.Mona|  Partner Company Code|  | True||
|dbo.Mona|  Consolidation PovSegment Historical|  | True||
|dbo.Mona|  Consolidation Point Of ViewName Historical|  | True||
|dbo.Mona|  Consolidation Company Country Historical|  | True||
|dbo.Mona|  Consolidation Company Name Historical|  | True||
|dbo.Mona|  Company Consolidation Segment Sort Order|  | True||
|dbo.Mona|  Company Consolidation Point Of View Sort Order|  | True||
|dbo.Mona|  Bundle Actuals|  | True||
|dbo.Mona|  Bundle Actuals Local Currency|  | True||
|dbo.Mona|  Bundle Actuals Local Adjustment Local Currency|  | True||
|dbo.Mona|  Allocation Actuals|  | True||
|dbo.Mona|  Conso Adjusted Actuals|  | True||
|dbo.Mona|  Conso Legal Actuals|  | True||
|dbo.Mona|  Intercompany Actuals|  | True||
|dbo.Mona|  Manual Actuals|  | True||
|dbo.Mona|  Technical Eliminations Actuals|  | True||
|dbo.Mona|  Bundle Budget|  | True||
|dbo.Mona|  Bundle Budget Local Currency|  | True||
|dbo.Mona|  Bundle Budget Local Adjustment Local Currency|  | True||
|dbo.Mona|  Allocation Budget|  | True||
|dbo.Mona|  Conso Adjusted Budget|  | True||
|dbo.Mona|  Conso Legal Budget|  | True||
|dbo.Mona|  Intercompany Budget|  | True||
|dbo.Mona|  Manual Budget|  | True||
|dbo.Mona|  Technical Eliminations Budget|  | True||
|dbo.Mona|  KeyCombination Key|  | True||

---

## Field Mapping


| Source Table | Source Field  | Target Table  | Target Field  | Transformation Rules  | Data Type | Nullable  |
|--|--|--|--|--|--|--|
| dwh.Fact_Consolidations | ConsolidationLineNumber |dbo.Mona |  Number | | bigint |  True|
| dwh.Fact_Consolidations | ConsolidationCode | dbo.Mona |  Conso | | nvarchar(20) |  True|
| dwh.Fact_Consolidations | FK_GeneralLedgerAccount | dbo.Mona |  Account Key| | bigint |  True|
| dwh.Fact_Consolidations | FK_Company |dbo.Mona |  Company Key| | bigint |  True|
| dwh.Fact_Consolidations | FK_ClosingDate| dbo.Mona |  Date Closing Key| | int |  True|
| dwh.Fact_Consolidations | FK_DestinationCountry | dbo.Mona |  Country Key| | bigint |  True|
| dwh.Fact_Consolidations | FK_HomeCurrency|dbo.Mona |  Currency Key | | bigint |  True|
| dwh.Fact_Consolidations | CategoryCode| dbo.Mona |  Category| | nvarchar(20) |  True|
| dwh.Fact_Consolidations | CategoryDescription| dbo.Mona |  CategoryName| | nvarchar(50)|  True|
| dwh.Fact_Consolidations | ConsolidationSegment|dbo.Mona |  Consolidation Segment Historical | | nvarchar(500)|  True|
| dwh.Fact_Consolidations | ConsolidationPointOfView| dbo.Mona |  Consolidation Point Of View Historical| | nvarchar(500)|  True|
| dwh.Fact_Consolidations | ConsolidationSegmentOrder | dbo.Mona | Consolidation Segment Sort Order | | int|  True|
| dwh.Fact_Consolidations | ConsolidationPointOfViewOrder |dbo.Mona |  Consolidation Point Of View Sort Order| | int|  True|
| dwh.Fact_Consolidations | BundleHomeCurrency | dbo.Mona |  _Bundle Local Currency | | decimal(38, 6) |  True|
| dwh.Fact_Consolidations | BundleLocalAdjustmentsHomeCurrency | dbo.Mona | _Bundle Local Adjustment Local Currency | | decimal(38, 6)|  True|
| dwh.Fact_Consolidations c, dwh.BusinessType bt | c.FK_Company, bt.KDP_SK |dbo.Mona |  Security Key| CONCAT(CONCAT_WS('--', bt.[KDP_SK], c.[FK_Company]), '-')| |  True|
| dwh.Fact_Consolidations | B001| dbo.Mona |  _Bundle| | int |  True|
| dwh.Fact_Consolidations | E001, T083| dbo.Mona |  _Intercompany| E001 + T083| decimal(38, 6)|  True|
| dwh.Fact_Consolidations c | T075, T077, T081, T085, T087, T089, T090, T093, T079 |dbo.Mona |  _Technical Eliminations | c.[T075] + c.[T077] + c.[T081] + c.[T085] + c.[T087] + c.[T089] + c.[T090] + c.[T093] + c.[T079]  | decimal(38, 6)|  True|
| dwh.Fact_Consolidations | M001, M002, M003, M004, M005, M008, M015, M050, M060 | dbo.Mona |  _Manual | c.[M001] + c.[M002] + c.[M003] + c.[M004] + c.[M005] + c.[M008] + c.[M015] + c.[M050] + c.[M060] | decimal(38, 6) |  True|
| dwh.Fact_Consolidations | M006| dbo.Mona |  _Allocation| | decimal(38, 6) |  True|
| dwh.Fact_Consolidations | E001, T083, T075, T077, T081, T085, T087, T089, T090, T093, T079, M001, M002, M003, M004, M005, M008, M015, M050, M060, B001 |dbo.Mona |  _Conso Legal |c.[E001] + c.[T083] + c.[T075] + c.[T077] + c.[T081] + c.[T085] + c.[T087] + c.[T089] + c.[T090] + c.[T093] + c.[T079] + c.[M001] + c.[M002] + c.[M003] + c.[M004] + c.[M005] + c.[M008] + c.[M015] + c.[M050] + c.[M060] + c.[B001]  | decimal(38, 6)|  True|
| dwh.Fact_Consolidations | M006, M008, E001, T083, T075, T077, T081, T085, T087, T089, T090, T093, T079, M001, M002, M003, M004, M005, M015, M050, M060, B001 | dbo.Mona |  _Conso Adjusted | c.[M006] + c.[M008] + c.[E001] + c.[T083] + c.[T075] + c.[T077] + c.[T081] + c.[T085] + c.[T087] + c.[T089] + c.[T090] + c.[T093] + c.[T079] + c.[M001] + c.[M002] + c.[M003] + c.[M004] + c.[M005] + c.[M015] + c.[M050] + c.[M060]+  c.[B001]  | decimal(38, 6) |  True|
| dwh.Fact_Consolidations | B001_Stockaging | dbo.Mona | _Bundle Stock Aging | |decimal(38, 6)  |  True|
| dwh.Fact_Consolidations | B001_Stockaging, T079_Stockaging | dbo.Mona | _Conso Adjusted Stock Aging | B001_Stockaging + T079_Stockaging | decimal(38, 6)|  True|
| dwh.Fact_Consolidations | B001_StockagingBis | dbo.Mona | _Bundle Stock Aging > 90 | | decimal(38, 6)|  True|
| dwh.Fact_Consolidations | B001_StockagingBis, T079_StockagingBis | dbo.Mona | _Conso Adjusted Stock Aging > 90| c.[B001_StockagingBis] + c.[T079_StockagingBis] | decimal(38, 6)|  True|
| dwh.Fact_Consolidations | B001_Overdue| dbo.Mona | _IC Current Bundle | -(B001_Overdue) | decimal(38, 6)|  True|
| dwh.Fact_Consolidations | T077_Overdue, T079_OVERDUE | dbo.Mona | _IC Current Technical| -(c.[T077_Overdue] + [T079_OVERDUE])| decimal(38, 6)|  True|
| dwh.Fact_Consolidations | B001_AcountsPayableAging | dbo.Mona | _Bundle AP Aging | | decimal(38, 6)|  True|
| dwh.Fact_Consolidations | B001_AcountsPayableAging, T079_AccountsPayableAging | dbo.Mona | _Conso Adjusted AP Aging | c.[B001_AcountsPayableAging] + c.[T079_AccountsPayableAging]  | decimal(38, 6)|  True|
| dwh.Dim_Currency | CurrencyCode | dbo.Mona | Local Currency Code |  | nvarchar(20) |  True|
| dwh.Dim_Company | CompanyCode | dbo.Mona | Partner Company Code | | |  True|
| dwh.Fact_Consolidations | Version | dbo.Mona | Version |  | |  True|
| dwh.Fact_Consolidations | BundleHomeCurrency | dbo.Mona |  _Bundle Local Currency Monthly| [Bundle Local Currency] - LAG([Bundle Local Currency],1,0) OVER(PARTITION BY YEAR(CONVERT(DATE,LTRIM([Date Closing Key]),112)),[Account Key],[Company Key],[CategoryName],[Partner Company Code],[Version] ORDER BY [Date Closing Key])| decimal(38, 6) |  True|
| dwh.Fact_Consolidations | BundleLocalAdjustmentsHomeCurrency | dbo.Mona | _Bundle Local Adjustment Local Currency Monthly | [Bundle Local Adjustment Local Currency] - LAG([Bundle Local Adjustment Local Currency],1,0) OVER(PARTITION BY YEAR(CONVERT(DATE,LTRIM([Date Closing Key]),112)),[Account Key],[Company Key],[CategoryName],[Partner Company Code],[Version] ORDER BY [Date Closing Key]) | decimal(38, 6)|  True|
| dwh.Fact_Consolidations | B001| dbo.Mona |  _Bundle Monthly| [Bundle] - LAG([Bundle],1,0) OVER(PARTITION BY YEAR(CONVERT(DATE,LTRIM([Date Closing Key]),112)),[Account Key],[Company Key],[CategoryName],[Partner Company Code],[Version] ORDER BY [Date Closing Key])| decimal(38, 6) |  True|
| dwh.Fact_Consolidations | E001, T083| dbo.Mona |  _Intercompany Monthly | [Intercompany] - LAG([Intercompany],1,0) OVER(PARTITION BY YEAR(CONVERT(DATE,LTRIM([Date Closing Key]),112)),[Account Key],[Company Key],[CategoryName],[Partner Company Code],[Version] ORDER BY [Date Closing Key])| decimal(38, 6)|  True|
| dwh.Fact_Consolidations c | T075, T077, T081, T085, T087, T089, T090, T093, T079 |dbo.Mona |  _Technical Eliminations |  [Technical Eliminations] - LAG([Technical Eliminations],1,0) OVER(PARTITION BY YEAR(CONVERT(DATE,LTRIM([Date Closing Key]),112)),[Account Key],[Company Key],[CategoryName],[Partner Company Code],[Version] ORDER BY [Date Closing Key])  | decimal(38, 6)|  True|
| dwh.Fact_Consolidations | _Manual |dbo.Mona |  _Manual Monthly |  [_Manual] - LAG([Manual],1,0) OVER(PARTITION BY YEAR(CONVERT(DATE,LTRIM([Date Closing Key]),112)),[Account Key],[Company Key],[CategoryName],[Partner Company Code],[Version] ORDER BY [Date Closing Key])  | decimal(38, 6)|  True|
| dwh.Fact_Consolidations | _Allocation |dbo.Mona |  _Allocation Monthly | [Allocation] - LAG([Allocation],1,0) OVER(PARTITION BY YEAR(CONVERT(DATE,LTRIM([Date Closing Key]),112)),[Account Key],[Company Key],[CategoryName],[Partner Company Code],[Version] ORDER BY [Date Closing Key]) | decimal(38, 6)|  True|
| dwh.Fact_Consolidations | _Conso Legal  |dbo.Mona | _Conso Legal Monthly | [Conso Legal] - LAG([Conso Legal],1,0) OVER(PARTITION BY YEAR(CONVERT(DATE,LTRIM([Date Closing Key]),112)),[Account Key],[Company Key],[CategoryName],[Partner Company Code],[Version] ORDER BY [Date Closing Key]) | decimal(38, 6)|  True|
| dwh.Fact_Consolidations | _Conso Adjusted  |dbo.Mona | _Conso Adjusted Monthly | [Conso Adjusted] - LAG([Conso Adjusted],1,0) OVER(PARTITION BY YEAR(CONVERT(DATE,LTRIM([Date Closing Key]),112)),[Account Key],[Company Key],[CategoryName],[Partner Company Code],[Version] ORDER BY [Date Closing Key]) | decimal(38, 6)|  True|
| dwh.Fact_Consolidations | ConsolidationSegment|dbo.Mona |  Consolidation PovSegment Historical | | nvarchar(500)|  True|
| dwh.Fact_Consolidations | ConsolidationPointOfView| dbo.Mona | Consolidation Point Of ViewName Historical | | nvarchar(500)|  True|
| dwh.Dim_Country | CountryName| dbo.Mona | Consolidation Company Country Historical |SELECT [CountryName] FROM [dwh].[Dim_Country] WHERE [KDP_SK] = [Country Key] | nvarchar(500)|  True|
| dwh.Dim_Company | CompanyName| dbo.Mona | Consolidation Company Name Historical | SELECT [CompanyName] FROM [dwh].[Dim_Company] WHERE [KDP_SK] = [Company Key] | nvarchar(500)|  True|
| dwh.Fact_Consolidations | ConsolidationPointOfViewOrder |dbo.Mona |  Company Consolidation Point Of View Sort Order | | int|  True|
| dwh.Fact_Consolidations | Bundle |dbo.Mona |  Bundle Actuals |  CASE [Category] WHEN 'ACT' THEN [Bundle] ELSE 0.0 END| decimal(38, 6)|  True|
| dwh.Fact_Consolidations | Bundle Local Currency |dbo.Mona |  Bundle Actuals Local Currency |  CASE [Category] WHEN 'ACT' THEN [Bundle Local Currency] ELSE 0.0 END| decimal(38, 6)|  True|
| dwh.Fact_Consolidations | Bundle Local Adjustment Local Currency |dbo.Mona | Bundle Actuals Local Adjustment Local Currency | CASE [Category] WHEN 'ACT' THEN [Bundle Local Adjustment Local Currency] ELSE 0.0 END | decimal(38, 6)|  True|
| dwh.Fact_Consolidations | Allocation |dbo.Mona | Allocation Actuals | CASE [Category] WHEN 'ACT' THEN [Allocation] ELSE 0.0 END | decimal(38, 6)|  True|
| dwh.Fact_Consolidations | Conso Adjusted |dbo.Mona |Conso Adjusted Actuals | CASE [Category] WHEN 'ACT' THEN [Conso Adjusted] ELSE 0.0 END| decimal(38, 6)|  True|
| dwh.Fact_Consolidations | Conso Legal |dbo.Mona | Conso Legal Actuals | CASE [Category] WHEN 'ACT' THEN [Conso Legal] ELSE 0.0 END | decimal(38, 6)|  True|
| dwh.Fact_Consolidations | Intercompany |dbo.Mona | Intercompany Actuals | CASE [Category] WHEN 'ACT' THEN [Intercompany] ELSE 0.0 END | decimal(38, 6)|  True|
| dwh.Fact_Consolidations | Manual |dbo.Mona | Manual Actuals | CASE [Category] WHEN 'ACT' THEN [Manual] ELSE 0.0 END | decimal(38, 6)|  True|
| dwh.Fact_Consolidations | Technical Eliminations |dbo.Mona | Technical Eliminations Actuals | CASE [Category] WHEN 'ACT' THEN [Technical Eliminations] ELSE 0.0 END | decimal(38, 6)|  True|
| dwh.Fact_Consolidations | Bundle |dbo.Mona | Bundle Budget |  CASE [Category] WHEN 'BUD' THEN [Bundle] ELSE 0.0 END | decimal(38, 6)|  True|
| dwh.Fact_Consolidations | Bundle Local Currency |dbo.Mona | Bundle Budget Local Currency | CASE [Category] WHEN 'BUD' THEN [Bundle Local Currency] ELSE 0.0 END | decimal(38, 6)|  True|
| dwh.Fact_Consolidations | Bundle Local Adjustment Local Currency |dbo.Mona | Bundle Budget Local Adjustment Local Currency |  CASE [Category] WHEN 'BUD' THEN [Bundle Local Adjustment Local Currency] ELSE 0.0 END | decimal(38, 6)|  True|
| dwh.Fact_Consolidations | Allocation |dbo.Mona | Allocation Budget |  CASE [Category] WHEN 'BUD' THEN [Allocation] ELSE 0.0 END | decimal(38, 6)|  True|
| dwh.Fact_Consolidations | Conso Adjusted |dbo.Mona | Conso Adjusted Budget | CASE [Category] WHEN 'BUD' THEN [Conso Adjusted] ELSE 0.0 END | decimal(38, 6)|  True|
| dwh.Fact_Consolidations | Conso Legal |dbo.Mona | Conso Legal Budget |  CASE [Category] WHEN 'BUD' THEN [Conso Legal] ELSE 0.0 END | decimal(38, 6)|  True|
| dwh.Fact_Consolidations | Intercompany |dbo.Mona | Intercompany Budget | CASE [Category] WHEN 'BUD' THEN [Intercompany] ELSE 0.0 END | decimal(38, 6)|  True|
| dwh.Fact_Consolidations | Manual |dbo.Mona | Manual Budget | CASE [Category] WHEN 'BUD' THEN [Manual] ELSE 0.0 END | decimal(38, 6)|  True|
| dwh.Fact_Consolidations | Technical Eliminations |dbo.Mona | Technical Eliminations Budget | CASE [Category] WHEN 'BUD' THEN [Technical Eliminations] ELSE 0.0 END | decimal(38, 6)|  True|
| dwh.sec_keyCombinations | KDP_SK | dbo.Mona | KeyCombination Key |  | decimal(38, 6)|  True|



---

## Transformation 


```
CREATE VIEW [dbo].[MONA] AS 
WITH CTE_RAW
AS 
(
	SELECT 					
		c.[ConsolidationLineNumber] AS [Number] 	
		,c.[ConsolidationCode] AS [Conso]
		,c.[FK_GeneralLedgerAccount] AS [Account Key]
		,c.[FK_Company] AS [Company Key]		
		,c.[FK_ClosingDate] AS [Date Closing Key]			
		,c.[FK_DestinationCountry] AS [Country Key]	
		,c.[FK_HomeCurrency] AS [Currency Key]		
		,c.[CategoryCode] AS [Category]	
		,c.[CategoryDescription] AS [CategoryName]
		,c.[ConsolidationSegment] AS [Consolidation Segment Historical]		
		,c.[ConsolidationPointOfView] AS [Consolidation Point Of View Historical]		
		,c.[ConsolidationSegmentOrder] AS [Consolidation Segment Sort Order]
		,c.[ConsolidationPointOfViewOrder] AS [Consolidation Point Of View Sort Order]
		,c.[BundleHomeCurrency] AS [Bundle Local Currency]
		,c.[BundleLocalAdjustmentsHomeCurrency] AS [Bundle Local Adjustment Local Currency]
		,CONCAT(CONCAT_WS('--', bust.[KDP_SK], c.[FK_Company]), '-') AS [Security Key] 
		,c.[B001] AS [Bundle]
		,c.[E001] + c.[T083] AS [Intercompany]
		,c.[T075] + c.[T077] + c.[T081] + c.[T085] + c.[T087] + c.[T089] + c.[T090] + c.[T093] + c.[T079] AS [Technical Eliminations]
		,c.[M001] + c.[M002] + c.[M003] + c.[M004] + c.[M005] + c.[M008] + c.[M015] + c.[M050] + c.[M060] AS [Manual]
		,c.[M006] AS [Allocation]
		,c.[E001] + c.[T083] + c.[T075] + c.[T077] + c.[T081] + c.[T085] + c.[T087] + c.[T089] + c.[T090] + c.[T093] + c.[T079] + c.[M001] + c.[M002] + c.[M003] + c.[M004] + c.[M005] + c.[M008] + c.[M015] + c.[M050] + c.[M060] + c.[B001] AS [Conso Legal]
		,c.[M006] + c.[M008] + c.[E001] + c.[T083] + c.[T075] + c.[T077] + c.[T081] + c.[T085] + c.[T087] + c.[T089] + c.[T090] + c.[T093] + c.[T079] + c.[M001] + c.[M002] + c.[M003] + c.[M004] + c.[M005] + c.[M015] + c.[M050] + c.[M060]+  c.[B001] AS [Conso Adjusted]
		,c.[B001_Stockaging] AS [Bundle Stock Aging]																																					  
		,c.[B001_Stockaging] + c.[T079_Stockaging] AS [Conso Adjusted Stock Aging]	
		,c.[B001_StockagingBis] AS [Bundle Stock Aging > 90]		
		,c.[B001_StockagingBis] + c.[T079_StockagingBis] AS [Conso Adjusted Stock Aging > 90]
		,c.[B001_Overdue] AS [IC Current Bundle]
		,c.[T077_Overdue] + [T079_OVERDUE] AS [IC Current Technical]
		,c.[B001_AcountsPayableAging] AS [Bundle AP Aging]	
		,c.[B001_AcountsPayableAging] + c.[T079_AccountsPayableAging] AS [Conso Adjusted AP Aging]	
		,cu.[CurrencyCode] AS [Local Currency Code]
		,pc.[CompanyCode] AS [Partner Company Code]
		,c.[Version] AS [Version]
		,KC.KDP_SK AS [KeyCombination Key]
	FROM [dwh].[Fact_Consolidations] c 
	INNER JOIN [dwh].[Dim_Company] comp ON c.[FK_Company] = comp.[KDP_SK]
	LEFT OUTER JOIN [dwh].[Dim_BusinessType] bust ON comp.[BusinessType] = bust.[BusinessTypeDescription]
	INNER JOIN [dwh].[Dim_Currency] cu ON c.[FK_HomeCurrency] = cu.[KDP_SK]
	INNER JOIN [dwh].[Dim_Company] pc ON c.[FK_PartnerCompany] = pc.[KDP_SK]
    INNER JOIN dwh.sec_keyCombinations KC on
                    kc.FK_BusinessType = -1
		        and kc.FK_BusinessUnit = -1
		        and kc.FK_CustomerCountry = -1
		        and kc.FK_Company = c.FK_Company
     )

SELECT 
	[Number]
	,[Conso]
	,[Account Key]
	,[Company Key]
	,[Date Closing Key]
	,[Country Key]
	,[Currency Key]
	,[CategoryName] AS [Category]
	,[CategoryName]
	,[Consolidation Segment Historical]
	,[Consolidation Point Of View Historical]
	,[Consolidation Segment Sort Order]
	,[Consolidation Point Of View Sort Order]
	,[Security Key]
	,[Version]
	,[_Bundle Local Currency] = [Bundle Local Currency]   
	,[_Bundle Local Currency Monthly] = [Bundle Local Currency] - LAG([Bundle Local Currency],1,0) OVER(PARTITION BY YEAR(CONVERT(DATE,LTRIM([Date Closing Key]),112)),[Account Key],[Company Key],[CategoryName],[Partner Company Code],[Version] ORDER BY [Date Closing Key])
	,[_Bundle Local Adjustment Local Currency] = [Bundle Local Adjustment Local Currency]
	,[_Bundle Local Adjustment Local Currency Monthly] = [Bundle Local Adjustment Local Currency] - LAG([Bundle Local Adjustment Local Currency],1,0) OVER(PARTITION BY YEAR(CONVERT(DATE,LTRIM([Date Closing Key]),112)),[Account Key],[Company Key],[CategoryName],[Partner Company Code],[Version] ORDER BY [Date Closing Key])
	,[_Bundle] = [Bundle]
	,[_Bundle Monthly] = [Bundle] - LAG([Bundle],1,0) OVER(PARTITION BY YEAR(CONVERT(DATE,LTRIM([Date Closing Key]),112)),[Account Key],[Company Key],[CategoryName],[Partner Company Code],[Version] ORDER BY [Date Closing Key])
	,[_Intercompany] = [Intercompany]
	,[_Intercompany Monthly] = [Intercompany] - LAG([Intercompany],1,0) OVER(PARTITION BY YEAR(CONVERT(DATE,LTRIM([Date Closing Key]),112)),[Account Key],[Company Key],[CategoryName],[Partner Company Code],[Version] ORDER BY [Date Closing Key])
	,[_Technical Eliminations] = [Technical Eliminations]
	,[_Technical Eliminations Monthly] = [Technical Eliminations] - LAG([Technical Eliminations],1,0) OVER(PARTITION BY YEAR(CONVERT(DATE,LTRIM([Date Closing Key]),112)),[Account Key],[Company Key],[CategoryName],[Partner Company Code],[Version] ORDER BY [Date Closing Key])
	,[_Manual] = [Manual]
	,[_Manual Monthly] = [Manual] - LAG([Manual],1,0) OVER(PARTITION BY YEAR(CONVERT(DATE,LTRIM([Date Closing Key]),112)),[Account Key],[Company Key],[CategoryName],[Partner Company Code],[Version] ORDER BY [Date Closing Key])
	,[_Allocation] = [Allocation]
	,[_Allocation Monthly] = [Allocation] - LAG([Allocation],1,0) OVER(PARTITION BY YEAR(CONVERT(DATE,LTRIM([Date Closing Key]),112)),[Account Key],[Company Key],[CategoryName],[Partner Company Code],[Version] ORDER BY [Date Closing Key])
	,[_Conso Legal] = [Conso Legal]
	,[_Conso Legal Monthly] = [Conso Legal] - LAG([Conso Legal],1,0) OVER(PARTITION BY YEAR(CONVERT(DATE,LTRIM([Date Closing Key]),112)),[Account Key],[Company Key],[CategoryName],[Partner Company Code],[Version] ORDER BY [Date Closing Key])
	,[_Conso Adjusted] = [Conso Adjusted]
	,[_Conso Adjusted Monthly] = [Conso Adjusted] - LAG([Conso Adjusted],1,0) OVER(PARTITION BY YEAR(CONVERT(DATE,LTRIM([Date Closing Key]),112)),[Account Key],[Company Key],[CategoryName],[Partner Company Code],[Version] ORDER BY [Date Closing Key])
	,[_Bundle Stock Aging] = [Bundle Stock Aging]
	,[_Conso Adjusted Stock Aging] = [Conso Adjusted Stock Aging]
	,[_Bundle Stock Aging > 90] = [Bundle Stock Aging > 90]
	,[_Conso Adjusted Stock Aging > 90] = [Conso Adjusted Stock Aging > 90]
	,[_IC Current Bundle] = -([IC Current Bundle])
	,[_IC Current Technical] = -([IC Current Technical])
	,[_Bundle AP Aging]	= [Bundle AP Aging]
	,[_Conso Adjusted AP Aging] = [Conso Adjusted AP Aging]
	,[Local Currency Code]
	,[Partner Company Code]
	,[Consolidation PovSegment Historical]			= [Consolidation Segment Historical] --to discontinue
	,[Consolidation Point Of ViewName Historical]	= [Consolidation Point Of View Historical] --to discontinue
	,[Consolidation Company Country Historical]		= (SELECT [CountryName] FROM [dwh].[Dim_Country] WHERE [KDP_SK] = [Country Key]) --to discontinue
	,[Consolidation Company Name Historical]		= (SELECT [CompanyName] FROM [dwh].[Dim_Company] WHERE [KDP_SK] = [Company Key]) --to discontinue
	,[Company Consolidation Segment Sort Order]		= [Consolidation Segment Sort Order] --to discontinue
	,[Company Consolidation Point Of View Sort Order]=[Consolidation Point Of View Sort Order] --to discontinue
	,[Bundle Actuals] = CASE [Category] WHEN 'ACT' THEN [Bundle] ELSE 0.0 END
	,[Bundle Actuals Local Currency] = CASE [Category] WHEN 'ACT' THEN [Bundle Local Currency] ELSE 0.0 END
	,[Bundle Actuals Local Adjustment Local Currency] = CASE [Category] WHEN 'ACT' THEN [Bundle Local Adjustment Local Currency] ELSE 0.0 END
	,[Allocation Actuals] = CASE [Category] WHEN 'ACT' THEN [Allocation] ELSE 0.0 END
	,[Conso Adjusted Actuals] = CASE [Category] WHEN 'ACT' THEN [Conso Adjusted] ELSE 0.0 END
	,[Conso Legal Actuals] = CASE [Category] WHEN 'ACT' THEN [Conso Legal] ELSE 0.0 END
	,[Intercompany Actuals] = CASE [Category] WHEN 'ACT' THEN [Intercompany] ELSE 0.0 END
	,[Manual Actuals] = CASE [Category] WHEN 'ACT' THEN [Manual] ELSE 0.0 END
	,[Technical Eliminations Actuals] = CASE [Category] WHEN 'ACT' THEN [Technical Eliminations] ELSE 0.0 END
	,[Bundle Budget] = CASE [Category] WHEN 'BUD' THEN [Bundle] ELSE 0.0 END
	,[Bundle Budget Local Currency] = CASE [Category] WHEN 'BUD' THEN [Bundle Local Currency] ELSE 0.0 END
	,[Bundle Budget Local Adjustment Local Currency] = CASE [Category] WHEN 'BUD' THEN [Bundle Local Adjustment Local Currency] ELSE 0.0 END
	,[Allocation Budget] = CASE [Category] WHEN 'BUD' THEN [Allocation] ELSE 0.0 END
	,[Conso Adjusted Budget] = CASE [Category] WHEN 'BUD' THEN [Conso Adjusted] ELSE 0.0 END
	,[Conso Legal Budget] = CASE [Category] WHEN 'BUD' THEN [Conso Legal] ELSE 0.0 END
	,[Intercompany Budget] = CASE [Category] WHEN 'BUD' THEN [Intercompany] ELSE 0.0 END
	,[Manual Budget] = CASE [Category] WHEN 'BUD' THEN [Manual] ELSE 0.0 END
	,[Technical Eliminations Budget] = CASE [Category] WHEN 'BUD' THEN [Technical Eliminations] ELSE 0.0 END
	,[KeyCombination Key]



FROM
(
	SELECT 
		 [Number], [Conso], [Account Key], [Company Key], [Date Closing Key], [Country Key], [Currency Key], [Category], [CategoryName]
		,[Consolidation Segment Historical], [Consolidation Point Of View Historical], [Consolidation Segment Sort Order], [Consolidation Point Of View Sort Order]
		,[Bundle Local Currency], [Bundle Local Adjustment Local Currency], [Security Key],[Version]
		,[Bundle], [Intercompany], [Technical Eliminations], [Manual], [Allocation], [Conso Legal], [Conso Adjusted]
		,[Bundle Stock Aging],[Conso Adjusted Stock Aging],[Bundle Stock Aging > 90],[Conso Adjusted Stock Aging > 90]
		,[IC Current Bundle],[IC Current Technical],[Bundle AP Aging],[Conso Adjusted AP Aging]
		,[Local Currency Code],[Partner Company Code]
            ,[KeyCombination Key]
      FROM CTE_RAW WHERE CATEGORY in ('ACT','STA','TAX','ITS','CDI','IFR','ITZ','CDZ','ITT','CDT')



	UNION ALL
	SELECT 
		 [Number], [Conso], [Account Key], [Company Key], d.FK_DATES_CLOSING, [Country Key], [Currency Key], [Category], [CategoryName]
		,[Consolidation Segment Historical], [Consolidation Point Of View Historical], [Consolidation Segment Sort Order], [Consolidation Point Of View Sort Order]
		,[Bundle Local Currency] = ([Bundle Local Currency])/12 * (d.MonthInYear)
		,[Bundle Local Adjustment Local Currency] = ([Bundle Local Adjustment Local Currency])/12 * (d.MonthInYear)
		,[Security Key],[Version]
		,[Bundle] = ([Bundle])/12 * (d.MonthInYear)
		,[Intercompany] = ([Intercompany])/12 * (d.MonthInYear)
		,[Technical Eliminations] = ([Technical Eliminations])/12 * (d.MonthInYear)
		,[Manual] = ([Manual])/12 * (d.MonthInYear)
		,[Allocation] = ([Allocation])/12 * (d.MonthInYear)
		,[Conso Legal] = ([Conso Legal])/12 * (d.MonthInYear)
		,[Conso Adjusted] = ([Conso Adjusted])/12 * (d.MonthInYear)
		,[Bundle Stock Aging] = NULL
		,[Conso Adjusted Stock Aging] = NULL
		,[Bundle Stock Aging > 90] = NULL
		,[Conso Adjusted Stock Aging > 90] = NULL
		,[IC Current Bundle] = [IC Current Bundle]
		,[IC Current Technical] = [IC Current Technical]
		,[Bundle AP Aging] = [Bundle AP Aging]/12
		,[Conso Adjusted AP Aging] = [Conso Adjusted AP Aging]/12
		,[Local Currency Code] 
		,[Partner Company Code] 
            ,[KeyCombination Key]
	FROM CTE_RAW F_MONA_CONSOLIDATED
		INNER JOIN (SELECT DISTINCT [Year], CONVERT(INT,CONVERT(CHAR(10),EOMONTH([DateFull]),112)) [FK_DATES_CLOSING], MonthInYear FROM [dwh].[Dim_Date]) d ON LEFT([F_MONA_CONSOLIDATED].[Date Closing Key],4) = d.[Year]
		INNER JOIN [dwh].[Dim_GeneralLedgerAccount] ON F_MONA_CONSOLIDATED.[Account Key] = [Dim_GeneralLedgerAccount].[KDP_SK] AND [Dim_GeneralLedgerAccount].AccountCategory IN ('P&L','Contingencies')
      WHERE Category IN ('BUD','FOR','ITB','CDB')
	UNION ALL	SELECT 
		 [Number], [Conso], [Account Key], [Company Key], d.FK_DATES_CLOSING, [Country Key], [Currency Key], [Category], [CategoryName]
		,[Consolidation Segment Historical], [Consolidation Point Of View Historical], [Consolidation Segment Sort Order], [Consolidation Point Of View Sort Order]
		,[Bundle Local Currency] = ([Bundle Local Currency])/12 * (d.MonthInYear)
		,[Bundle Local Adjustment Local Currency] = ([Bundle Local Adjustment Local Currency])/12 * (d.MonthInYear)
		,[Security Key],[Version]
		,[Bundle] = ([Bundle])/12 * (d.MonthInYear)
		,[Intercompany] = ([Intercompany])/12 * (d.MonthInYear)
		,[Technical Eliminations] = ([Technical Eliminations])/12 * (d.MonthInYear)
		,[Manual] = ([Manual])/12 * (d.MonthInYear)
		,[Allocation] = ([Allocation])/12 * (d.MonthInYear)
		,[Conso Legal] = ([Conso Legal])/12 * (d.MonthInYear)
		,[Conso Adjusted] = ([Conso Adjusted])/12 * (d.MonthInYear)
		,[Bundle Stock Aging] = NULL
		,[Conso Adjusted Stock Aging] = NULL
		,[Bundle Stock Aging > 90] = NULL
		,[Conso Adjusted Stock Aging > 90] = NULL
		,[IC Current Bundle] = [IC Current Bundle]
		,[IC Current Technical] = [IC Current Technical]
		,[Bundle AP Aging] = [Bundle AP Aging]/12
		,[Conso Adjusted AP Aging] = [Conso Adjusted AP Aging]/12
		,[Local Currency Code] 
		,[Partner Company Code] 
            ,[KeyCombination Key]
	FROM CTE_RAW F_MONA_CONSOLIDATED
		INNER JOIN (SELECT DISTINCT [Year], CONVERT(INT,CONVERT(CHAR(10),EOMONTH([DateFull]),112)) [FK_DATES_CLOSING], [MonthInYear] FROM [dwh].[Dim_Date]) d ON LEFT([F_MONA_CONSOLIDATED].[Date Closing Key],4) = d.[Year]
		INNER JOIN [dwh].[Dim_GeneralLedgerAccount] ON F_MONA_CONSOLIDATED.[Account Key] = [Dim_GeneralLedgerAccount].[KDP_SK] AND [Dim_GeneralLedgerAccount].AccountCategory IN ('Metrics')
	WHERE Category IN ('BUD','FOR','ITB','CDB')
	AND [Dim_GeneralLedgerAccount].[AccountCode] IN ('600000QMT','700000QMT','700001QMT')
	UNION ALL
	SELECT 
		 [Number], [Conso], [Account Key], [Company Key], d.FK_DATES_CLOSING, [Country Key], [Currency Key], [Category], [CategoryName]
		,[Consolidation Segment Historical], [Consolidation Point Of View Historical], [Consolidation Segment Sort Order], [Consolidation Point Of View Sort Order]
		,[Bundle Local Currency] = ([Bundle Local Currency])
		,[Bundle Local Adjustment Local Currency] = ([Bundle Local Adjustment Local Currency])
		,[Security Key],[Version]
		,[Bundle] = ([Bundle])
		,[Intercompany] = ([Intercompany])
		,[Technical Eliminations] = ([Technical Eliminations])
		,[Manual] = ([Manual])
		,[Allocation] = ([Allocation])
		,[Conso Legal] = ([Conso Legal])
		,[Conso Adjusted] = ([Conso Adjusted])
		,[Bundle Stock Aging] = NULL
		,[Conso Adjusted Stock Aging] = NULL
		,[Bundle Stock Aging > 90] = NULL
		,[Conso Adjusted Stock Aging > 90] = NULL
		,[IC Current Bundle] = [IC Current Bundle]
		,[IC Current Technical] = [IC Current Technical]
		,[Bundle AP Aging] = [Bundle AP Aging]
		,[Conso Adjusted AP Aging] = [Conso Adjusted AP Aging]
		,[Local Currency Code] 
		,[Partner Company Code] 
            ,[KeyCombination Key]
	FROM CTE_RAW F_MONA_CONSOLIDATED
		INNER JOIN (SELECT DISTINCT [Year], CONVERT(INT,CONVERT(CHAR(10),EOMONTH([DateFull]),112)) [FK_DATES_CLOSING], [MonthInYear] FROM [dwh].[Dim_Date]) d ON LEFT([F_MONA_CONSOLIDATED].[Date Closing Key],4) = d.[Year]
		INNER JOIN [dwh].[Dim_GeneralLedgerAccount] ON F_MONA_CONSOLIDATED.[Account Key] = [Dim_GeneralLedgerAccount].[KDP_SK] AND [Dim_GeneralLedgerAccount].AccountCategory IN ('Metrics')
	WHERE Category IN ('BUD','FOR','ITB','CDB')
	AND [Dim_GeneralLedgerAccount].[AccountCode] NOT IN ('600000QMT','700000QMT','700001QMT')
	UNION ALL
	SELECT 
		 [Number], [Conso], [Account Key], [Company Key], d.FK_DATES_CLOSING, [Country Key], [Currency Key], [Category], [CategoryName]
		,[Consolidation Segment Historical], [Consolidation Point Of View Historical], [Consolidation Segment Sort Order], [Consolidation Point Of View Sort Order]
		,[Bundle Local Currency], [Bundle Local Adjustment Local Currency], [Security Key],[Version]
		,[Bundle], [Intercompany], [Technical Eliminations], [Manual], [Allocation], [Conso Legal], [Conso Adjusted]	
		,[Bundle Stock Aging] 
		,[Conso Adjusted Stock Aging] 
		,[Bundle Stock Aging > 90] 
		,[Conso Adjusted Stock Aging > 90] 
		,[IC Current Bundle] = NULL
		,[IC Current Technical] = NULL
		,[Bundle AP Aging]
		,[Conso Adjusted AP Aging]
		,[Local Currency Code]
		,[Partner Company Code]
            ,[KeyCombination Key]
	FROM CTE_RAW F_MONA_CONSOLIDATED
		INNER JOIN (SELECT DISTINCT [Year], CONVERT(INT,CONVERT(CHAR(10),EOMONTH([DateFull]),112)) [FK_DATES_CLOSING], [MonthInYear] FROM [dwh].[Dim_Date]) d ON LEFT([F_MONA_CONSOLIDATED].[Date Closing Key],4) = d.[Year]
		INNER JOIN [dwh].[Dim_GeneralLedgerAccount] ON F_MONA_CONSOLIDATED.[Account Key] = [Dim_GeneralLedgerAccount].[KDP_SK] AND [Dim_GeneralLedgerAccount].AccountCategory IN ('Balance Sheet')
	WHERE Category IN ('BUD','FOR','ITB','CDB')
```

---
### [Return to Fact Tables](/Manuchar-Service-Delivery/BI-&-Data/Data-Lineage/Fact-Tables)