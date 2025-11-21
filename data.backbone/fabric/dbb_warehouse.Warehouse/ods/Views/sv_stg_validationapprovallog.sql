-- Auto Generated (Do not modify) 0A67D34D6C295576376C8B68F2F4E5A4B58C96C0CEEDFF66F7DD39C35C5EA759
create view "ods"."sv_stg_validationapprovallog" as WITH source_stg_validation_log AS (
     SELECT 
          *
     FROM "dbb_lakehouse"."dbo"."LOG__dbo_ValidationApprovalLog" ssh
),

source_max_ingestion_timestamp AS (
	SELECT
		max(ingestion_timestamp) AS ingestion_timestamp
	FROM "dbb_lakehouse"."dbo"."LOG__dbo_ValidationApprovalLog" mits
	GROUP BY ingestion_timestamp
),
 
deduplicated AS (
    SELECT 
        ssh.*
    FROM source_stg_validation_log ssh
	INNER JOIN source_max_ingestion_timestamp mits ON ssh.ingestion_timestamp = mits.ingestion_timestamp
)

SELECT
    *
FROM deduplicated;