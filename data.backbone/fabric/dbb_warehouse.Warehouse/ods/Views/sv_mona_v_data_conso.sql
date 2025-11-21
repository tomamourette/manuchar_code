-- Auto Generated (Do not modify) 619A804776E341D079BAB82289C79C0AC15EC0EE0E25B6A257ABEF1F21218090
create view "ods"."sv_mona_v_data_conso" as WITH source_mona_v_data_conso AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY ConsolidatedAmountID, ConsoID ORDER BY ODSIngestionDate DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Mona__dbo_V_DATA_CONSO"
    WHERE ODSActive = 1
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mona_v_data_conso
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;