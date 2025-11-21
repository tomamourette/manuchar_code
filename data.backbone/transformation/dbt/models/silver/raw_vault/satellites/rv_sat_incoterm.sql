WITH incoterm AS (
    SELECT
        dyn.bkey_incoterm_source,
        dyn.bkey_incoterm AS incoterm_code,
        dyn.incoterm_description,
        dyn.valid_from,
        dyn.valid_to,
        dyn.is_current
    FROM {{ ref('incoterm_dynamics') }} AS dyn
    WHERE is_current = 1
)

SELECT
    *
FROM incoterm