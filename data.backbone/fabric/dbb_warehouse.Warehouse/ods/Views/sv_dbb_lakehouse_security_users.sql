-- Auto Generated (Do not modify) 4EB058B0E3D49481D202F6B29C38D859F7584FF3A79747BE7D194A5483FED790
create view "ods"."sv_dbb_lakehouse_security_users" as WITH source_dbb_lakehouse_security_users AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY ID, ingestion_timestamp ORDER BY ingestion_timestamp DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."dbb_lakehouse__dbo_enum_security_users"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dbb_lakehouse_security_users
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;