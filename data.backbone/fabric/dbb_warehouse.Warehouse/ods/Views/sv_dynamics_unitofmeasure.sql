-- Auto Generated (Do not modify) 21129B5829EAABFFAE34365FFA323209B1874E8DA2F13780B1EC7EB7485A0C92
create view "ods"."sv_dynamics_unitofmeasure" as WITH source_dynamics_unitofmeasure AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Dynamics__dbo_unitofmeasure"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_unitofmeasure
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;