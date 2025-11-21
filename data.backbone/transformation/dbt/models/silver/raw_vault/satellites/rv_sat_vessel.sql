WITH vessel AS (
    SELECT
        dyn.bkey_vessel_source,
        dyn.bkey_vessel AS vessel_id,
        dyn.vessel_description,
        dyn.valid_from,
        dyn.valid_to,
        dyn.is_current
    FROM {{ ref('vessel_dynamics') }} AS dyn
    WHERE is_current = 1
)

SELECT
    *
FROM vessel