-- Auto Generated (Do not modify) D345BBD8439DB100ADCB0F2BF7CE07FEC8C96EB1BAD69C34A02A99E0F3B1E109
create view "ods"."sv_mona_td055c2" as WITH source_mona_td055c2 AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY ConsolidatedAmountDimID, ConsoID ORDER BY ODSIngestionDate DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Mona__dbo_TD055C2"
    WHERE ODSActive = 1
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mona_td055c2
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;