WITH source_log_validation_log AS (
     SELECT 
          *
     FROM {{ source('log', 'validation_approval_log')}} ssh
),

source_max_ingestion_timestamp AS (
	SELECT
		max(ingestion_timestamp) AS ingestion_timestamp
	FROM {{ source('log', 'validation_approval_log')}} mits
	GROUP BY ingestion_timestamp
),
 
deduplicated AS (
    SELECT 
        ssh.*
    FROM source_log_validation_log ssh
	INNER JOIN source_max_ingestion_timestamp mits ON ssh.ingestion_timestamp = mits.ingestion_timestamp
)

SELECT
    *
FROM deduplicated