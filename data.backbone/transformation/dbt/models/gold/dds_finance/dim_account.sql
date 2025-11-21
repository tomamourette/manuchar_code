{{ config(
    tags=['Group-FinancialStatements', 'Dimension', 'Account']
) }}

WITH source_account AS (
    SELECT
        -- Keys
        CAST(ROW_NUMBER() OVER(ORDER BY ac.bkey_account) AS BIGINT) AS tkey_account,
	    CAST(ac.bkey_account AS VARCHAR(255)) AS bkey_account,
	    -- Attributes
        ac.account_number AS account_number,
        ac.account_description,
        CONCAT(ac.account_number, ' ', ac.account_description) AS account_full_description,
        COALESCE(ac.account_type, ach.account_header_type) AS account_type,
        ac.account_reporting_sign AS account_reporting_sign,
        ac.account_running_total_sign AS account_running_total_sign,
        ach.account_header_hierarchy_level_2 AS account_hierarchy_level_2,
        ach.account_header_hierarchy_level_3 AS account_hierarchy_level_3,
        ach.account_header_reporting_view AS account_reporting_view,
        ach.account_header_hierarchy_level_1 AS account_hierarchy_level_1,
        ach.account_header_detail AS account_detail,
        ach.account_header_sort_order AS account_sort_order,
        ach.account_header_calculation_type AS account_calculation_type,
      	-- History metadata
    	CAST(ac.valid_from AS DATETIME2(6)) AS valid_from,
      	CAST(ac.valid_to AS DATETIME2(6)) AS valid_to,
    	CAST(COALESCE(ac.is_current, ach.is_current) AS BIT) AS is_current
    FROM {{ ref('bv_account') }} ac
    FULL JOIN {{ ref('bv_account_header') }} ach ON ac.account_number = ach.account_header_number AND ach.is_current = 1
    WHERE COALESCE(ac.is_current, ach.is_current) = 1 -- add only the latest version
    AND ach.account_header_reporting_view IN ('Management View 2020', 'Statutory View - IFRS') OR ach.account_header_reporting_view IS NULL -- filer only on the latest reporting view
)

SELECT 
    tkey_account,
    bkey_account,
    account_number,
    account_description,
    account_full_description,
    account_type,
    account_reporting_sign,
    account_running_total_sign,
    account_hierarchy_level_2,
    account_hierarchy_level_3,
    account_reporting_view,
    account_hierarchy_level_1,
    account_detail,
    account_sort_order,
    account_calculation_type,
    valid_from,
    valid_to,
    is_current
FROM source_account