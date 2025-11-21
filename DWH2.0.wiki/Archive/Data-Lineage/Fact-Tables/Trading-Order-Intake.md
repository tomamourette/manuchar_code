---
# Trading Order Intake Mapping
---

## Introduction

 Trading Order Intake is based on a SQL View in DWH called **dbo.Trading Order Intake** which will be the _Target_ and it is derived from **dwh.Fact_TradingOrderIntakes** which will be the _Source_  and it has multiple left joins with:
- dwh.Dim_LocalProduct;
- dwh.Dim_Currency;
- dwh.Dim_Company;
- dwh.Dim_Customer;
- dwh.Dim_Country;
- dwh.Dim_UnitOfMeasure;
- dwh.Dim_BusinessPartner; and
- ds.mds_GL_Grouping_Trading_Order_Intake 

---

## Data Lineage

::: mermaid
 graph LR;
 A[dwh.Fact_TradingOrderIntakes] --> B[dbo.Trading Order Intake ] -->  C[Trading Order Intake ];
D[dwh.Dim_LocalProduct] -->  B;
E[dwh.Dim_Currency] -->  B;
F[dwh.Dim_Company] -->  B;
G[dwh.Dim_Customer] -->  B;
H[dwh.Dim_Country] -->  B;
I[dwh.Dim_UnitOfMeasure] -->  B;
J[dwh.Dim_BusinessPartner] -->  B;
K[ds.mds_GL_Grouping_Trading_Order_Intake] -->  B;
:::
---

## Source Details
Source Name: `dwh.Fact_TradingOrderIntakes`
Source Type: `Table`
Source System: `DWH SQL Server`

|Table Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|dwh.Fact_TradingOrderIntakes|  OrderIntakeLineCode|  nvarchar(376) | False  ||
|dwh.Fact_TradingOrderIntakes|  FK_Invoice|  bigint | True  ||
|dwh.Fact_TradingOrderIntakes|  FK_Company|  bigint | True  ||
|dwh.Fact_TradingOrderIntakes|  FK_ClosingDate|  int | True  ||
|dwh.Fact_TradingOrderIntakes|  FK_BusinessUnit|  bigint| True  ||
|dwh.Fact_TradingOrderIntakes|  FK_BusinessType|  bigint| True  ||
|dwh.Fact_TradingOrderIntakes|  FK_Customer|  bigint | True  ||
|dwh.Fact_TradingOrderIntakes|  FK_InvoiceCurrency|  bigint| False||
|dwh.Fact_TradingOrderIntakes|  FK_DestinationCountry|  bigint | True  ||
|dwh.Fact_TradingOrderIntakes|  FK_Product|  bigint | True  ||
|dwh.Fact_TradingOrderIntakes|  FK_ProductGrouping|  bigint| True  ||
|dwh.Fact_TradingOrderIntakes|  FK_LocalProduct|  bigint | True  ||
|dwh.Fact_TradingOrderIntakes|  FK_UnitOfMeasure|  bigint | True  ||
|dwh.Fact_TradingOrderIntakes|  FK_BookCurrency|  bigint | True  ||
|dwh.Fact_TradingOrderIntakes|  FK_HomeCurrency|  bigint| True  ||
|dwh.Fact_TradingOrderIntakes|  FK_BusinessPartner|  bigint| True  ||
|dwh.Fact_TradingOrderIntakes|  JournalCode|  nvarchar(50) | True  ||
|dwh.Fact_TradingOrderIntakes|  JournalNumber|  int| False||
|dwh.Fact_TradingOrderIntakes|  JournalTransaction|  nvarchar(50) | True  ||
|dwh.Fact_TradingOrderIntakes|  BookDebitAmount|  decimal(38,4) | True  ||
|dwh.Fact_TradingOrderIntakes|  BookCreditAmount|  decimal(38,4)| True  ||
|dwh.Fact_TradingOrderIntakes|  DebitAmount|  decimal(38,4) | True  ||
|dwh.Fact_TradingOrderIntakes|  CreditAmount|  decimal(38,4)| True  ||
|dwh.Fact_TradingOrderIntakes|  FiscalYear|  int| False||
|dwh.Fact_TradingOrderIntakes|  FiscalPeriod|  int| False||
|dwh.Fact_TradingOrderIntakes|  UserID|  nvarchar(50) | True  ||
|dwh.Fact_TradingOrderIntakes|  GeneralLedgerBook|  nvarchar(50) | True  ||
|dwh.Fact_TradingOrderIntakes|  GeneralLedgerAccount|  nvarchar(50) | True  ||
|dwh.Fact_TradingOrderIntakes|  SegmentValue4|  nvarchar(50) | True  ||
|dwh.Fact_TradingOrderIntakes|  FileNumber|  nvarchar(50) | True  ||
|dwh.Fact_TradingOrderIntakes|  Character01|  nvarchar(50) | True  ||
|dwh.Fact_TradingOrderIntakes|  OriginCountry|  nvarchar(50) | True  ||
|dwh.Fact_TradingOrderIntakes|  Character03|  nvarchar(50) | True  ||
|dwh.Fact_TradingOrderIntakes|  PartID|  nvarchar(50) | True  ||
|dwh.Fact_TradingOrderIntakes|  SalesType|  nvarchar(50) | True  ||
|dwh.Fact_TradingOrderIntakes|  Character07|  nvarchar(50) | True  ||
|dwh.Fact_TradingOrderIntakes|  TradingOrderIntakeID|  nvarchar(50) | True  ||
|dwh.Fact_TradingOrderIntakes|  VersionNumber|  nvarchar(50) | True  ||
|dwh.Fact_TradingOrderIntakes|  GridNumber|  nvarchar(50) | True  ||
|dwh.Fact_TradingOrderIntakes|  Number03|  nvarchar(50) | True  ||
|dwh.Fact_TradingOrderIntakes|  ExchangeRate|  decimal(18,2) | True  ||
|dwh.Fact_TradingOrderIntakes|  Number05|  nvarchar(50) | True  ||
|dwh.Fact_TradingOrderIntakes|  Volume|  nvarchar(50) | True  ||
|dwh.Fact_TradingOrderIntakes|  Number07|  nvarchar(50) | True  ||
|dwh.Fact_TradingOrderIntakes|  Number08|  nvarchar(50) | True  ||
|dwh.Fact_TradingOrderIntakes|  Number09|  nvarchar(50) | True  ||
|dwh.Fact_TradingOrderIntakes|  Number10|  nvarchar(50) | True  ||
|dwh.Fact_TradingOrderIntakes|  FileGridVersion|  nvarchar(50) | True  ||
|dwh.Fact_TradingOrderIntakes|  Freight|  nvarchar(50) | True  ||
|dwh.Fact_TradingOrderIntakes|  OriginalProductCode|  nvarchar(50) | True  ||
|dwh.Fact_TradingOrderIntakes|  Date01|  nvarchar(50) | True  ||
|dwh.Fact_TradingOrderIntakes|  Date02|  nvarchar(50) | True  ||
|dwh.Fact_TradingOrderIntakes|  IsNewFile|  int | True  ||
|dwh.Fact_TradingOrderIntakes|  KDP_checksum|  int | True  ||
|dwh.Fact_TradingOrderIntakes|  KDP_executionId|  int | True  ||
|dwh.Fact_TradingOrderIntakes|  KDP_loadDT|  datetime | True  ||

---

Source Name: `dwh.Dim_LocalProduct`
Source Type: `Table`
Source System: `DWH SQL Server`

|Table Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|dwh.Dim_LocalProduct|  LocalProductCode|  nvarchar(500) | True  ||
|dwh.Dim_LocalProduct|  LocalProductName|  nvarchar(500) | True  ||
|dwh.Dim_LocalProduct|  GroupProductCode|  nvarchar(50) | True  ||
|dwh.Dim_LocalProduct|  GroupProductName|  nvarchar(500) | True  ||
|dwh.Dim_LocalProduct|  ProductGroupingCode|  nvarchar(50) | True  ||
|dwh.Dim_LocalProduct|  ProductGroupingName|  nvarchar(500) | True  ||
|dwh.Dim_LocalProduct|  ProductBusinessUnitCode|  nvarchar(20) | True  ||
|dwh.Dim_LocalProduct|  ProductBusinessUnitName|  nvarchar(500) | True  ||
|dwh.Dim_LocalProduct|  ProductCategory|  nvarchar(500) | True  ||
|dwh.Dim_LocalProduct|  ProductSubcategory|  nvarchar(500) | True  ||
|dwh.Dim_LocalProduct|  CompanyCode|  nvarchar(1000) | True  ||
|dwh.Dim_LocalProduct|  CompanyName|  nvarchar(500) | True  ||
|dwh.Dim_LocalProduct|  GradeCode|  nvarchar(50) | True  ||
|dwh.Dim_LocalProduct|  GradeDescription|  nvarchar(500) | True  ||
|dwh.Dim_LocalProduct|  PackagingTypeCode|  nvarchar(50) | True  ||
|dwh.Dim_LocalProduct|  PackagingTypeDescription|  nvarchar(500) | True  ||
|dwh.Dim_LocalProduct|  FormCode|  nvarchar(50) | True  ||
|dwh.Dim_LocalProduct|  FormDescription|  nvarchar(500) | True  ||
|dwh.Dim_LocalProduct|  PackagingSize|  decimal(18,2) | True  ||
|dwh.Dim_LocalProduct|  PackagingUnitOfMeasureCode|  nvarchar(20) | True  ||
|dwh.Dim_LocalProduct|  PackagingUnitOfMeasureDescription|  nvarchar(500) | True  ||
|dwh.Dim_LocalProduct|  Quality|  decimal(18,2) | True  ||
|dwh.Dim_LocalProduct|  CAS|  nvarchar(500) | True  ||
|dwh.Dim_LocalProduct|  Chemwatch|  nvarchar(500) | True  ||
|dwh.Dim_LocalProduct|  MSDSDate|  datetime2(3) | True  ||
|dwh.Dim_LocalProduct|  CreatedDateTIme|  datetime2(3) | True  ||
|dwh.Dim_LocalProduct|  ModifiedDateTime|  datetime2(3) | True  ||
|dwh.Dim_LocalProduct|  ValidationStatus|  nvarchar(50) | True  ||
|dwh.Dim_LocalProduct|  KDP_SK|  bigint IDENTITY(1,1) | True  ||
|dwh.Dim_LocalProduct|  KDP_checksum|  int | True  ||
|dwh.Dim_LocalProduct|  KDP_executionId|  int | True  ||
|dwh.Dim_LocalProduct|  KDP_loadDT|  datetime | True  ||

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


Source Name: `dwh.Dim_UnitOfMeasure`
Source Type: `Table`
Source System: `DWH SQL Server`


|Table Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|dwh.Dim_UnitOfMeasure|  UnitOfMeasureCode|  nvarchar(20) | True  ||
|dwh.Dim_UnitOfMeasure|  UnitOfMeasureDescription|  nvarchar(500) | True  ||
|dwh.Dim_UnitOfMeasure|  UnitOfMeasureLongDescription|  nvarchar(500) | True  ||
|dwh.Dim_UnitOfMeasure|  ConversionToMetricTon|  decimal(18,2) | True  ||
|dwh.Dim_UnitOfMeasure|  CreatedDateTime|  datetime2(3) | True  ||
|dwh.Dim_UnitOfMeasure|  ModifiedDateTime|  datetime2(3) | True  ||
|dwh.Dim_UnitOfMeasure|  ValidationStatus|  nvarchar(50) | True  ||
|dwh.Dim_UnitOfMeasure|  KDP_SK|  bigint IDENTITY(1,1) | False||
|dwh.Dim_UnitOfMeasure|  KDP_checksum|  int | True  ||
|dwh.Dim_UnitOfMeasure|  KDP_executionId|  int | True  ||
|dwh.Dim_UnitOfMeasure|  KDP_loadDT|  datetime| True  ||
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

Target Name: `ds.mds_GL_Grouping_Trading_Order_Intake `
Target Type: `Table`
Target System: `DWH SQL Server`

|View Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|ds.mds_GL_Grouping_Trading_Order_Intake |  ID |  int | False  ||
|ds.mds_GL_Grouping_Trading_Order_Intake |  MUID |  uniqueidentifier | False ||
|ds.mds_GL_Grouping_Trading_Order_Intake |  VersionName |  nvarchar(50) | False  ||
|ds.mds_GL_Grouping_Trading_Order_Intake |  VersionNumber |  int | False ||
|ds.mds_GL_Grouping_Trading_Order_Intake |  Version_ID |  int | False  ||
|ds.mds_GL_Grouping_Trading_Order_Intake |  VersionFlag |  nvarchar(50) | False ||
|ds.mds_GL_Grouping_Trading_Order_Intake |  Name |  nvarchar(250) | False  ||
|ds.mds_GL_Grouping_Trading_Order_Intake |  Code |  nvarchar(250) | False ||
|ds.mds_GL_Grouping_Trading_Order_Intake |  ChangeTrackingMask |  int | False  ||
|ds.mds_GL_Grouping_Trading_Order_Intake |  GL Grouping Nr |  decimal(28,0) | True ||
|ds.mds_GL_Grouping_Trading_Order_Intake |  GL Grouping Name |  nvarchar(100) | True ||
|ds.mds_GL_Grouping_Trading_Order_Intake |  EnterDateTime |  datetime2(3) | True ||
|ds.mds_GL_Grouping_Trading_Order_Intake |  EnterUserName |  nvarchar(100) | True ||
|ds.mds_GL_Grouping_Trading_Order_Intake |  EnterVersionNumber |  int | True ||
|ds.mds_GL_Grouping_Trading_Order_Intake |  LastChgDateTime |  datetime2(3) | False  ||
|ds.mds_GL_Grouping_Trading_Order_Intake |  LastChgUserName |  nvarchar(100) | True ||
|ds.mds_GL_Grouping_Trading_Order_Intake |  LastChgVersionNumber |  int | True ||
|ds.mds_GL_Grouping_Trading_Order_Intake|  ValidationStatus|  nvarchar(50) | True  ||
|ds.mds_GL_Grouping_Trading_Order_Intake  |  KDP_checksum|  int | True  ||
|ds.mds_GL_Grouping_Trading_Order_Intake  |  KDP_executionId|  int | True  ||
|ds.mds_GL_Grouping_Trading_Order_Intake  |  KDP_loadDT|  datetime | True  ||
|ds.mds_GL_Grouping_Trading_Order_Intake|  KDP_DQ|  varchar(100) | True  ||
|ds.mds_GL_Grouping_Trading_Order_Intake|  KDP_CLEAN|  varchar(100) | True  ||
|ds.mds_GL_Grouping_Trading_Order_Intake|  KDP_IsBlocked|   | ||

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
Target Name: `dbo.Trading Order Intake `
Target Type: `View`
Target System: `DWH SQL Server`

|View Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|dbo.Trading Order Intake |  Invoice Key |  bigint | True  ||
|dbo.Trading Order Intake |  Company Key |  bigint | True  ||
|dbo.Trading Order Intake |  Date Closing Key|  bigint | True  ||
|dbo.Trading Order Intake |  Customer Key |  bigint | True  ||
|dbo.Trading Order Intake |  Currency Key|  bigint | True||
|dbo.Trading Order Intake |  Business Unit Key |  bigint | True  ||
|dbo.Trading Order Intake |  Business Type Key |  bigint | True  ||
|dbo.Trading Order Intake |  Destination Country Key |  bigint | True  ||
|dbo.Trading Order Intake |  Product Key|  bigint | True  ||
|dbo.Trading Order Intake |  Product Groups Key |  bigint | True  ||
|dbo.Trading Order Intake |  Product Local Key|  bigint | True  ||
|dbo.Trading Order Intake |  UOM Key |  bigint | True  ||
|dbo.Trading Order Intake |  Product Grade|  nvarchar(500) | True  ||
|dbo.Trading Order Intake |  Product Form |  nvarchar(500)  | True  ||
|dbo.Trading Order Intake |  Product Packaging Type|  nvarchar(500) | True  ||
|dbo.Trading Order Intake |  Product Packaging Size |  decimal(18,2)  | True  ||
|dbo.Trading Order Intake |  Product Packaging UOM|  nvarchar(20) | True  ||
|dbo.Trading Order Intake |  Product Quality |  decimal(18,2)| True  ||
|dbo.Trading Order Intake |  Product Packaging Type|  nvarchar(500) | True  ||
|dbo.Trading Order Intake |  Gl |  nvarchar(50) | True  ||
|dbo.Trading Order Intake |  GL Name |  nvarchar(250) | False  ||
|dbo.Trading Order Intake |  GL Grouping Nr |  decimal(28,0)| True  ||
|dbo.Trading Order Intake |  GL Grouping Name |  nvarchar(100)| True  ||
|dbo.Trading Order Intake |  Journal Transaction |  nvarchar(50)| True  ||
|dbo.Trading Order Intake |  Book Debit Amount |  decimal(38,4)| True  ||
|dbo.Trading Order Intake |  Book Credit Amount |  decimal(38,4)| True  ||
|dbo.Trading Order Intake |  Book Currency Code |  nvarchar(20)| True  ||
|dbo.Trading Order Intake |  Debit Amount |  decimal(38,4)| True  ||
|dbo.Trading Order Intake |  Credit Amount |  decimal(38,4)| True  ||
|dbo.Trading Order Intake |  Currency Code |  nvarchar(20)| True  ||
|dbo.Trading Order Intake |  Fiscal Year|  int | True  ||
|dbo.Trading Order Intake |  Fiscal Period|  int | True  ||
|dbo.Trading Order Intake |  Journal Code |  nvarchar(50)| True  ||
|dbo.Trading Order Intake |  Journal Number|  int | True  ||
|dbo.Trading Order Intake |  User  Id |  nvarchar(50)| True  ||
|dbo.Trading Order Intake |  Book |  nvarchar(50)| True  ||
|dbo.Trading Order Intake |  Company|  nvarchar(20)| True  ||
|dbo.Trading Order Intake |  Segment Value 4|  nvarchar(50)| True  ||
|dbo.Trading Order Intake |  File Nr|  nvarchar(50)| True  ||
|dbo.Trading Order Intake |  Character01|  nvarchar(50)| True  ||
|dbo.Trading Order Intake |  Country Of Origin|  nvarchar(50)| True  ||
|dbo.Trading Order Intake |  Character03|  nvarchar(50)| True  ||
|dbo.Trading Order Intake |  Customer  Id|  nvarchar(503)| True  ||
|dbo.Trading Order Intake |  Part Id|  nvarchar(50)| True  ||
|dbo.Trading Order Intake | Sales Type|  nvarchar(50)| True  ||
|dbo.Trading Order Intake |  Character07|  nvarchar(50)| True  ||
|dbo.Trading Order Intake | Uom|  nvarchar(20)| True  ||
|dbo.Trading Order Intake | Country Of Destination|  nvarchar(500)| True  ||
|dbo.Trading Order Intake | Id|  nvarchar(50)| True  ||
|dbo.Trading Order Intake | Version Nr|  nvarchar(50)| True  ||
|dbo.Trading Order Intake | Grid Nr|  nvarchar(50)| True  ||
|dbo.Trading Order Intake | Number03|  decimal(38,4)| True  ||
|dbo.Trading Order Intake | Exchange Rate |  decimal(18,2)| True  ||
|dbo.Trading Order Intake | Number05|  decimal(38,4)| True  ||
|dbo.Trading Order Intake | Volume|  decimal(38,4)| True  ||
|dbo.Trading Order Intake | Number07|  decimal(38,4)| True  ||
|dbo.Trading Order Intake | Number08|  decimal(38,4)| True  ||
|dbo.Trading Order Intake | Number09|  decimal(38,4)| True  ||
|dbo.Trading Order Intake | Number10|  decimal(38,4)| True  ||
|dbo.Trading Order Intake | Date01|  nvarchar(50)| True  ||
|dbo.Trading Order Intake | Filegridversion|  nvarchar(50)| True  ||
|dbo.Trading Order Intake | Supplier|  nvarchar(500)| True  ||
|dbo.Trading Order Intake | Freight|  nvarchar(50)| True  ||
|dbo.Trading Order Intake | Productkey|  nvarchar(50)| True  ||
|dbo.Trading Order Intake | Newfiles|  int| True  ||
|dbo.Trading Order Intake | Security Key|  | ||
|dbo.Trading Order Intake | UOM Code|  | ||
|dbo.Trading Order Intake | UOM Name|  | ||
|dbo.Trading Order Intake | KeyCombination Key|  bigint IDENTITY(1,1)| False||

    
---

## Field Mapping


| Source Table | Source Field  | Target Table  | Target Field  | Transformation Rules  | Data Type | Nullable  |
|--|--|--|--|--|--|--|
| dwh.Fact_TradingOrderIntakes| FK_Invoice|dbo.Trading Order Intake|  Invoice Key | None | bigint   |  True|
| dwh.Fact_TradingOrderIntakes| FK_Company|dbo.Trading Order Intake|  Company Key | None | bigint   |  True|
| dwh.Fact_TradingOrderIntakes| FK_ClosingDate|dbo.Trading Order Intake|  Date Closing Key | None | bigint   |  True|
| dwh.Fact_TradingOrderIntakes| FK_Customer|dbo.Trading Order Intake|  Customer Key | None | bigint   |  True|
| dwh.Fact_TradingOrderIntakes| FK_InvoiceCurrency|dbo.Trading Order Intake|  Currency Key | None | bigint   |  True|
| dwh.Fact_TradingOrderIntakes| FK_BusinessUnit|dbo.Trading Order Intake|  Business Unit Key | None | bigint   |  True|
| dwh.Fact_TradingOrderIntakes| FK_BusinessType|dbo.Trading Order Intake|  Business Type Key | None | bigint   |  True|
| dwh.Fact_TradingOrderIntakes| FK_DestinationCountry|dbo.Trading Order Intake|  Destination Country Key | None | bigint   |  True|
| dwh.Fact_TradingOrderIntakes| FK_Product|dbo.Trading Order Intake|  Product Key | None | bigint   |  True|
| dwh.Fact_TradingOrderIntakes| FK_ProductGrouping|dbo.Trading Order Intake|  Product Groups Key | None | bigint   |  True|
| dwh.Fact_TradingOrderIntakes| FK_LocalProduct|dbo.Trading Order Intake|  Product Local Key | None | bigint   |  True|
| dwh.Fact_TradingOrderIntakes| FK_UnitOfMeasure|dbo.Trading Order Intake|  UOM Key | None | bigint   |  True|
| dwh.Dim_LocalProduct| GradeDescription|dbo.Trading Order Intake|  Product Grade| COALESCE(GradeDescription, 'N/A')| nvarchar(500)|  True|
| dwh.Dim_LocalProduct| FormDescription|dbo.Trading Order Intake|  Product Form| COALESCE(FormDescription, 'N/A')| nvarchar(500)|  True|
| dwh.Dim_LocalProduct| PackagingTypeDescription|dbo.Trading Order Intake|  Product  Packaging Type| COALESCE(PackagingTypeDescription, 'N/A')| nvarchar(500)|  True|
| dwh.Dim_LocalProduct| PackagingSize|dbo.Trading Order Intake|  Product Packaging Size| COALESCE(PackagingSize, 0.00)|  decimal(18,2)|  True|
| dwh.Dim_LocalProduct| PackagingUnitOfMeasureCode|dbo.Trading Order Intake|  Product Packaging UOM| COALESCE(PackagingUnitOfMeasureCode, 'N/A')| nvarchar(20)|  True|
| dwh.Dim_LocalProduct| Quality|dbo.Trading Order Intake|  Product Quality| COALESCE(Quality, 0.00)|  decimal(18,2)|  True|
| dwh.Fact_TradingOrderIntakes| GeneralLedgerAccount|dbo.Trading Order Intake|  Gl | None | nvarchar(50)|True
| ds.mds_GL_Grouping_Trading_Order_Intake| Name|dbo.Trading Order Intake|  GL Name| None | nvarchar(250)|False  
| ds.mds_GL_Grouping_Trading_Order_Intake| GL Grouping Nr |dbo.Trading Order Intake|  GL Grouping Nr| None |  decimal(28,0)|True  
| ds.mds_GL_Grouping_Trading_Order_Intake| GL Grouping Name|dbo.Trading Order Intake|  GL Grouping Name| None | nvarchar(100)|True  
| dwh.Fact_TradingOrderIntakes| JournalTransaction|dbo.Trading Order Intake|  Journal Transaction| None | nvarchar(50)|True
| dwh.Fact_TradingOrderIntakes| BookDebitAmount|dbo.Trading Order Intake|  Book Debit Amount| None | decimal(38,4)|True
| dwh.Fact_TradingOrderIntakes| BookCreditAmount|dbo.Trading Order Intake|  Book Credit Amount| None | decimal(38,4)|True
| dwh.Dim_Currency| CurrencyCode|dbo.Trading Order Intake|  Book Currency Code| None | nvarchar(20)|True
| dwh.Fact_TradingOrderIntakes| DebitAmount|dbo.Trading Order Intake|  Debit Amount| None | decimal(38,4)|True
| dwh.Fact_TradingOrderIntakes| CreditAmount|dbo.Trading Order Intake|  Credit Amount| None | decimal(38,4)|True
| dwh.Dim_Currency| CurrencyCode|dbo.Trading Order Intake|  Currency Code| None | nvarchar(20)|True
| dwh.Fact_TradingOrderIntakes| FiscalYear|dbo.Trading Order Intake|  Fiscal Year| None | int |True
| dwh.Fact_TradingOrderIntakes| FiscalPeriod|dbo.Trading Order Intake|  Fiscal Period| None | int |True
| dwh.Fact_TradingOrderIntakes| JournalCode|dbo.Trading Order Intake|  Journal Code| None |  nvarchar(50)|True
| dwh.Fact_TradingOrderIntakes| JournalNumber|dbo.Trading Order Intake| Journal Number| None | int |True
| dwh.Fact_TradingOrderIntakes| UserID|dbo.Trading Order Intake|  User Id| None |  nvarchar(50)|True
| dwh.Fact_TradingOrderIntakes| GeneralLedgerBook|dbo.Trading Order Intake|  Book| None |  nvarchar(50)|True
| dwh.Dim_Company| CompanyCode|dbo.Trading Order Intake|  Company| None |  nvarchar(20)|True
| dwh.Fact_TradingOrderIntakes| SegmentValue4|dbo.Trading Order Intake|  Segment Value 4| None |  nvarchar(50)|True
| dwh.Fact_TradingOrderIntakes| FileNumber|dbo.Trading Order Intake|  File Nr| None |  nvarchar(50)|True
| dwh.Fact_TradingOrderIntakes| Character01|dbo.Trading Order Intake|  Character 01| None |  nvarchar(50)|True
| dwh.Fact_TradingOrderIntakes| OriginCountry|dbo.Trading Order Intake|  Country Of Origin| None |  nvarchar(50)|True
| dwh.Fact_TradingOrderIntakes| Character03|dbo.Trading Order Intake|  Character 03| None |  nvarchar(50)|True
| dwh.Dim_Customer| CustomerCode|dbo.Trading Order Intake|  Customer Id| None |  nvarchar(503)|True
| dwh.Fact_TradingOrderIntakes| PartID|dbo.Trading Order Intake|  Part ID| None |  nvarchar(50)|True
| dwh.Fact_TradingOrderIntakes| SalesType|dbo.Trading Order Intake|  Sales Type| None |  nvarchar(50)|True
| dwh.Fact_TradingOrderIntakes| PartID|dbo.Trading Order Intake|  Part ID| None |  nvarchar(50)|True
| dwh.Fact_TradingOrderIntakes| Character07|dbo.Trading Order Intake|  Character 07| None |  nvarchar(50)|True
| dwh.Dim_UnitOfMeasure| UnitOfMeasureCode|dbo.Trading Order Intake| Uom| None |  nvarchar(20)|True
| dwh.Dim_Country| CountryName|dbo.Trading Order Intake|  Country Of Destination| None |  nvarchar(500)|True
| dwh.Fact_TradingOrderIntakes| TradingOrderIntakeID|dbo.Trading Order Intake|  Id| None |  nvarchar(50)|True
| dwh.Fact_TradingOrderIntakes| VersionNumber|dbo.Trading Order Intake|  Version Nr| None |  nvarchar(50)|True
| dwh.Fact_TradingOrderIntakes| GridNumber|dbo.Trading Order Intake|  Grid Nr| None |  nvarchar(50)|True
| dwh.Fact_TradingOrderIntakes| Number03|dbo.Trading Order Intake|  Number03| TRY_CONVERT(DECIMAL(38,4),TRY_CONVERT(FLOAT,REPLACE(NULLIF(Number03,''),',','.')))|  decimal(38,4)|True
| dwh.Fact_TradingOrderIntakes| ExchangeRate|dbo.Trading Order Intake|  Exchange Rate| None |  decimal(18,2)|True
| dwh.Fact_TradingOrderIntakes| Number05|dbo.Trading Order Intake|  Number05| TRY_CONVERT(DECIMAL(38,4),TRY_CONVERT(FLOAT,REPLACE(NULLIF(Number05,''),',','.')))|  decimal(38,4)|True
| dwh.Fact_TradingOrderIntakes| VOLUME|dbo.Trading Order Intake|  Volume | TRY_CONVERT(DECIMAL(38,4),TRY_CONVERT(FLOAT,REPLACE(NULLIF(VOLUME,''),',','.')))|  decimal(38,4)|True
| dwh.Fact_TradingOrderIntakes| Number07|dbo.Trading Order Intake|  Number07| TRY_CONVERT(DECIMAL(38,4),TRY_CONVERT(FLOAT,REPLACE(NULLIF(Number07,''),',','.')))|  decimal(38,4)|True
| dwh.Fact_TradingOrderIntakes| Number08|dbo.Trading Order Intake|  Number08| TRY_CONVERT(DECIMAL(38,4),TRY_CONVERT(FLOAT,REPLACE(NULLIF(Number08,''),',','.')))|  decimal(38,4)|True
| dwh.Fact_TradingOrderIntakes| Number09|dbo.Trading Order Intake|  Number09| TRY_CONVERT(DECIMAL(38,4),TRY_CONVERT(FLOAT,REPLACE(NULLIF(Number09,''),',','.')))|  decimal(38,4)|True
| dwh.Fact_TradingOrderIntakes| Number10|dbo.Trading Order Intake|  Number10| TRY_CONVERT(DECIMAL(38,4),TRY_CONVERT(FLOAT,REPLACE(NULLIF(Number10,''),',','.')))|  decimal(38,4)|True
| dwh.Fact_TradingOrderIntakes| Date01|dbo.Trading Order Intake|  Date01| None |  nvarchar(50)|True
| dwh.Fact_TradingOrderIntakes| FileGridVersion|dbo.Trading Order Intake|  Filegridversion| None |  nvarchar(50)|True
| dwh.Dim_BusinessPartner| BusinessPartnerCode|dbo.Trading Order Intake|  Supplier| None |  nvarchar(500)|True
| dwh.Fact_TradingOrderIntakes| Freight|dbo.Trading Order Intake|  Freight| None |  nvarchar(50)|True
| dwh.Fact_TradingOrderIntakes| OriginalProductCode|dbo.Trading Order Intake|  Productkey| None |  nvarchar(50)|True
| dwh.Fact_TradingOrderIntakes| IsNewFile|dbo.Trading Order Intake|  Newfiles| None |  int|True
| dwh.Fact_TradingOrderIntakes| FK_BusinessType, FK_BusinessUnit, FK_Company, FK_Customer  |dbo.Trading Order Intake|  Security Key| CONCAT_WS('-', FK_BusinessType, FK_BusinessUnit, FK_Company, FK_Customer)|  |
| | |dbo.Trading Order Intake|  UOM Code| Added column with 'N/A' as value|  |
| | |dbo.Trading Order Intake|  UOM Name| Added column with 'N/A' as value|  |
| dwh.Sec_KeyCombinations| KDP_SK |dbo.Trading Order Intake|  KeyCombination Key| None |  bigint IDENTITY(1,1)|True


---


## Transformation Rules

### Column Specific Transformation
1. Product Grade
`COALESCE(GradeDescription, 'N/A')`

2. Product Form
`COALESCE(FormDescription, 'N/A')`

3. Product Packaging Type
`COALESCE(PackagingTypeDescription, 'N/A')`

4. Product Packaging Size
`COALESCE(PackagingSize, 0.00)`

5. Product Packaging UOM
`COALESCE(PackagingUnitOfMeasureCode, 'N/A')`

6. Product Quality
`COALESCE(Quality, 0.00)`


7. Number03
`TRY_CONVERT(DECIMAL(38,4),TRY_CONVERT(FLOAT,REPLACE(NULLIF(Number03,''),',','.')))`

8. Number05
`TRY_CONVERT(DECIMAL(38,4),TRY_CONVERT(FLOAT,REPLACE(NULLIF(Number05,''),',','.')))`

9. Volume 
`TRY_CONVERT(DECIMAL(38,4),TRY_CONVERT(FLOAT,REPLACE(NULLIF(VOLUME,''),',','.')))`

10. Number07
`TRY_CONVERT(DECIMAL(38,4),TRY_CONVERT(FLOAT,REPLACE(NULLIF(Number07,''),',','.')))`

11. Number08
`TRY_CONVERT(DECIMAL(38,4),TRY_CONVERT(FLOAT,REPLACE(NULLIF(Number08,''),',','.')))`

12. Number09
`TRY_CONVERT(DECIMAL(38,4),TRY_CONVERT(FLOAT,REPLACE(NULLIF(Number09,''),',','.')))`

13. Number10
`TRY_CONVERT(DECIMAL(38,4),TRY_CONVERT(FLOAT,REPLACE(NULLIF(Number10,''),',','.')))`

14. Security Key
`CONCAT_WS('-', FK_BusinessType, FK_BusinessUnit, FK_Company, FK_Customer)`


### Joins `dwh.Fact_TradingOrderIntakes f`

1. dwh.Dim_LocalProduct lp
`LEFT JOIN [dwh].[Dim_LocalProduct] lp ON f.[FK_LocalProduct] = lp.[KDP_SK]`

2. dwh.Dim_Currency bcur
`LEFT JOIN [dwh].[Dim_Currency] bcur ON f.[FK_BookCurrency] = bcur.[KDP_SK]`

3. dwh.Dim_Currency hcur
`LEFT JOIN [dwh].[Dim_Currency] hcur ON f.[FK_HomeCurrency] = hcur.[KDP_SK]`

4. dwh.Dim_Company co
`LEFT JOIN [dwh].[Dim_Company] co ON f.[FK_Company] = co.[KDP_SK]`

5. dwh.Dim_Customer
`LEFT JOIN [dwh].[Dim_Customer] cu ON f.[FK_Customer] = cu.[KDP_SK]`

6. dwh.Dim_Country
`LEFT join dwh.dim_country ctr on ctr.countrycode = cu.countrycode`

7. dwh.Dim_UnitOfMeasure
`LEFT JOIN [dwh].[Dim_UnitOfMeasure] uom	ON f.[FK_UnitOfMeasure] = uom.[KDP_SK]`

8. dwh.Dim_Country dc
`LEFT JOIN [dwh].[Dim_Country] dc ON f.[FK_DestinationCountry] = dc.[KDP_SK]`

9. dwh.Dim_BusinessPartner bp
`LEFT JOIN [dwh].[Dim_BusinessPartner] bp ON f.[FK_BusinessPartner] = bp.[KDP_SK]`

10. ds.mds_GL_Grouping_Trading_Order_Intake gl
`LEFT JOIN ds.mds_GL_Grouping_Trading_Order_Intake gl ON f.[GeneralLedgerAccount] = gl.Code`

11. dwh.Sec_KeyCombinations KC	
`LEFT JOIN	dwh.Sec_KeyCombinations	AS KC ON  
                f.[FK_BusinessType] = KC.FK_BusinessType 
                AND f.[FK_Company] = KC.FK_Company 
                AND ctr.KDP_SK = KC.FK_CustomerCountry
                AND f.[FK_BusinessUnit] = KC.FK_BusinessUnit`

12. `where left(f.[FK_ClosingDate],4) in (year(GETDATE())-2,year(GETDATE())-1,year(GETDATE()))`



---
### [Return to Fact Tables](/Archive/Data-Lineage/Fact-Tables)