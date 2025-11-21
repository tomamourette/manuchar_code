WITH source_dynamics_unitofmeasuretranslation AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM {{ source('dynamics', 'UnitOfMeasureTranslation') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_unitofmeasuretranslation
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated

