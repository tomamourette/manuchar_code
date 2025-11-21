-- Auto Generated (Do not modify) 0F3B7811E4CF14C32A399246242D749690E6983CA2D6D841239630239E01661E
create view "ods"."sv_dynamics_cdm_company" as WITH source_dynamics_company AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY cdm_companycode ORDER BY SinkModifiedOn DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Dynamics__dbo_cdm_company"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_company
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;