## What is the goal?
In an event-driven system, data changes trigger actions across the platform. The objective is that data ingestion into the data platform flows in directly to the bronze layer. With Microsoft Dynamics as source we can achieve this by using the Dataverse (for which Microsoft promises a delay below 15 minutes). For other sources we will have to put in place CDC software.

## Which are the sources to be considered?

sql server, per manuchar bron

## Qlik Replicate

Qlik Replicate is a real-time data replication and integration tool that enables Change Data Capture (CDC) across various source and target systems. It supports both on-premises and cloud-based databases, making it a powerful choice for event-driven data architectures.

Qlik Replicate allows you to:  
- Continuously capture data changes from relational databases.  
- Move data in real-time to cloud platforms like Microsoft Fabric (OneLake).  
- Minimize source system impact by efficiently handling CDC workloads.  
- Automate & manage data pipelines with minimal coding.
 Qlik Replicate enables an event-driven system by capturing real-time database changes (CDC) and streaming them to a target, in this case, Microsoft Fabric (OneLake).

### Architecture Qlik Replicate → Microsoft Fabric (OneLake)

- Source Systems (On-premise or cloud)
    - Relational Databases: SQL Server, Oracle, PostgreSQL, MySQL
    - Cloud Databases: Azure SQL
- Qlik Replicate (CDC Engine)
     - Captures Insert, Update, Delete changes from source databases.
     - Transforms and loads data efficiently without full reloads.
     - Publishes data directly to Microsoft Fabric (OneLake) in Delta Lake format.
- Microsoft Fabric (OneLake as Target)
     - Data lands directly in OneLake as Delta Lake tables.

### How the Data in OneLake Will Look After Replication

Once Qlik Replicate streams Change Data Capture (CDC) events to Microsoft Fabric (OneLake), the data will be stored as Delta Lake tables in an organized lakehouse structure.

### Target table Behaviours: Mirror or Full CDC Log

#### Exact Mirror of Source Table (Latest State Only)

- The target table only contains the latest version of each row, just like the source database.  
- Deletes in the source also remove rows in the target.  
- Useful for operational reporting where only current data is needed.

Qlik Replicate Configuration:
- Apply Updates Mode: Overwrite the previous row when a change happens.
- Apply Deletes Mode: Remove records from OneLake when they are deleted in the source.



#### Full CDC Log (History of All Changes)

- The target table stores all historical changes, including inserts, updates, and deletes.  
- Deleted records are not removed, but instead marked as deleted.  
- Useful for audit logs, machine learning, and historical trend analysis.

Qlik Replicate Configuration:
- Store Full Change History: Instead of overwriting records, insert a new row for every change.
- Soft Delete Instead of Hard Delete: Keep deleted records but flag them with a `__op = 'D'`.


#### Comparison
---------------------------------------

| Use Case | Replication Mode | How Deletes are Handled | Best For |
| --- | --- | --- | --- |
| Mirror the Source (Latest State Only) | Apply Updates & Deletes | Physically remove deleted records | Operational Reporting, Real-time Dashboards |
| Full Change History (CDC Log) | Store Full Change History | Mark records as deleted (`__op = 'D'`) | Auditing, Machine Learning, Historical Analysis |

### DDL changes with Qlik replicate

#### Automatic Schema Change Detection

- Qlik Replicate monitors the source schema for changes.
- If a column is added, removed, or modified, Replicate detects it without restarting replication.
- Changes are applied dynamically to the target (OneLake - Delta Lake).

#### Supported Schema Changes

- Adding New Columns → Automatically added to OneLake.  
- Expanding Data Types (e.g., INT → BIGINT) → Updated dynamically.  
- Changing Column Order → Order may not be preserved, but data is not lost.  
- Column Renaming (Limited Support) → Treated as a new column + drop old column (data may be lost).  
- Dropping Columns → Can be configured to either ignore or apply.



#### How OneLake (Delta Lake) Handles Schema Evolution


OneLake uses Delta Lake, which supports schema evolution natively through MERGE operations and _delta_log metadata tracking.

- If a new column is added, it gets added to the Delta table without affecting existing data.
- If a column is removed, Delta Lake ignores it unless overwrite mode is enabled.
- Schema changes are tracked in `_delta_log`, allowing time travel and rollback if needed.

#### Overview

| Feature | Supported? | Behavior |
| --- | --- | --- |
| Add New Column | Yes | Automatically added to the Delta table. |
| Drop Column | Partial | Ignored by default (can be manually handled). |
| Change Data Type | Yes (if safe) | Expanding types (e.g., INT → BIGINT) works, but shrinking types (e.g., BIGINT → INT) may fail. |
| Column Rename | No | Treated as a new column + drop old column (manual handling required). |

### When to Use Qlik Replicate?

| Feature | Qlik Replicate |
| --- | --- |
| Real-Time CDC (Streaming) | Yes | 
| Direct Integration with OneLake (Fabric) | Yes |
| Data Transformation & Enrichment | No (Only replication), use dbt, Azure Data Factory, Fabric Pipelines |
| Handles Large-Scale Data Volumes | Yes (High performance) |

---

## Fivetran
Fivetran supports Change Data Capture (CDC), but it is not a fully event-driven CDC tool like Qlik Replicate. Instead, Fivetran operates on a micro-batch model, meaning it polls the source database at regular intervals rather than streaming changes in real time.

### Fivetran’s CDC Approach

- Log-Based CDC: Reads transaction logs (e.g., MySQL binlog, SQL Server CDC, PostgreSQL WAL).
- Batch-Oriented: Instead of streaming, Fivetran syncs changes in intervals (default 5 min, configurable).
- No Native Event Streaming: Changes are not immediately pushed but are instead fetched on schedule.

### Can Fivetran Be Used in an Event-Driven Data Platform?

Yes, but with limitations. Since Fivetran does not natively support real-time event streaming, you would need to introduce a workaround to make it event-driven.

---

## Comparison between Qlik Replicate and Fivetran

| Use Case | Fivetran | Qlik Replicate |
| --- | --- | --- |
| Streaming CDC (event-driven, real-time updates) | Not ideal | Yes, supports event-driven architectures |
| Low-Latency Replication to Data Lake / Warehouse | Limited (sync intervals) | Faster (real-time) |
| Direct Integration with Microsoft Fabric (OneLake) | Yes (via Delta Lake) | Yes (native support) |
| Data movement | Moves over the Fivetran cloud (Delay / security)| Stays within organisation (not exposed to Qlik) |




