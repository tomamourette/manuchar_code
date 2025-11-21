WITH cost_center AS (
    SELECT
        bkey_cost_center_source,
        cost_center_code,
        cost_center_description,
        valid_from,
        valid_to,
        is_current
    FROM {{ ref('cost_center_dbb_lakehouse') }}
)

SELECT 
    *
FROM cost_center