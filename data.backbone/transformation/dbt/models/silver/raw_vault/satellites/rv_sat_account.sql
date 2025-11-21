WITH account AS (
    SELECT
        bkey_account_source,
        account_number,
        account_description,
        account_type,
        account_reporting_sign,
        account_running_total_sign,
        valid_from,
        valid_to,
        is_current
    FROM {{ ref("account_mds") }}
)

SELECT
    *
FROM account