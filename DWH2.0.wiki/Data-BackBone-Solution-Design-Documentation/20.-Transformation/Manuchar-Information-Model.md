Manuchar Information Model
==========================

Introduction
------------

The **Manuchar Information Model** is a **conceptual data model** designed to structure data processes efficiently, with an initial focus on Commercial reporting initiatives. Primarlity built on **Dynamics 365 Finance & Operations (D365FO)** principles, it provides a logical framework for organizing **transactional data** (business events) and **master data** (static reference entities). This model supports **sales, procurement, finance, logistics, and product management**, ensuring a standardized, scalable, and well-structured data architecture.
The model is organized into **logical groupings** to simplify data interactions, integrations, and reporting. Each group contains **transactional entities** (events such as orders, invoices, and shipments) and **conceptual entities** (reference data like customers, products, and locations).

* * *

Determining Entities vs. Attributes
-----------------------------------

When defining the structure of this conceptual model, we apply specific rules to decide whether a concept should be modeled as a separate **entity** or as an **attribute** of another entity.

### **When to Model as an Entity:**

*   The concept is referenced by multiple entities and needs to maintain consistency
    
*   It has multiple attributes or requires further classification
    
*   It can exist independently and needs to be managed separately
    

### **When to Model as an Attribute:**

*   The value is only relevant within the context of a single entity
    
*   It has a limited, predefined set of possible values
    
*   It does not need separate tracking or detailed relationships with other entities
    
For example, **Version** was initially considered as a separate entity but was later modeled as an attribute of **LedgerTransaction** since it only provides versioning information and does not have additional attributes that require separate management. In contrast, **LedgerTransactionLine** remains an entity because it represents detailed financial movements linked to LedgerTransactions.

* * *

Entity Types and Logical Groups
-------------------------------

Entities in the **Manuchar Information Model** are categorized into **logical groups**, each aligning with a key business function.

### **1. Sales & Order Management** (Customer Interactions and Transactions)

> This group manages customer-related transactions, from initial order placement to invoicing and payments.

**Transactional Entities:**
*   **Order** - Represents a customer order.
*   **OrderLine** - Individual items within an order.
*   **Sales** - A confirmed commercial transaction.
*   **SalesLine** - Items included in a sales transaction.
*   **Invoice** - A billing document issued to a customer.
*   **InvoiceLine** - Individual line items in an invoice.
*   **Payment** - Financial transaction linked to an invoice.
*   **ReturnOrder** - Captures customer product returns.

**Conceptual Entities:**
*   **Customer** - Represents the buyer (company or individual).
*   **SalesTeam** - A group of sales representatives working together to achieve sales targets.

* * *

### **2. Logistics & Supply Chain** (Stock, Shipments, and Warehousing)

> Tracks product movements, inventory status, and physical storage locations.

**Transactional Entities:**

*   **StockMovement** - Any inventory movement (inbound, outbound, adjustments).
*   **Shipment** - Represents the physical movement of goods.
*   **ShipmentLine** - Line items within a shipment.

**Conceptual Entities:**
*   **Stock** - Represents the inventory available across all storage locations, including current stock levels, reserved quantities, and available stock for order fulfillment.
*   **Warehouse** - Physical storage facility.
*   **Site** - High-level storage location grouping.
*   **Location** - Subdivision within a warehouse.
*   **Port** - Represents a maritime or inland port used for shipments.
*   **Vessel** - Represents a (shipping) vessel used for transporting goods.
*   **IncoTerm** - Selling & Buying terms that the seller and buyer of goods both agree on during international transactions.

* * *

### **3. Procurement & Vendor Management** (Supplier Interactions and Purchasing)

> Manages supplier transactions and procurement operations.

**Transactional Entities:**
*   **PurchaseOrder** - A procurement order placed with a supplier.
*   **PurchaseOrderLine** - Items within a purchase order.
*   **PurchaseInvoice** - A billing document received from a supplier for delivered goods or services.
    
*   **PurchaseInvoiceLine** - Individual line items in a purchase invoice.

**Conceptual Entities:**
*   **Supplier** - Business entity providing goods/services.

* * *

### **4. Product & Pricing** (Commercial Offerings and Pricing Structures)

> Maintains data on products, pricing structures, and unit measurements.

**Conceptual Entities:**
*   **Product** - Represents goods or services.
*   **ProductCategory** - Categorization of products.
*   **UnitOfMeasure** - Defines measurement units (kg, pcs, liters, etc.).
*   **PriceList** - Defines pricing rules per customer segment.
*   **DiscountScheme** - Structured discount mechanisms.

* * *

### **5. Finance & Accounting** (Financial Transactions and Reporting)

> Supports financial tracking, ledger entries, and cost allocations.

**Transactional Entities:**
*   **LedgerTransaction** - Represents an accounting record.
*   **LedgerTransactionLine** - Represents individual line items within a ledger transaction, detailing specific accounts, amounts, and descriptions.
*   **Transaction** - Customer and vendor financial movements.
*   **ConsolidatedAmount** - Aggregated financial figures.

**Conceptual Entities:**
*   **AccountHeader** - Represents the grouping of related general ledger accounts for high-level financial structuring.
*   **Account** - Represents general ledger accounts.
*   **TaxCode** - Tax structures applied to transactions.
*   **Currency** - Different currency types.
*   **PaymentTerm** - Defines agreed payment conditions.
*   **CostCenter** - Allocation of costs to different departments.
*   **ConsolidationPeriod** - Period used for financial reporting.

* * *

### **6. Organizational Structure** (Company and Workforce Management)

> Defines internal business structure and key organizational entities.

**Conceptual Entities:**
*   **BusinessUnit** - Subdivision within the company.
*   **Employee** - Staff members involved in transactions.
*   **Company** - Legal business entity.
*   **Industry** - Industry classification of customers or suppliers.

* * *

### **7. Geographic & Demographic Classification** (Segmentation and Regions)

> Supports regional classification for reporting and analysis.

**Conceptual Entities:**
*   **AgeGroup** - Customer demographic segmentation.
*   **Country** - National-level classification.

* * *

Naming Conventions
------------------

To maintain consistency across the model, the following **naming conventions** apply:
*   **Camel Case** for entity names (e.g., `OrderLine`, `StockMovement`).
*   **Singular names** for all entities (e.g., `Invoice`, not `Invoices`).
*   **Consistent prefixes** for related entities (e.g., `Sales` and `SalesLine`).
*   **Technical and physical** table names will follow the appropriate development guidelines, such as snake case for all transformation efforts in the Data Vault (e.g., `bv_order_line`, `rv_sales_dynamics`).

* * *

Relationships Between Logical Groups
------------------------------------

The **Finance & Accounting** group serves as the core connector between all other logical groups, ensuring financial reconciliation and reporting align with operational activities.
*   **Sales & Order Management ↔ Finance & Accounting**: Customer transactions (orders, invoices, payments) generate financial postings in **Transactions** (`custTrans`) and **LedgerTransaction**.
*   **Procurement & Vendor Management ↔ Finance & Accounting**: Vendor purchases and payments flow into **Transactions** (`vendTrans`), impacting the general ledger.
*   **Logistics & Supply Chain ↔ Finance & Accounting**: Inventory movements recorded in **StockMovement** affect financial valuation and cost allocations.
*   **Product & Pricing ↔ Sales & Procurement**: Products and pricing influence order creation and procurement decisions.
*   **Organizational Structure & Geographic Classification**: These provide contextual data that influence all transactional activities, ensuring compliance and structured reporting.
Key financial integration points:
*   **Transactions (`custTrans` & `vendTrans`)** track financial movements and connect to:
    *   **Invoices (`custInvoiceJour`)** via `voucher`
    *   **Journal Entries (`generalJournalEntry`)** via `subLedgerVoucher`
*   **Invoices link to Orders and Sales**, ensuring revenue tracking aligns with business operations.
*   **Payments reconcile invoices and transactions**, maintaining financial accuracy.
*   **StockMovements impact inventory valuation**, ensuring logistics and financial systems remain synchronized.
By integrating **operational and financial data**, the model ensures consistency between **sales, procurement, logistics, and finance**, supporting accurate financial statements and commercial reporting.