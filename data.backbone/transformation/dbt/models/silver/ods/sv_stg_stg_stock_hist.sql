WITH source_stg_stg_stock_hist AS (
     SELECT 
          *
     FROM {{ source('stg', 'stg_stock_hist')}} ssh
),

source_max_ingestion_timestamp AS (
	SELECT
		MAX(ingestion_timestamp) AS ingestion_timestamp
	FROM {{ source('stg', 'stg_stock_hist')}} mits
),
 
deduplicated AS (
    SELECT 
        ssh.*
    FROM source_stg_stg_stock_hist ssh
	INNER JOIN source_max_ingestion_timestamp mits ON ssh.ingestion_timestamp = mits.ingestion_timestamp
)

SELECT
    *
FROM deduplicated