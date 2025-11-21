WITH age_group AS (
    SELECT
        bkey_age_group_source,
        age_group_name,
        age_group_id,
        age_group_min_days,
        age_group_max_days,
        age_group_sort,
        valid_from,
        valid_to,
        is_current
    FROM {{ ref('age_group_mds') }}
)

SELECT 
    *
FROM age_group