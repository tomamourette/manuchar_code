-- Auto Generated (Do not modify) D95564BF4FA11DE207DAB705053CD18111BEE88496141770FC867BEF96BB0F98
create view "ods"."sv_mona_v_conso" as WITH source_mona_v_conso AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY ConsoID ORDER BY ODSIngestionDate DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Mona__dbo_V_CONSO"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mona_v_conso
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;