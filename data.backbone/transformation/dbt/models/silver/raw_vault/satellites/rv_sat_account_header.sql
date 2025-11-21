WITH account_header AS (
    SELECT
        bkey_account_header_source,
        account_header_number,
        account_header_type,
        account_header_hierarchy_level_2,
        account_header_hierarchy_level_3,
        account_header_reporting_view,
        account_header_hierarchy_level_1,
        account_header_detail,
        account_header_sort_order,
        account_header_calculation_type,
        valid_from,
        valid_to,
        is_current
    FROM {{ ref('account_header_mds') }}
)

SELECT 
    *
FROM account_header