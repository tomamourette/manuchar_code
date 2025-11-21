WITH company AS (
    SELECT
        mds.bkey_company_source,
        mds.company_name,
        mds.company_active_code,
        CAST(mds.company_consolidation_method AS VARCHAR) AS company_consolidation_method,
        CAST(mds.company_group_percentage AS VARCHAR) AS company_group_percentage,
        CAST(mds.company_minor_percentage AS VARCHAR) AS company_minor_percentage,
        CAST(mds.company_group_control_percentage AS VARCHAR) AS company_group_control_percentage,
        CAST(mds.company_local_currency AS VARCHAR) AS company_local_currency,
        CAST(mds.company_home_currency AS VARCHAR) AS company_home_currency,
        CAST(mds.company_country_code AS VARCHAR) AS company_country_code,
        mds.company_tree_level_1,
        mds.company_tree_level_2,
        mds.company_min_reporting_period,
        mds.valid_from,
        mds.valid_to,
        mds.is_current
    FROM {{ ref('company_mds') }} mds
    UNION ALL
    SELECT
        mona.bkey_company_source,
        mona.company_name,
        CAST(mona.company_active_code AS VARCHAR) AS company_active_code,
        mona.company_consolidation_method,
        mona.company_group_percentage,
        mona.company_minor_percentage,
        mona.company_group_control_percentage,
        CAST(mona.company_local_currency AS VARCHAR) AS company_local_currency,
        CAST(mona.company_home_currency AS VARCHAR) AS company_home_currency,
        mona.company_country_code,
        mona.company_tree_level_1,
        mona.company_tree_level_2,
        mona.company_min_reporting_period,
        mona.valid_from,
        mona.valid_to,
        mona.is_current
    FROM {{ ref('company_mona') }} mona
    UNION ALL
    SELECT
        dyn.bkey_company_source,
        dyn.company_name,
        CAST(dyn.company_active_code AS VARCHAR) AS company_active_code,
        CAST(dyn.company_consolidation_method AS VARCHAR) AS company_consolidation_method,
        CAST(dyn.company_group_percentage AS VARCHAR) AS company_group_percentage,
        CAST(dyn.company_minor_percentage AS VARCHAR) AS company_minor_percentage,
        CAST(dyn.company_group_control_percentage AS VARCHAR) AS company_group_control_percentage,
        CAST(dyn.company_local_currency AS VARCHAR) AS company_local_currency,
        CAST(dyn.company_home_currency AS VARCHAR) AS company_home_currency,
        CAST(dyn.company_country_code AS VARCHAR) AS company_country_code,
        CAST(dyn.company_tree_level_1 AS VARCHAR) AS company_tree_level_1,
        CAST(dyn.company_tree_level_2 AS VARCHAR) AS company_tree_level_2,
        CAST(dyn.company_min_reporting_period AS VARCHAR) AS company_min_reporting_period,
        dyn.valid_from,
        dyn.valid_to,
        dyn.is_current
    FROM {{ ref('company_dynamics') }} dyn
)

SELECT 
    *
FROM company