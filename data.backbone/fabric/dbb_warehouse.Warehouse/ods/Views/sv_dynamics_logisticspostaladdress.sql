-- Auto Generated (Do not modify) 6227EFF53FAF0FAFD7814E54B0910F24E222450686623AFF4D52865707EA7070
create view "ods"."sv_dynamics_logisticspostaladdress" as WITH source_dynamics_logisticspostaladdress AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Dynamics__dbo_logisticspostaladdress"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_logisticspostaladdress
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;