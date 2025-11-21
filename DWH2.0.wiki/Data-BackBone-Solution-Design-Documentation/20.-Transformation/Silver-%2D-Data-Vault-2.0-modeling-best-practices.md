**General approach**

**Data Vault 2.0** is a data modeling methodology designed for scalable, flexible, and audit-friendly enterprise data model that can be stored in your data lakehouse. It is based on the following core principles:
1.  **Separation of Concerns**:
    *   Store business keys and relationships in **Hubs** and **Links**.
    *   Store context (attributes, history) in **Satellites**.
2.  **Historical Tracking**:
    *   **Satellites** enable tracking changes over time for auditability and temporal analysis.
3.  **Scalability and Parallelization**:
    *   The modular structure allows for scaling and loading in parallel, supporting large-scale systems.
4.  **Flexibility and Agility**:
    *   The decoupled design allows easy adjustments to changing business requirements.
5.  **Auditability**:
    *   Metadata in all tables ensures traceability of data back to its source.

The **Raw Vault** and **Business Vault** are two distinct layers in the Data Vault 2.0 architecture. They serve different purposes and are designed to address specific needs in the data warehousing lifecycle.

**Raw Vault**

The **Raw Vault** is the foundational layer of the Data Vault, storing raw, unaltered data from source systems in its most granular form. It focuses on auditability, capturing all historical changes over time with metadata to trace data back to its origin. This layer uses Hubs, Links, and Satellites to organize data and employs minimal transformations during loading, ensuring flexibility and scalability to handle schema changes and high-volume data.

The model of the Raw Vault is structured around _three core components_ and a few derivatives of these generic types:

*  **Hubs**:
    *   Central tables representing unique business entities (e.g., `Customer`, `Product`).
    *   Contain a unique identifier (business key) and metadata like load timestamp and source system.
*  **Links**:
    *   Relationship tables connecting hubs (e.g., `Customer_Purchase` links `Customer` to `Transaction`).
    *   Contain the foreign keys of the related hubs and metadata.
*  **Satellites**:
    *   Descriptive attributes and historical changes linked to hubs or links (e.g., customer names, purchase details).
    *   Provide flexibility by decoupling changes from the core structure.
*  **Link Satellites (LSATs)**:
    *   A specialized type of satellite attached to a **Link** rather than a hub.
    *   Store descriptive attributes that are specific to the relationship between the linked hubs (for example, the payment method used for a specific customer-transaction pair or a discount applied in a sales relationship).
    *   Track historical changes to relationship-specific data, ensuring auditability and lineage for those attributes.
    *   Enhance flexibility by separating these attributes from both the hubs and the link table, making the data model more modular and scalable.

**Business Vault**

The **Business Vault** builds on the Raw Vault by enriching and transforming data to make it business-ready. It applies business rules, integrates data from multiple sources, and includes derived tables like Point-in-Time (PIT) and Bridge tables. Designed for analytics and reporting, it improves performance and usability by preparing pre-computed datasets that align with business needs, enabling faster and more meaningful insights.

The model of the Business Vault is structured around following core components:

*   **Bridge Tables**:
    *   Precomputed tables that flatten many-to-many relationships for easier querying.
    *   Optimize performance by reducing the complexity of joins between hubs, links, and satellites.
    *   Commonly used for analytics and reporting purposes where direct relationships or rollups are needed.
*   **Point-in-Time (PIT) Tables**:
    *   Snapshot tables that join multiple hubs and satellites to provide the state of data at a specific point in time.
    *   Used for simplifying queries requiring historical alignment of data, ensuring consistency in reporting.
    *   Especially useful for ensuring consistent joins between historical records in different tables.

### Best practices when implementing Data Vault 2.0

When implementing Data Vault 2.0, it is essential to follow best practices to ensure a robust and scalable data model. **Focus on business keys** by using stable, unique identifiers as anchors for hubs, ensuring consistency across the entire model. The model should **decouple data** by keeping entities (hubs), relationships (links), and descriptive attributes (satellites) separate. This separation enhances flexibility and scalability, making it easier to adapt to changes.

**Optimize loading** with incremental loading patterns to handle large-scale data ingestion efficiently while minimizing processing time. It's crucial to **maintain historical tracking** by capturing all changes with timestamps and source identifiers, ensuring full auditability and compliance. Incorporating **metadata-driven design** is another key best practice, enabling pipelines to dynamically adapt to schema changes and enhancing transparency through lineage tracking.

To support downstream analytics, it’s important to **design for consumption** by creating a performant Business Vault. These precomputed tables simplify reporting, provide consistent datasets, and optimize query performance. Additionally, implementing **data quality checks** ensures accuracy and reliability throughout the data pipeline. 

Ultimately, when **planning for scalability** by architecting the model with modularity and parallelization in mind, preparing it to handle increasing data volumes and complexity over time.


