WITH source_dynamics_vendsettlement AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
      FROM {{ source('dynamics', 'VendSettlement') }}
),
 
deduplicated AS (
    SELECT *
      FROM source_dynamics_vendsettlement
     WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated

