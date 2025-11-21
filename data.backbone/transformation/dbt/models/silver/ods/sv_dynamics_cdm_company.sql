WITH source_dynamics_company AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY cdm_companycode ORDER BY SinkModifiedOn DESC) AS rn
    FROM {{ source('dynamics', 'Company') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_company
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated

