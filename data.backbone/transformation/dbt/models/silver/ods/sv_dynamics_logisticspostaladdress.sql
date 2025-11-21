WITH source_dynamics_logisticspostaladdress AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM {{ source('dynamics', 'LogisticsPostalAddress') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_logisticspostaladdress
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated

