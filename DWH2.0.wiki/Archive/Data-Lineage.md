---

# Data Lineage
---

## Introduction


**_Purpose_**: This document provides an overview of the data lineage of our data warehouse to the PowerBI reports.

---
## Data Source
_**Source System:**_ Data Warehouse `be-sql-dataplatform-p.database.windows.net`

---

## Tables

In our reports, we utilize the following **facts** and **dimensions** tables:

1. **[Fact Tables](/Archive/Data-Lineage/Fact-Tables)**:
These store measurable data such as sales amounts and transaction counts. They include metrics and foreign keys to dimension tables.

- [Accounts Receivables (AR)](/Archive/Data-Lineage/Fact-Tables/Accounts-Receivables)  `dbo.Accounts Receivables`
- [Accounts Payables (AP)](/Archive/Data-Lineage/Fact-Tables/Accounts-Payables ) `dbo.Accounts Payables`
- [Sales](/Archive/Data-Lineage/Fact-Tables/Sales)  `dbo.Sales`
- [Stock](/Archive/Data-Lineage/Fact-Tables/Stock) `dbo.Stock`
- [Stock Rotation](/Archive/Data-Lineage/Fact-Tables/Stock-Rotation) `dbo.Stock Rotation`
- [Exchange Rates](/Archive/Data-Lineage/Fact-Tables/Exchange-Rates) `dbo.Exchange Rates`
- [Trading Order Intake](/Archive/Data-Lineage/Fact-Tables/Trading-Order-Intake) `dbo.Trading Order Intake`



---

2. **[Dimension Tables](/Archive/Data-Lineage/Dimension-Tables)**: 
These provide descriptive context to the facts, containing attributes like time, product details, customer information, and geographical data.

- [Age Groups](/Archive/Data-Lineage/Dimension-Tables/Age-Groups) `dbo.Age Groups`
- [Business Partner](/Archive/Data-Lineage/Dimension-Tables/Business-Partner) `dbo.Business Partner`
- [Business Units](/Archive/Data-Lineage/Dimension-Tables/Business-Units) `dbo.Business Units`
- [Business Type](/Archive/Data-Lineage/Dimension-Tables/Business-Type) `dbo.Business Type`
- [Companies](/Archive/Data-Lineage/Dimension-Tables/Companies) `dbo.Companies`
- [Countries](/Archive/Data-Lineage/Dimension-Tables/Countries) `dbo.Countries`
- [Currencies](/Archive/Data-Lineage/Dimension-Tables/Currencies) `dbo.Currencies`
- [Customers](/Archive/Data-Lineage/Dimension-Tables/Customers) `dbo.Customers`
- [Industry](/Archive/Data-Lineage/Dimension-Tables/Industry) `dbo.Industry`
- [Invoices](/Archive/Data-Lineage/Dimension-Tables/Invoices) `dbo.Invoices`
- [Products](/Archive/Data-Lineage/Dimension-Tables/Products) `dbo.Products`
- [Product Groups](/Archive/Data-Lineage/Dimension-Tables/Product-Groups) `dbo.Product Groups`
- [Products Local](/Archive/Data-Lineage/Dimension-Tables/Products-Local) `dbo.Products Local`


Together, these tables enable comprehensive and detailed data analysis in a structured format.

---

## Data Consumption

**Reporting System**: Power BI 

---

## Contact Person
Front-End Developer:
Back-End Developer:


---

## Resources
---



