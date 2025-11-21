-- Auto Generated (Do not modify) B0CC6F4A418E8F61B720B41376500A7324B84DCD4CE89E36EFB9802086BB243E
create view "ods"."sv_stg_stg_sales_hist" as WITH source_stg_stg_sales_hist AS (
     SELECT 
          *
     FROM "dbb_lakehouse"."dbo"."STG__val_STG_SALES_HIST" ssh
),

source_max_ingestion_timestamp AS (
	SELECT
		max(ingestion_timestamp) AS ingestion_timestamp
	FROM "dbb_lakehouse"."dbo"."STG__val_STG_SALES_HIST" mits
	GROUP BY ingestion_timestamp
),
 
deduplicated AS (
    SELECT 
        ssh.*
    FROM source_stg_stg_sales_hist ssh
	INNER JOIN source_max_ingestion_timestamp mits ON ssh.ingestion_timestamp = mits.ingestion_timestamp
)

SELECT
    *
FROM deduplicated;