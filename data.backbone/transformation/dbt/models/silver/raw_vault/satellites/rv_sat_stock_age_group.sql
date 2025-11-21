WITH stock_age_group AS (
    SELECT
        bkey_stock_age_group_source,
        stock_age_group_name,
        stock_age_group_id,
        stock_age_group_min_days,
        stock_age_group_max_days,
        stock_age_group_sort,
        valid_from,
        valid_to,
        is_current
    FROM {{ ref('stock_age_group_mds') }}
)

SELECT 
    *
FROM stock_age_group