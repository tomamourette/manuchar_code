-- Auto Generated (Do not modify) B505A72821E72AE09997B513518ADEE45DB489EBE9553549458EEF4AE3347039
create view "ods"."sv_dynamics_custtransopen" as WITH source_dynamics_custtransopen AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Dynamics__dbo_custtransopen"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_custtransopen
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;