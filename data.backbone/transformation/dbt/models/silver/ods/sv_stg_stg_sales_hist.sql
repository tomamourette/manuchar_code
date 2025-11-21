WITH source_stg_stg_sales_hist AS (
     SELECT 
          *
     FROM {{ source('stg', 'stg_sales_hist')}} ssh
),

source_max_ingestion_timestamp AS (
	SELECT
		max(ingestion_timestamp) AS ingestion_timestamp
	FROM {{ source('stg', 'stg_sales_hist')}} mits
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
FROM deduplicated