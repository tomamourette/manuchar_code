-- Auto Generated (Do not modify) 44B11DF1F8E80D439D872B52202ED301C46C37B9F5EFA18D00063BE0E9FD076A
create view "ods"."sv_mona_ts010s0_bc" as 

WITH source_mona_ts010s0 AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY AccountID, ConsoID, ingestion_timestamp ORDER BY ConsoID, ingestion_timestamp DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Mona__dbo_TS010S0"
    where ingestion_timestamp <= '2025-09-03 12:21:23.790000'
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mona_ts010s0
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;