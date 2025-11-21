---
# Customers Mapping
---

## Introduction

Customers is based on a SQL View in DWH called **dbo.Customers** which will be the _Target_ and it is derived from **dwh.Dim_Customer** with a left outer join on table **ds.TCUPBIDynamicsDimCustomer** which will be the _Source_.

---

## Data Lineage

::: mermaid
 graph LR;
 A[dwh.Dim_Customer LEFT OUTER JOIN ds.TCUPBIDynamicsDimCustomer] --> B[dbo.Customers] -->  C[Customers];
:::
---

## Source Details
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


Second Source Name: ` ds.TCUPBIDynamicsDimCustomer`
Source Type: `Table`
Source System: `DWH SQL Server`

|Table Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|ds.TCUPBIDynamicsDimCustomer|  CustomerCode |  nvarchar(503) | True||
|ds.TCUPBIDynamicsDimCustomer|  CustomerName|  nvarchar(1000) | True  ||
|ds.TCUPBIDynamicsDimCustomer|  Cust Group ID|  nvarchar(1000) | True  ||
|ds.TCUPBIDynamicsDimCustomer|  LegalNumber|  nvarchar(1000) | True  ||
|ds.TCUPBIDynamicsDimCustomer|  CountryCode|  nvarchar(250) | True  ||
|ds.TCUPBIDynamicsDimCustomer|  CountryName|  nvarchar(500) | True  ||
|ds.TCUPBIDynamicsDimCustomer|  CommercialRegionName|  nvarchar(500) | True ||
|ds.TCUPBIDynamicsDimCustomer|  Address|  nvarchar(1000) | True  ||
|ds.TCUPBIDynamicsDimCustomer|  ZIPCode|  nvarchar(1000) | True  ||
|ds.TCUPBIDynamicsDimCustomer|  City|  nvarchar(1000) | True  ||
|ds.TCUPBIDynamicsDimCustomer|  CurrencyCode|  nvarchar(1000) | True  ||
|ds.TCUPBIDynamicsDimCustomer|  MultinationalCustomerCode|  nvarchar(500) | True  ||
|ds.TCUPBIDynamicsDimCustomer|  MultinationalCustomerName|  nvarchar(500) | True  ||
|ds.TCUPBIDynamicsDimCustomer|  MultinationalLegalNumber|  nvarchar(250) | True  ||
|ds.TCUPBIDynamicsDimCustomer|  MultinationalCountryCode|  nvarchar(250) | True  ||
|ds.TCUPBIDynamicsDimCustomer|  MultinationalCountryName|  nvarchar(500) | True  ||
|ds.TCUPBIDynamicsDimCustomer|  AffiliateCode|  int | True  ||
|ds.TCUPBIDynamicsDimCustomer|  AffiliateDescription|  nvarchar(500) | True  ||
|ds.TCUPBIDynamicsDimCustomer|  IsAffiliate|  bit | True  ||
|ds.TCUPBIDynamicsDimCustomer|  CustomerGroupCode|  nvarchar(1000) | True  ||
|ds.TCUPBIDynamicsDimCustomer|  IndustryTypeCode|  nvarchar(1000) | True  ||
|ds.TCUPBIDynamicsDimCustomer|  IndustryTypeDescription|  nvarchar(500) | True  ||
|ds.TCUPBIDynamicsDimCustomer|  MNCParentCode|  nvarchar(20) | True  ||
|ds.TCUPBIDynamicsDimCustomer|  MNCParentName|  nvarchar(500) | True  ||
|ds.TCUPBIDynamicsDimCustomer|  CreatedDateTime|  datetime2(7) | True  ||
|ds.TCUPBIDynamicsDimCustomer|  ModifiedDateTime|  datetime2(7) | True  ||
|ds.TCUPBIDynamicsDimCustomer|  ValidationStatus|  nvarchar(50) | True  ||
|ds.TCUPBIDynamicsDimCustomer|  Hist_LoadDT|  datetimeoffset(3) | True  ||

---

## Target Details
Target Name: `dbo.Customers`
Target Type: `View`
Target System: `DWH SQL Server`

|View Name| Column Name| Data Type  |  Nullable | Description   |
|--|--|--|--|--|
|dbo.Customers|  Customer Key |  bigint IDENTITY(1,1) | False  ||
|dbo.Customers|  Customer GK |   | ||
|dbo.Customers|  Customer Legal Number|  nvarchar(50) |True ||
|dbo.Customers|  Customer Name|  nvarchar(500) | True  ||
|dbo.Customers| Customer  Address|  nvarchar(500) | True  ||
|dbo.Customers|  Customer  City|  nvarchar(500) | True  ||
|dbo.Customers|  Customer  ZIP Code|  nvarchar(20) | True  ||
|dbo.Customers|  Customer  Country Code|  nvarchar(20) | True  ||
|dbo.Customers|  Customer  Country Name|  nvarchar(500) | True  ||
|dbo.Customers|  Customer Commercial Region|  nvarchar(500) | True  ||
|dbo.Customers|  Customer Affiliate? |   | ||
|dbo.Customers|  Customer Currency Code|  nvarchar(20) | True  ||
|dbo.Customers|  Multinational Legal Number|  nvarchar(50) | True  ||
|dbo.Customers|  Multinational Name|  nvarchar(500) | True  ||
|dbo.Customers|  Multinational Country Name|  nvarchar(500) | True  ||
|dbo.Customers|  Customer Type |   | ||
|dbo.Customers|  Customer Industry Type|  nvarchar(500) | True  ||
|dbo.Customers|  Customer Category|  nvarchar(1000) | True  ||
|dbo.Customers|  Customer Group Name|  nvarchar(1000) | True  ||
|dbo.Customers|  Customer Group Code|  nvarchar(1000) | True  ||
|dbo.Customers|  Customer Code |  nvarchar(503) | False||

---

## Field Mapping


| Source Table | Source Field  | Target Table  | Target Field  | Transformation Rules  | Data Type | Nullable  |
|--|--|--|--|--|--|--|
| dwh.Dim_Customer| KDP_SK  |dbo.Customers|  Customer Key | None | bigint IDENTITY(1,1)  |  False|
| dwh.Dim_Customer| CountryCode, LegalNumber | dbo.Customers|  Currency GK | CountryCode + ' - ' + LegalNumber |  |  True|
| dwh.Dim_Customer| LegalNumber| dbo.Customers| Customer Legal Number | None| nvarchar(50)  |  True|
| dwh.Dim_Customer| CustomerName| dbo.Customers| Customer Name| None| nvarchar(500)  |  True|
| dwh.Dim_Customer| Address| dbo.Customers| Customer Address| COALESCE(Address, '')| nvarchar(500)  |  True|
| dwh.Dim_Customer| City| dbo.Customers| Customer City| COALESCE(City, '')| nvarchar(500)  |  True|
| dwh.Dim_Customer| ZIPCode| dbo.Customers| Customer ZIP Code| COALESCE(ZIPCode, '')| nvarchar(20)  |  True|
| dwh.Dim_Customer| CountryCode| dbo.Customers| Customer Country Code| None | nvarchar(20)  |  True|
| dwh.Dim_Customer| CountryName| dbo.Customers| Customer Country Name| None | nvarchar(500)  |  True|
| dwh.Dim_Customer| CommercialRegionName| dbo.Customers| Customer Commercial Region| None | nvarchar(500)  |  True|
| dwh.Dim_Customer| IsAffiliate| dbo.Customers| Customer Affiliate?| WHEN IsAffiliate = 1 THEN 'AFFILIATE', ELSE 'NON AFFILIATE'|   |  |
| dwh.Dim_Customer| CurrencyCode | dbo.Customers| Customer Currency Code| COALESCE(CurrencyCode, 'Unknown')| nvarchar(20)  |  True|
| dwh.Dim_Customer| MultinationalLegalNumber| dbo.Customers| Multinational Legal Number| COALESCE(MultinationalLegalNumber, '')| nvarchar(50)  |  True|
| dwh.Dim_Customer| MultinationalCustomerName| dbo.Customers| Multinational Name| COALESCE(MultinationalCustomerName, '')| nvarchar(500)  |  True|
| dwh.Dim_Customer| MultinationalCountryName| dbo.Customers| Multinational Country Name| COALESCE(MultinationalCountryName, '')| nvarchar(500)  |  True|
| dwh.Dim_Customer| IsAffiliate| dbo.Customers| Customer Type| WHEN IsAffiliate = 1 THEN 'Intercompany', ELSE 'Third Party'|   |  |
| dwh.Dim_Customer| IndustryTypeDescription| dbo.Customers| Customer Industry Type| COALESCE(IndustryTypeDescription, '')| nvarchar(500)  |  True|
| ds.TCUPBIDynamicsDimCustomer| CustomerGroupCode | dbo.Customers| Customer Category|None| nvarchar(1000)  |  True|
| ds.TCUPBIDynamicsDimCustomer| CustomerName| dbo.Customers| Customer Group Name|None| nvarchar(1000)  |  True|
| ds.TCUPBIDynamicsDimCustomer| Cust Group ID| dbo.Customers| Customer Group Code|None| nvarchar(1000)  |  True|
| dwh.Dim_Customer| CustomerCode | dbo.Customers| Customer Code| None | nvarchar(503)  |  True|


---

## Transformation Rules
1. dwh.Dim_Customer with LEFT OUTER JOIN ds.TCUPBIDynamicsDimCustomer on CustomerCode
`FROM [dwh].[Dim_Customer] DC LEFT OUTER JOIN `
`(SELECT DCC.CustomerCode, DCC.CustomerName, DCC.LegalNumber, DCM.CustomerName, DCC.[Cust Group ID], DCC.CustomerGroupCode`
`FROM [ds].[TCUPBIDynamicsDimCustomer] DCM LEFT OUTER JOIN [ds].[TCUPBIDynamicsDimCustomer] DCC`
`ON DCM.CustomerCode = DCC.[Cust Group ID]) DDC`
`ON DC.[customerCode] = DDC.CustomerCode`
`WHERE DC.[ValidationStatus] = 'Validation Succeeded' OR DC.[KDP_SK] = -1`

2. Customer GK
`CountryCode + ' - ' + LegalNumber`

3. Customer Address
`COALESCE(Address '')`

4. Customer City
`COALESCE(City, '')`

5. Customer ZIP Code
`COALESCE(ZIPCode, '')`

6. Customer Affiliate?
`WHEN IsAffiliate = 1`
`THEN 'AFFILIATE'`
`ELSE 'NON AFFILIATE'`

7. Customer Currency Code
`COALESCE(CurrencyCode, 'Unknown')`

8.  Multinational Legal Number
`COALESCE(MultinationalLegalNumber, '')`


9.  Multinational Name
`COALESCE(MultinationalCustomerName, '')`


10.  Multinational Country Name
`COALESCE(MultinationalCountryName, '')`


11. Customer Type
`WHEN IsAffiliate = 1`
`THEN 'Intercompany'`
`ELSE 'Third Party'`

12. Customer industry Type
`NULLIF(IndustryTypeDescription, '')`
---
### [Return to Dimension Tables](/Archive/Data-Lineage/Dimension-Tables)