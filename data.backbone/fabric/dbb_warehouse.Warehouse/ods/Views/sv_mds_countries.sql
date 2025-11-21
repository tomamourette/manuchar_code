-- Auto Generated (Do not modify) F901093A22F51689CA8458A88D7BC5505A0755146E30895B9FD8C08AB2BDD9BA
create view "ods"."sv_mds_countries" as WITH source_mds_countries AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."MDS__mdm_Countries"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_countries
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;