-- Auto Generated (Do not modify) 197AC9FBD0C8C1D3992A02A53A5F7BCEF583B6B7F4E2994366FDDE336535602C
create view "ods"."sv_stg_stg_sales_plan_hist" as WITH source_stg_stg_sales_plan_hist AS (
     SELECT 
          *
     FROM "dbb_lakehouse"."dbo"."DWH__ds_STG_val_STG_SALES_PLAN_HIST" ssh
),

source_max_ingestion_timestamp AS (
	SELECT
		max(ingestion_timestamp) AS ingestion_timestamp
	FROM "dbb_lakehouse"."dbo"."DWH__ds_STG_val_STG_SALES_PLAN_HIST" mits
	GROUP BY ingestion_timestamp
),
 
deduplicated AS (
    SELECT 
        ssh.*
    FROM source_stg_stg_sales_plan_hist ssh
	INNER JOIN source_max_ingestion_timestamp mits ON ssh.ingestion_timestamp = mits.ingestion_timestamp
)

SELECT
    *
FROM deduplicated;