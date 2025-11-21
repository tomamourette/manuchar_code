---
# Accounts Receivables (AR) Mapping
---

## Introduction

Accounts Receivables (AR) is based on a SQL View in DWH called **dbo.Accounts Receivable** which will be the _Target_ and it is derived from **dwh.Fact_AccountsReceivable** which will be the _Source_  and it has multiple joins with:
- dwh.Dim_Currency;
- dwh.Dim_Customer;
- dwh.Dim_Country;
- dwh.Dim_BusinessPartner; 
- dwh.Sec_KeyCombinations;
- dwh.Dim_Date;
- dwh.Dim_AgeGroup;
- dwh.Dim_Company;
- dwh.Dim_Invoice; 
- dwh.Fact_InvoiceGuarantees;
- dwh.Fact_InvoiceProvisions; and
- dwh.Fact_ExchangeRates; 


---

## Data Lineage

::: mermaid
 graph LR;
 A[dwh.Fact_AccountsReceivable] --> B[dbo.Accounts Receivable] -->  C[Accounts Receivable];
D[dwh.Dim_Customer] -->  B;
E[dwh.Dim_Country] -->  B;
F[dwh.Sec_KeyCombinations] -->  B;
G[dwh.Dim_BusinessPartner] -->  B;
H[dwh.Dim_Date] -->  B;
I[dwh.Dim_AgeGroup] -->  B;
J[dwh.Dim_Company] -->  B;
K[dwh.Fact_InvoiceGuarantees] -->  B;
L[dwh.Fact_InvoiceProvisions] -->  B;
M[dwh.Dim_Invoice] -->  B;
N[dwh.Fact_ExchangeRates] -->  B;
O[dwh.Dim_Currency] -->  B;
:::

---

## Source Details
Source Name: `dwh.Fact_AccountsReceivable` 
Source Type: `Table`
Source System: `DWH SQL Server`

|Table Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|dwh.Fact_AccountsReceivable|  InvoiceCode|  nvarchar(1000) | True||
|dwh.Fact_AccountsReceivable|  uk_field|   nvarchar(2073)| False ||
|dwh.Fact_AccountsReceivable|  FK_Company|  bigint | True  ||
|dwh.Fact_AccountsReceivable|  FK_ClosingDate |  int | True  ||
|dwh.Fact_AccountsReceivable|  FK_InvoiceDate|  int | True  ||
|dwh.Fact_AccountsReceivable|  FK_DueDate|  int | True  ||
|dwh.Fact_AccountsReceivable|  FK_BusinessUnit|  bigint | True  ||
|dwh.Fact_AccountsReceivable|  FK_BusinessType|  bigint | True  ||
|dwh.Fact_AccountsReceivable|  FK_Customer|bigint   | True  ||
|dwh.Fact_AccountsReceivable|  FK_InvoiceCurrency|  bigint | True  ||
|dwh.Fact_AccountsReceivable|  FK_HomeCurrency|bigint   | True  ||
|dwh.Fact_AccountsReceivable|  FK_AgeGroup|  bigint | True  ||
|dwh.Fact_AccountsReceivable|  IsCADLC|  bit| True  ||
|dwh.Fact_AccountsReceivable|  IsDeclarable|  bit| True  ||
|dwh.Fact_AccountsReceivable|  PaymentTerm|  nvarchar(1000) | True||
|dwh.Fact_AccountsReceivable|  InvoiceLegalNumber|  nvarchar(1000) | True||
|dwh.Fact_AccountsReceivable|  JuniorTrader|  nvarchar(10) | True||
|dwh.Fact_AccountsReceivable|  SeniorTrader|  nvarchar(10) | True||
|dwh.Fact_AccountsReceivable|  Team|  nvarchar(50) | True||
|dwh.Fact_AccountsReceivable|  Responsible|  nvarchar(10) | True||
|dwh.Fact_AccountsReceivable|  Coordinator|  nvarchar(10) | True||
|dwh.Fact_AccountsReceivable|  FileNumber|  nvarchar(1000) | True||
|dwh.Fact_AccountsReceivable|  OrderNumber|  nvarchar(1000) | True||
|dwh.Fact_AccountsReceivable|  OpenAmountHomeCurrency|  float | True||
|dwh.Fact_AccountsReceivable|  OpenAmountInvoiceCurrency|  decimal(38, 6)| True||
|dwh.Fact_AccountsReceivable|  OpenAmountGroupCurrency|  float | True||
|dwh.Fact_AccountsReceivable|  InvoiceAmountHomeCurrency|  float | True||
|dwh.Fact_AccountsReceivable|  InvoiceAmountInvoiceCurrency|  decimal(32, 6)| True||
|dwh.Fact_AccountsReceivable|  InvoiceAmountGroupCurrency|  float | True||
|dwh.Fact_AccountsReceivable|  InsuranceReceivedInvoiceCurrency|  decimal(18,5)| True||
|dwh.Fact_AccountsReceivable|  InsuranceReceivedHomeCurrency|  decimal(38,6)| True||
|dwh.Fact_AccountsReceivable|  InsuranceReceivedGroupCurrency|  decimal(18,5)| True||
|dwh.Fact_AccountsReceivable|  IsEpicorData|  int | True  ||
|dwh.Fact_AccountsReceivable|  KDP_checksum|  int | True  ||
|dwh.Fact_AccountsReceivable|  KDP_executionId|  int | True  ||
|dwh.Fact_AccountsReceivable|  KDP_loadDT|  datetime| True  ||

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

Source Name: `dwh.Dim_Customer`
Source Type: `Table`
Source System: `DWH SQL Server`

|Table Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|dwh.Dim_Customer|  CustomerCode |  nvarchar(503) | False||
|dwh.Dim_Customer|  CustomerName|  nvarchar(500) | True  ||
|dwh.Dim_Customer|  LegalNumber|  nvarchar(50) | True  ||
|dwh.Dim_Customer|  CountryCode|  nvarchar(20) | True  ||
|dwh.Dim_Customer|  CountryName|  nvarchar(500) | True  ||
|dwh.Dim_Customer|  CommercialRegionName|  nvarchar(500) | True  ||
|dwh.Dim_Customer|  Address|  nvarchar(500) | True  ||
|dwh.Dim_Customer|  ZIPCode|  nvarchar(20) | True  ||
|dwh.Dim_Customer|  City|  nvarchar(500) | True  ||
|dwh.Dim_Customer|  CurrencyCode|  nvarchar(20) | True  ||
|dwh.Dim_Customer|  MultinationalCustomerCode|  nvarchar(500) | True  ||
|dwh.Dim_Customer|  MultinationalCustomerName|  nvarchar(500) | True  ||
|dwh.Dim_Customer|  MultinationalLegalNumber|  nvarchar(50) | True  ||
|dwh.Dim_Customer|  MultinationalCountryCode|  nvarchar(20) | True  ||
|dwh.Dim_Customer|  MultinationalCountryName|  nvarchar(500) | True  ||
|dwh.Dim_Customer|  AffiliateCode|  nvarchar(20) | True  ||
|dwh.Dim_Customer|  AffiliateDescription|  nvarchar(500) | True  ||
|dwh.Dim_Customer|  IsAffiliate|  bit | True  ||
|dwh.Dim_Customer|  IndustryTypeCode|  nvarchar(20) | True  ||
|dwh.Dim_Customer|  IndustryTypeDescription|  nvarchar(500) | True  ||
|dwh.Dim_Customer|  MNCParentCode|  nvarchar(20) | True  ||
|dwh.Dim_Customer|  MNCParentName|  nvarchar(500) | True  ||
|dwh.Dim_Customer|  CreatedDateTime|  datetime(3) | True  ||
|dwh.Dim_Customer|  ModifiedDateTime|  datetime(3) | True  ||
|dwh.Dim_Customer|  ValidationStatus|  nvarchar(50) | True  ||
|dwh.Dim_Customer|  KDP_SK|  bigint IDENTITY(1,1) | False||
|dwh.Dim_Customer|  KDP_checksum|  int | True  ||
|dwh.Dim_Customer|  KDP_executionId|  int | True  ||
|dwh.Dim_Customer|  KDP_loadDT|  datetime | True  ||
---

Source Name: `dwh.Dim_Country`
Source Type: `Table`
Source System: `DWH SQL Server`


|Table Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|dwh.Dim_Country|  CountryCode|  nvarchar(20) | True  ||
|dwh.Dim_Country|  CountryName|  nvarchar(500) | True  ||
|dwh.Dim_Country|  ISOAlphaCode|  nvarchar(20) | True  ||
|dwh.Dim_Country|  ISONumericCode|  nvarchar(20) | True  ||
|dwh.Dim_Country|  CommercialRegionCode|  nvarchar(20) | True  ||
|dwh.Dim_Country|  CommercialRegionName|  nvarchar(500) | True  ||
|dwh.Dim_Country|  CreatedDateTime|  datetime2(3) | True  ||
|dwh.Dim_Country|  ModifiedDateTime|  datetime2(3) | True  ||
|dwh.Dim_Country|  ValidationStatus|  nvarchar(50) | True  ||
|dwh.Dim_Country|  KDP_SK|  bigint IDENTITY(1,1) | False||
|dwh.Dim_Country|  KDP_checksum|  int | True  ||
|dwh.Dim_Country|  KDP_executionId|  int | True  ||
|dwh.Dim_Country|  KDP_loadDT|  datetime| True  ||
---

Source Name: `dwh.Dim_BusinessPartner`
Source Type: `Table`
Source System: `DWH SQL Server`


|Table Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|dwh.Dim_BusinessPartner  |  BusinessPartnerCode|  nvarchar(500) | True  ||
|dwh.Dim_BusinessPartner  |  BusinessPartnerName|  nvarchar(500) | True  ||
|dwh.Dim_BusinessPartner  |  OriginalLegalNumber|  nvarchar(50) | True  ||
|dwh.Dim_BusinessPartner  |  LegalNumber|  nvarchar(50) | True  ||
|dwh.Dim_BusinessPartner  |  CountryCode|  nvarchar(20) | True  ||
|dwh.Dim_BusinessPartner  |  CountryName|  nvarchar(500) | True  ||
|dwh.Dim_BusinessPartner  |  CommercialRegionName|  nvarchar(500) | True  ||
|dwh.Dim_BusinessPartner  |  Address|  nvarchar(500) | True  ||
|dwh.Dim_BusinessPartner  |  ZIPCode|  nvarchar(20) | True  ||
|dwh.Dim_BusinessPartner  |  City|  nvarchar(500) | True  ||
|dwh.Dim_BusinessPartner  |  IntercompanyCode|  nvarchar(20) | True  ||
|dwh.Dim_BusinessPartner  |  IntercompanyDescription|  nvarchar(500) | True  ||
|dwh.Dim_BusinessPartner  |  IsIntercompany|  bit | True  ||
|dwh.Dim_BusinessPartner  |  IndustryTypeCode|  nvarchar(20) | True  ||
|dwh.Dim_BusinessPartner  |  IndustryTypeDescription|  nvarchar(500) | True  ||
|dwh.Dim_BusinessPartner  |  MultinationalBusinessPartnerCode|  nvarchar(500) | True  ||
|dwh.Dim_BusinessPartner  |  MultinationalBusinessPartnerName|  nvarchar(500) | True  ||
|dwh.Dim_BusinessPartner  |  MultinationalLegalNumber|  nvarchar(50) | True  ||
|dwh.Dim_BusinessPartner  |  MultinationalCountryCode|  nvarchar(20) | True  ||
|dwh.Dim_BusinessPartner  |  MultinationalCountryName|  nvarchar(500) | True  ||
|dwh.Dim_BusinessPartner  |  CreatedDateTime|  datetime2(3) | True  ||
|dwh.Dim_BusinessPartner  |  ModifiedDateTime|  datetime2(3) | True  ||
|dwh.Dim_BusinessPartner  |  ValidationStatus|  nvarchar(50) | True  ||
|dwh.Dim_BusinessPartner  |  KDP_SK|  bigint IDENTITY(1,1) | False||
|dwh.Dim_BusinessPartner  |  KDP_checksum|  int | True  ||
|dwh.Dim_BusinessPartner  |  KDP_executionId|  int | True  ||
|dwh.Dim_BusinessPartner  |  KDP_executionId|  int | True  ||
|dwh.Dim_BusinessPartner  |  KDP_loadDT|  datetime | True  ||

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

Source Name: `dwh.Fact_InvoiceGuarantees`
Source Type: `Table` 
Source System: `DWH SQL Server`


|Table Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|dwh.Fact_InvoiceGuarantees|  FK_Company|  bigint | True  ||
|dwh.Fact_InvoiceGuarantees|  FK_Customer|bigint   | True  ||
|dwh.Fact_InvoiceGuarantees|  FK_GuaranteeCurrency|bigint   | True  ||
|dwh.Fact_InvoiceGuarantees|  FK_ClosingDate |  char(30)| True  ||
|dwh.Fact_InvoiceGuarantees|  InvoiceCode|  nvarchar(50) | True||
|dwh.Fact_InvoiceGuarantees|  GuaranteeCode|  nvarchar(20) | True||
|dwh.Fact_InvoiceGuarantees|  GuaranteeAmountGuaranteeCurrency|  decimal(18, 2) | True||
|dwh.Fact_InvoiceGuarantees|  GuaranteeAmountGroupCurrency|  decimal(18, 2) | True||
|dwh.Fact_InvoiceGuarantees|  GuaranteeGroupCode|  nvarchar(20) | True||
|dwh.Fact_InvoiceGuarantees|  GuaranteeGroupDescription|  nvarchar(500) | True||
|dwh.Fact_InvoiceGuarantees|  GuaranteeTypeCode|  nvarchar(20) | True||
|dwh.Fact_InvoiceGuarantees|  GuaranteeTypeDescription|  nvarchar(500) | True||
|dwh.Fact_InvoiceGuarantees|  CreatedDateTime|  datetime2(3) | True  ||
|dwh.Fact_InvoiceGuarantees|  ModifiedDateTime|  datetime2(3) | True  ||
|dwh.Fact_InvoiceGuarantees|  ValidationStatus|   nvarchar(50)  | True  ||
|dwh.Fact_InvoiceGuarantees|  KDP_checksum|  int | True  ||
|dwh.Fact_InvoiceGuarantees|  KDP_executionId|  int | True  ||
|dwh.Fact_InvoiceGuarantees|  KDP_loadDT|  datetime | True  ||


---

Source Name: `dwh.Fact_InvoiceProvisions`
Source Type: `Table` 
Source System: `DWH SQL Server`


|Table Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|dwh.Fact_InvoiceProvisions|  FK_Company|  bigint | True  ||
|dwh.Fact_InvoiceProvisions|  FK_Customer | bigint   | True  ||
|dwh.Fact_InvoiceProvisions|  FK_ProvisionCurrency| bigint   | True  ||
|dwh.Fact_InvoiceProvisions|  FK_ClosingDate| char(30)| True  ||
|dwh.Fact_InvoiceProvisions|  InvoiceCode| char(50)| True  ||
|dwh.Fact_InvoiceProvisions|  ProvisionCode| char(20)| True  ||
|dwh.Fact_InvoiceProvisions|  ProvisionAmountProvisionCurrency| decimal(18, 2)| True  ||
|dwh.Fact_InvoiceProvisions|  ProvisionAmountGroupCurrency| decimal(18, 2)| True  ||
|dwh.Fact_InvoiceProvisions|  CreatedDateTime|  datetime2(3) | True  ||
|dwh.Fact_InvoiceProvisions|  ModifiedDateTime|  datetime2(3) | True  ||
|dwh.Fact_InvoiceProvisions|  ValidationStatus|   nvarchar(50)  | True  ||
|dwh.Fact_InvoiceProvisions|  KDP_checksum|  int | True  ||
|dwh.Fact_InvoiceProvisions|  KDP_executionId|  int | True  ||
|dwh.Fact_InvoiceProvisions|  KDP_loadDT|  datetime | True  ||

---
Source Name: `dwh.Fact_ExchangeRates`
Source Type: `Table` 
Source System: `DWH SQL Server`


|Table Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|dwh.Fact_ExchangeRates|  uk_field|  nvarchar(34) | False||
|dwh.Fact_ExchangeRates|  FK_Currency|  bigint | False||
|dwh.Fact_ExchangeRates|  FK_Currency|  bigint | False||
|dwh.Fact_ExchangeRates|  FK_ClosingDate|  char(30)| False||
|dwh.Fact_ExchangeRates|  AverageRate|  decimal(28,12)| False||
|dwh.Fact_ExchangeRates|  AverageMonthRate|  decimal(28,12)| False||
|dwh.Fact_ExchangeRates|  ClosingRate|  decimal(28,12)| False||
|dwh.Fact_ExchangeRates|  AverageBudgetRate|  decimal(28,12)| False||
|dwh.Fact_ExchangeRates|  AverageMonthBudgetRate|  decimal(28,12)| False||
|dwh.Fact_ExchangeRates|  ClosingBudgetRate|  decimal(28,12)| False||
|dwh.Fact_ExchangeRates|  KDP_checksum|  int | True  ||
|dwh.Fact_ExchangeRates|  KDP_executionId|  int | True  ||
|dwh.Fact_ExchangeRates|  KDP_loadDT|  datetime | True  ||


---

## Target Details
Target Name: `dbo.Accounts Receivable `
Target Type: `View`
Target System: `DWH SQL Server`

|View Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|dbo.Accounts Receivable |  Invoice Key |  bigint | False||
|dbo.Accounts Receivable |  Company Key |  bigint | True||
|dbo.Accounts Receivable |  Date Closing Key |  int| True||
|dbo.Accounts Receivable |  Customer Key |  bigint | True||
|dbo.Accounts Receivable |  Age Group Key |  bigint | True||
|dbo.Accounts Receivable |  Currency Key |  bigint | True||
|dbo.Accounts Receivable |  Business Unit  Key |  bigint | True||
|dbo.Accounts Receivable |  Business Type Key |  bigint | True||
|dbo.Accounts Receivable |  Date Invoice |  date| True||
|dbo.Accounts Receivable |  Date Due|  date| True||
|dbo.Accounts Receivable |  Flag CADLC |  bit| True||
|dbo.Accounts Receivable |  Flag Declarable|  bit| True||
|dbo.Accounts Receivable |  Payment Term|  nvarchar(1000)| True||
|dbo.Accounts Receivable |  AR Invoice Number|  nvarchar(1000)| True||
|dbo.Accounts Receivable |  Legal  Number|  nvarchar(1000)| True||
|dbo.Accounts Receivable |  M AR Balance Invoice Currency|  decimal(38, 6)| True||
|dbo.Accounts Receivable |  M AR Balance Invoice Currency Excl.DELCREDERE|  | ||
|dbo.Accounts Receivable |  M AR Amount Invoice Currency|  decimal(32, 6)| True||
|dbo.Accounts Receivable |  M AR Balance Invoice Currency|  decimal(38, 6)| True||
|dbo.Accounts Receivable | M AR Balance Home Currency|  float | True||
|dbo.Accounts Receivable | M AR Amount Home Currency|  float | True||
|dbo.Accounts Receivable | M AR Balance Invoice USD|  float | True||
|dbo.Accounts Receivable | M AR Balance Invoice USD Excl.DELCREDERE|  | ||
|dbo.Accounts Receivable | M AR Amount Invoice USD|  float | True||
|dbo.Accounts Receivable |  M Amount Insurance Received|  decimal(18,5)| True||
|dbo.Accounts Receivable |  M Amount Insurance Received Invoice Currency|  decimal(18,5)| True||
|dbo.Accounts Receivable |  M Amount Insurance Received USD|  decimal(18,5)| True||
|dbo.Accounts Receivable | M Amount Insurance Received USD Excl.DELCREDERE |  | ||
|dbo.Accounts Receivable | M AR Balance USD MONA|  float | True||
|dbo.Accounts Receivable | M AR Amount USD MONA|  | ||
|dbo.Accounts Receivable |M Guarantee Cash Amount USD|  | ||
|dbo.Accounts Receivable |M Guarantee Cash Amount USD Excl.DELCREDERE|  | ||
|dbo.Accounts Receivable |M Guarantee Non-Cash Amount USD|  | ||
|dbo.Accounts Receivable |M Guarantee Amount Guarantee Currency|  decimal(18, 2)| True ||
|dbo.Accounts Receivable |M Provision Amount USD|  decimal(18, 2)| True ||
|dbo.Accounts Receivable |M Provision Amount Provision Currency|  decimal(18, 2)| True ||
|dbo.Accounts Receivable |M Overdue Amount USD MONA|  | ||
|dbo.Accounts Receivable |M Overdue Amount USD MONA > 360 Days|  | ||
|dbo.Accounts Receivable |Security Key|  | ||
|dbo.Accounts Receivable |KeyCombination Key| bigint IDENTITY(1,1) | false ||
	

---
## Field Mapping


| Source Table | Source Field  | Target Table  | Target Field  | Transformation Rules  | Data Type | Nullable  |
|--|--|--|--|--|--|--|
| dwh.Dim_Invoice| KDP_SK |dbo.Accounts Receivable |  Invoice Key | COALESCE(COALESCE(iv.[KDP_SK], iv2.[KDP_SK]),-1) | bigint   |  False|
| dwh.Fact_AccountsReceivable| FK_Company|dbo.Accounts Receivable |  Company Key | None | bigint   |  True|
| dwh.Fact_AccountsReceivable| FK_ClosingDate|dbo.Accounts Receivable |  Date ClosingKey | None | int|  True|
| dwh.Fact_AccountsReceivable| FK_Customer|dbo.Accounts Receivable |  Customer Key | None | bigint   |  True|
| dwh.Fact_AccountsReceivable| FK_AgeGroup|dbo.Accounts Receivable |  Age Group Key | None | bigint   |  True|
| dwh.Fact_AccountsReceivable| FK_InvoiceCurrency|dbo.Accounts Receivable |  Currency Key | None | bigint   |  True|
| dwh.Fact_AccountsReceivable| FK_BusinessUnit|dbo.Accounts Receivable |  Business Unit Key | None | bigint   |  True|
| dwh.Fact_AccountsReceivable| FK_BusinessType|dbo.Accounts Receivable |  Business Type Key | None | bigint   |  True|
| dwh.Dim_Date id| DateFull|dbo.Accounts Receivable | Date Invoice| None | date|  True|
| dwh.Dim_Date dd| DateFull|dbo.Accounts Receivable | Date Due| None | date|  True|
| dwh.Fact_AccountsReceivable| IsCADLC|dbo.Accounts Receivable | Flag CADLC| COALESCE(IsCADLC, 0)| bit |  True|
| dwh.Fact_AccountsReceivable| IsDeclarable|dbo.Accounts Receivable | Flag Declarable| COALESCE(IsDeclarable, 0)| bit |  True|
| dwh.Fact_AccountsReceivable| PaymentTerm|dbo.Accounts Receivable |  Payment Term | None | nvarchar(1000)|  True|
| dwh.Fact_AccountsReceivable| InvoiceCode|dbo.Accounts Receivable |  AR Invoice Number | None | nvarchar(1000)|  True|
| dwh.Fact_AccountsReceivable| InvoiceLegalNumber|dbo.Accounts Receivable |  Legal Number | COALESCE(InvoiceLegalNumber, '') | nvarchar(1000)|  True|
| dwh.Fact_AccountsReceivable| OpenAmountInvoiceCurrency|dbo.Accounts Receivable |  M AR Balance Invoice Currency | COALESCE(OpenAmountInvoiceCurrency, '') | decimal(38, 6)|  True|
| dwh.Fact_AccountsReceivable f, dwh.Dim_Customer cu| f.OpenAmountInvoiceCurrency, cu.CustomerCode|dbo.Accounts Receivable |  M AR Balance Invoice Currency Excl.DELCREDERE | WHEN cu.CustomerCode = 'BE - 0203286759' THEN 0, ELSE COALESCE(f.OpenAmountGroupCurrency, 0)||  |
| dwh.Fact_AccountsReceivable| InvoiceAmountInvoiceCurrency|dbo.Accounts Receivable |  M AR Amount Invoice Currency | COALESCE(InvoiceAmountInvoiceCurrency, 0) | decimal(38, 6)|  True|
| dwh.Fact_AccountsReceivable| OpenAmountHomeCurrency|dbo.Accounts Receivable |  M AR Balance Home Currency | COALESCE(OpenAmountHomeCurrency, 0) | float|  True|
| dwh.Fact_AccountsReceivable| InvoiceAmountHomeCurrency|dbo.Accounts Receivable |  M AR Amount Home Currency | COALESCE(InvoiceAmountHomeCurrency, 0) | float|  True|
| dwh.Fact_AccountsReceivable| OpenAmountGroupCurrency|dbo.Accounts Receivable | M AR Balance Invoice USD | COALESCE(OpenAmountGroupCurrency, 0) | float|  True|
| dwh.Fact_AccountsReceivable f, dwh.Dim_Customer cu| f.OpenAmountGroupCurrency, cu.CustomerCode|dbo.Accounts Receivable |  M AR Balance Invoice USD Excl.DELCREDERE | WHEN cu.CustomerCode = 'BE - 0203286759' THEN 0, ELSE COALESCE(f.OpenAmountGroupCurrency, 0)||  |
| dwh.Fact_AccountsReceivable| InvoiceAmountGroupCurrency|dbo.Accounts Receivable |M AR Amount Invoice USD | COALESCE(InvoiceAmountGroupCurrency, 0) | float|  True|
| dwh.Fact_AccountsReceivable| InsuranceReceivedInvoiceCurrency|dbo.Accounts Receivable |M Amount Insurance Received | COALESCE(InsuranceReceivedInvoiceCurrency, 0) | decimal(18,5)|  True|
| dwh.Fact_AccountsReceivable| InsuranceReceivedInvoiceCurrency|dbo.Accounts Receivable |M Amount Insurance Received Invoice Currency| COALESCE(InsuranceReceivedInvoiceCurrency, 0) | decimal(18,5)|  True|
| dwh.Fact_AccountsReceivable| InsuranceReceivedGroupCurrency|dbo.Accounts Receivable |M Amount Insurance Received USD| COALESCE(InsuranceReceivedGroupCurrency, 0) | decimal(18,5)|  True|
| dwh.Fact_AccountsReceivable f, dwh.Dim_Customer cu| f.InsuranceReceivedGroupCurrency, cu.CustomerCode|dbo.Accounts Receivable |  M Amount Insurance Received USD Excl.DELCREDERE| WHEN cu.CustomerCode = 'BE - 0203286759' THEN 0, ELSE COALESCE(f.InsuranceReceivedGroupCurrency, 0)||  |
| dwh.Fact_AccountsReceivable| OpenAmountGroupCurrency|dbo.Accounts Receivable |M AR Balance USD MONA| COALESCE(OpenAmountGroupCurrency, 0) | float|  True|
| dwh.Fact_AccountsReceivable f, dwh.Fact_ExchangeRates er | f.InvoiceAmountInvoiceCurrency, f.OpenAmountHomeCurrency, f.OpenAmountInvoiceCurrency, er.ClosingRate |dbo.Accounts Receivable |M AR Amount USD MONA| COALESCE(CONVERT(DECIMAL(38,10), f.InvoiceAmountInvoiceCurrency) * (COALESCE(CONVERT(DECIMAL(38,10), f.OpenAmountHomeCurrency) / NULLIF(CONVERT(DECIMAL(38,10), f.OpenAmountInvoiceCurrency), 0), 1)) * er.ClosingRate, 0)  | float|  True|
| dwh.Fact_InvoiceGuarantees| CashGuaranteeAmountGuaranteeCurrency|dbo.Accounts Receivable |M Guarantee Cash Amount USD| COALESCE(CashGuaranteeAmountGuaranteeCurrency, 0) | |  |
| dwh.Fact_InvoiceGuarantees ig, dwh.Dim_Customer cu| ig.CashGuaranteeAmountGuaranteeCurrency, cu.CustomerCode|dbo.Accounts Receivable | M Guarantee Cash Amount USD Excl.DELCREDERE| WHEN cu.CustomerCode = 'BE - 0203286759' THEN 0, ELSE COALESCE(ig.CashGuaranteeAmountGuaranteeCurrency, 0)||  |
| dwh.Fact_InvoiceGuarantees| NonCashGuaranteeAmountGuaranteeCurrency|dbo.Accounts Receivable |M Guarantee Non-Cash Amount USD| COALESCE(NonCashGuaranteeAmountGuaranteeCurrency, 0) | |  |
| dwh.Fact_InvoiceGuarantees| GuaranteeAmountGuaranteeCurrency|dbo.Accounts Receivable |M Guarantee Amount Guarantee Currency| COALESCE(GuaranteeAmountGuaranteeCurrency, 0) |decimal(18, 2) |  True|
| dwh.Fact_InvoiceProvisions| ProvisionAmountGroupCurrency|dbo.Accounts Receivable |M Provision Amount USD| COALESCE(ProvisionAmountGroupCurrency, 0) |decimal(18, 2) |  True|
| dwh.Fact_InvoiceProvisions| ProvisionAmountProvisionCurrency|dbo.Accounts Receivable |M Provision Amount Provision Currency| COALESCE(ProvisionAmountGroupCurrency, 0) |decimal(18, 2) |  True|
| dwh.Fact_AccountsReceivable f, dwh.Age_Groups ag| f.OpenAmountGroupCurrency, cu.AgeGroupCode|dbo.Accounts Receivable |  M Overdue Amount USD MONA| WHEN cu.AgeGroupCode= '0' THEN 0, ELSE COALESCE(f.OpenAmountGroupCurrency, 0)||  |
| dwh.Fact_AccountsReceivable f, dwh.Age_Groups ag| f.OpenAmountGroupCurrency, cu.AgeGroupCode|dbo.Accounts Receivable |  M Overdue Amount USD MONA > 360 Days| WHEN cu.AgeGroupCode < 6 THEN 0, ELSE COALESCE(f.OpenAmountGroupCurrency, 0)||  |
| dwh.Fact_AccountsReceivable | FK_BusinessType, FK_BusinessUnit, FK_Company, FK_Customer|dbo.Accounts Receivable |Security Key| CONCAT_WS('-', FK_BusinessType, FK_BusinessUnit, FK_Company, FK_Customer) | |  |
| dwh.Sec_KeyCombinations| KDP_SK | dbo.Accounts Receivable |KeyCombination Key|None|bigint IDENTITY(1,1)  | false |



---


## Transformation Rules

### Column Specific Transformation
1. Invoice Key
`COALESCE(COALESCE(iv.[KDP_SK], iv2.[KDP_SK]),-1)`

2. Flag CADLC
`COALESCE(IsCADLC,0)`

3. Flag Declarable
`COALESCE(IsDeclarable,0)`

4. Legal Number
`COALESCE(InvoiceLegalNumber, '')`

5. M AR Balance Invoice Currency
`COALESCE(OpenAmountInvoiceCurrency, '')`


6. M AR Balance Invoice Currency Excl.DELCREDERE
`WHEN cu.[CustomerCode] = 'BE - 0203286759'
		THEN 0 
		ELSE COALESCE(f.[OpenAmountInvoiceCurrency], 0) `

7. M AR Amount Invoice Currency
`COALESCE(InvoiceAmountInvoiceCurrency, 0)`

8. M AR Balance Home Currency
`COALESCE(OpenAmountHomeCurrency, 0)`

9. M AR Amount Home Currency
`COALESCE(InvoiceAmountHomeCurrency, 0)`

10. M AR Balance Invoice USD
`COALESCE(OpenAmountGroupCurrency, 0)`

11. M AR Balance Invoice USD Excl.DELCREDERE
`WHEN cu.[CustomerCode] = 'BE - 0203286759'
		THEN 0 
		ELSE COALESCE(f.[OpenAmountGroupCurrency], 0) `

12. M AR Amount Invoice USD
`COALESCE(InvoiceAmountGroupCurrency, 0)`

13. M Amount Insurance Received
`COALESCE(InsuranceReceivedInvoiceCurrency, 0)`

14. M Amount Insurance Received Invoice Currency
`COALESCE(InsuranceReceivedInvoiceCurrency, 0)`

15. M Amount Insurance Received USD
`COALESCE(InsuranceReceivedGroupCurrency, 0)`


16. M Amount Insurance Received USD Excl.DELCREDERE
`WHEN cu.[CustomerCode] = 'BE - 0203286759'
		THEN 0 
		ELSE COALESCE(f.[InsuranceReceivedGroupCurrency], 0) `

17. M AR Balance USD MONA
`COALESCE(OpenAmountGroupCurrency, 0)`

18. M AR Amount USD MONA
`COALESCE(CONVERT(DECIMAL(38,10), f.[InvoiceAmountInvoiceCurrency]) * (COALESCE(CONVERT(DECIMAL(38,10), f.[OpenAmountHomeCurrency]) / NULLIF(CONVERT(DECIMAL(38,10), f.[OpenAmountInvoiceCurrency]), 0), 1)) * er.[ClosingRate], 0)`

19. M Guarantee Cash Amount USD
`COALESCE(CashGuaranteeAmountGuaranteeCurrency, 0)`


20. M Guarantee Cash Amount USD Excl.DELCREDERE
`WHEN cu.[CustomerCode] = 'BE - 0203286759'
		THEN 0 
		ELSE COALESCE(ig.[CashGuaranteeAmountGuaranteeCurrency], 0) `


21. M Guarantee Non-Cash Amount USD
`COALESCE(NonCashGuaranteeAmountGuaranteeCurrency, 0)`

22. M Guarantee Amount Guarantee Currency
`COALESCE(GuaranteeAmountGuaranteeCurrency, 0)`

23. M Provision Amount USD
`COALESCE(ProvisionAmountGroupCurrency, 0)`

24. M Provision Amount Provision Currency
`COALESCE(ProvisionAmountProvisionCurrency, 0)`

25. M Overdue Amount USD MONA
`WHEN ag.[AgeGroupCode] = '0'
		THEN 0 
		ELSE COALESCE(f.[OpenAmountGroupCurrency], 0)`

26. M Overdue Amount USD MONA > 360 Days
`WHEN ag.[AgeGroupCode] < 6
		THEN 0 
		ELSE COALESCE(f.[OpenAmountGroupCurrency], 0)`

27. Security Key
`CONCAT_WS('-', FK_BusinessType, FK_BusinessUnit, FK_Company, FK_Customer)`


### Joins `dwh.Fact_AccountsReceivable f`

1. dwh.Dim_Customer cust
`LEFT join dwh.Dim_Customer cust on cust.KDP_SK = f.FK_Customer`

2. dwh.Dim_Country ctr
`LEFT join dwh.Dim_Country ctr on ctr.CountryCode = cust.CountryCode`

3. dwh.Sec_KeyCombinations KC
`INNER JOIN	dwh.Sec_KeyCombinations	AS KC`
			`ON  f.FK_BusinessType	= KC.FK_BusinessType`
			`AND f.FK_Company		= KC.FK_Company`
			`AND f.FK_BusinessUnit	= KC.FK_BusinessUnit`
			`AND	ctr.kdp_sk		= KC.FK_CustomerCountry`

4. dwh.Dim_Date id
`INNER JOIN [dwh].[Dim_Date] id 
	ON f.[FK_InvoiceDate] = id.[KDP_SK]`

5. dwh.Dim_Date dd
`INNER JOIN [dwh].[Dim_Date] dd 
	ON f.[FK_DueDate] = dd.[KDP_SK]`

6. dwh.Dim_Date cd
`INNER JOIN [dwh].[Dim_Date] cd 
	ON f.[FK_ClosingDate] = cd.[KDP_SK]`

7. dwh.Dim_Customer cu
`INNER JOIN [dwh].[Dim_Customer] cu
	ON f.[FK_Customer] = cu.[KDP_SK]`

8. dwh.Dim_AgeGroup ag
`INNER JOIN [dwh].[Dim_AgeGroup] ag
	ON f.[FK_AgeGroup] = ag.[KDP_SK]`

9. dwh.Dim_Company
`LEFT OUTER JOIN [dwh].[Dim_Company] co 
	ON f.[FK_Company] = co.[KDP_SK]`

10. dwh.Fact_InvoiceGuarantees ig
`LEFT OUTER JOIN (`
	`SELECT ig.[InvoiceCode], ig.[FK_ClosingDate] ,cd.[DateFull] AS [ClosingDate],ig.[FK_Company]`
		`,SUM(ig.[GuaranteeAmountGuaranteeCurrency]) AS [GuaranteeAmountGuaranteeCurrency]`
		`,SUM(`
		`CASE 
				WHEN ig.[GuaranteeGroupDescription] = 'Cash' 
				THEN ig.[GuaranteeAmountGroupCurrency]
				ELSE 0 
			END`
		`) AS [CashGuaranteeAmountGuaranteeCurrency]`
		`,SUM`
		`(
			CASE 
				WHEN ig.[GuaranteeGroupDescription] = 'Non-cash' 
				THEN ig.[GuaranteeAmountGroupCurrency]
				ELSE 0 
			END`
		`) AS [NonCashGuaranteeAmountGuaranteeCurrency]`
	`FROM [dwh].[Fact_InvoiceGuarantees] ig`
	`INNER JOIN [dwh].[Dim_Date] cd
		ON ig.[FK_ClosingDate] = cd.[KDP_SK]`
	`GROUP BY 
		ig.[InvoiceCode]
		,ig.[FK_ClosingDate]
		,cd.[DateFull]
		,ig.[FK_Company]`
	`) ig`
		`ON EOMONTH(cd.DateFull, -1) = ig.[ClosingDate]` 
		`AND f.[FK_Company]  = ig.[FK_Company]`
		`AND f.[InvoiceCode] = ig.[InvoiceCode]`

11. dwh.Fact_InvoiceProvisions ipr
`LEFT OUTER JOIN 
(`
	`SELECT
		ipr.[InvoiceCode]
		,ipr.[FK_ClosingDate]
		,cd.[DateFull] AS [ClosingDate]
		,ipr.[FK_Company]`
		`,SUM(ipr.[ProvisionAmountProvisionCurrency]) AS [ProvisionAmountProvisionCurrency]`
		`,SUM(ipr.[ProvisionAmountGroupCurrency]) AS [ProvisionAmountGroupCurrency]`
	`FROM [dwh].[Fact_InvoiceProvisions] ipr`
	`INNER JOIN [dwh].[Dim_Date] cd
		ON ipr.[FK_ClosingDate] = cd.[KDP_SK]`
	`GROUP BY
		ipr.[InvoiceCode]
		,ipr.[FK_ClosingDate]
		,cd.[DateFull]
		,ipr.[FK_Company]`
	`) ipr`
		`ON EOMONTH(cd.DateFull, -1) = ig.[ClosingDate] `
		`AND f.[FK_Company]  = ipr.[FK_Company]`
		`AND f.[InvoiceCode] = ipr.[InvoiceCode]`

12. dwh.Dim_Invoice iv
`LEFT OUTER JOIN [dwh].[Dim_Invoice] iv 
	ON CONCAT_WS(' - ', co.[CompanyCode], f.[InvoiceCode]) = iv.[InvoiceCode]`

13. dwh.Dim_Invoice iv2
`LEFT OUTER JOIN [dwh].[Dim_Invoice] iv2
		ON f.[InvoiceCode] = iv2.[Legalnumber]`

14. dwh.Dim_Currency c
`LEFT OUTER JOIN
(`
`	SELECT
		er.[FK_Currency]
		,er.[FK_ClosingDate]
		,er.[ClosingRate]`
`	FROM [dwh].[Fact_ExchangeRates] er`
`	INNER JOIN [dwh].[Dim_Currency] c
		ON er.[FK_ReferenceCurrency] = c.[KDP_SK]`
`	WHERE
		c.[CurrencyCode] = 'USD'`
`) er`
`	ON f.[FK_ClosingDate] = er.[FK_ClosingDate]
	AND f.[FK_HomeCurrency] = er.[FK_Currency]`

15. Where clause
`WHERE
	f.[FK_InvoiceDate] <> -1
	AND f.[FK_DueDate] <> -1`

---
### [Return to Fact Tables](/Archive/Data-Lineage/Fact-Tables)