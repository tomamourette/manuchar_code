-- Auto Generated (Do not modify) 136CB46F7807B8AC4F49D508BEFF644BE8FC1A450B10B2087E2F31A24B309338
create view "ods"."sv_stg_stg_stock_hist" as WITH source_stg_stg_stock_hist AS (
     SELECT 
          *
     FROM "dbb_lakehouse"."dbo"."STG__val_STG_STOCK_HIST" ssh
),

source_max_ingestion_timestamp AS (
	SELECT
		MAX(ingestion_timestamp) AS ingestion_timestamp
	FROM "dbb_lakehouse"."dbo"."STG__val_STG_STOCK_HIST" mits
),
 
deduplicated AS (
    SELECT 
        ssh.*
    FROM source_stg_stg_stock_hist ssh
	INNER JOIN source_max_ingestion_timestamp mits ON ssh.ingestion_timestamp = mits.ingestion_timestamp
)

SELECT
    *
FROM deduplicated;