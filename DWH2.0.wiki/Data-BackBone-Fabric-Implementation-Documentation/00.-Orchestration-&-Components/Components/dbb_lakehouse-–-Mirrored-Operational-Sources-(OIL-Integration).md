# dbb_lakehouse – Mirrored Operational Sources (OIL Integration)

[[_TOC_]]

## Purpose

The `dbb_lakehouse` serves as the **central Lakehouse for mirrored operational data sources**, providing a unified storage and access layer within the Data BackBone (DBB) platform.  

It hosts **live, mirrored tables** replicated from various **Operational Integration Layer [PRD]** Lakehouses and Warehouses. These mirrors ensure near real-time availability of source system data within DBB for downstream transformation, integration, and reporting.

This component belongs to the **integration workload**, functioning as the bridge between external operational data sources and DBB’s transformation layer.

---

## Architecture

Data is replicated to the `dbb_lakehouse` using **Lakehouse-to-Lakehouse mirroring** from the **Operational Integration Layer [PRD]** workspace.  

Each mirrored dataset originates from its respective source Lakehouse or Warehouse, maintained automatically through Fabric-native synchronization.

**Current mirrored sources:**

| **Source System** | **Origin Lakehouse/Warehouse** | **Description** |
|--|--|--|
| *Dynamics 365 (D365)* | `OSS_Dynamics_MHQ_Lakehouse` | Live mirrored Dataverse tables from Microsoft Dynamics 365 (replaces `dbb_dynamics_lakehouse`). |
| *Mona* | `OSS_MonaConso_MHQ_Warehouse` | Consolidated data from the Mona application, mirrored into DBB for operational integration. |
| *Generic Data* | `OSS_GenericData_MHQ_Warehouse` | Generic and reference data such as locations, sites, and other manually maintained mapping files. Future manual datasets will also be mirrored from this source. |

All source-to-destination synchronization is managed within Microsoft Fabric and does not require custom pipeline orchestration.
---

## Table Structure

* All tables reside under the `dbo` schema within `dbb_lakehouse`.  

* Table names align with their respective source entity names and structures.  

* Each mirrored table reflects the **latest synchronized snapshot** of its source system.  

* No transformations are performed at this layer — it is treated as **authoritative raw data**.

---

## Use in DBB

* The `dbb_lakehouse` acts as a **read-only integration layer** for the transformation workload (`dbb_warehouse`).  

* Tables from this Lakehouse are referenced in **dbt `source` declarations** under the `source_views` layer.  

* These views feed the **raw vault** or **business vault** models in the DBB data vault architecture.

---

## Operational Considerations

* Data synchronization is **fully managed by Fabric**, based on the mirroring setup in the **Operational Integration Layer [PRD]** workspace. 

* There are **no custom DBB ingestion pipelines** for these mirrored datasets.  

* **Monitoring** still needs to be implemented for these sources... 

* DBB assumes mirrored tables are always current and does not apply watermarking, incremental loads, or historical tracking at this layer.  

---

## Summary

The `dbb_lakehouse` integrates mirrored datasets from the **Operational Integration Layer [PRD]**, where all data loads are centrally managed.  
This centralized mirroring ensures that data across OIL and DBB remains **timely, consistent, and synchronized** with the operational sources.  
As a result, DBB always works with a **single, reliable version of the truth** without maintaining its own ingestion pipelines for these source systems.