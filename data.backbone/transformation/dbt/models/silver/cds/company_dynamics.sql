-- ===============================
-- STEP 1: Extracting Historical Data (SCD2)
-- Generating valid_from and valid_to using modifieddate
-- ===============================

WITH dynamics_company_history AS (
    -- Entity details over time (SCD2)
    SELECT
        cdm_companycode + '_DYNAMICS' AS bkey_company_source,
        cdm_companycode AS bkey_company,
        'DYNAMICS' AS bkey_source,
        cdm_name,
        CASE 
            WHEN ROW_NUMBER() OVER (PARTITION BY cdm_companycode ORDER BY modifiedon) = 1 
            THEN CAST('1900-01-01 00:00:00.000000' AS DATETIME2(6))
            ELSE CAST(modifiedon AS DATETIME2(6))
        END AS valid_from,
        CAST(LEAD(modifiedon) OVER (PARTITION BY cdm_companycode ORDER BY modifiedon) AS DATETIME2(6)) AS valid_to
    FROM {{ ref("sv_dynamics_cdm_company") }} dcc
),

-- ===============================
-- STEP 2: Generate Time Ranges for SCD2
-- Consolidating timestamps across history sources to create a unified timeline
-- ===============================

timeranges AS (
    SELECT 
        bkey_company_source,
        bkey_company,
        bkey_source, 
        CAST(valid_from AS DATETIME2(6)) AS valid_from,
        CAST(COALESCE(LEAD(valid_from) OVER (PARTITION BY bkey_company ORDER BY valid_from), '2999-12-31 23:59:59.999999') AS DATETIME2(6)) AS valid_to
    FROM (
        SELECT bkey_company_source, bkey_company, bkey_source, valid_from, valid_to FROM dynamics_company_history
    ) AS time_events
)

-- ===============================
-- STEP 3: Extracting Current Data (SCD1)
-- Only Latest Record per Entity is Kept
-- ===============================

-- ===============================
-- STEP 4: Combine Everything into a Full Entity Timeline
-- - SCD2 (history tables) are joined on ID + valid time range.
-- - SCD1 (current tables) are joined on ID only.
-- ===============================

SELECT 
    tr.bkey_company_source,
    tr.bkey_company,
    tr.bkey_source,

    NULL AS company_consolidation_method,
    NULL AS company_group_percentage,
    NULL AS company_minor_percentage,
    NULL AS company_group_control_percentage,
    NULL AS company_tree_level_1,
    NULL AS company_tree_level_2,
    e1.cdm_name AS company_name,
    NULL AS company_local_currency,
    NULL AS company_home_currency,
    NULL AS company_country_code,
    NULL AS company_min_reporting_period,
    NULL AS company_active_code,

    -- Metadata for time tracking
    tr.valid_from,
    tr.valid_to,
    CASE 
        WHEN tr.valid_to = '2999-12-31 23:59:59.999999' THEN 1 
        ELSE 0
    END AS is_current

FROM timeranges tr

-- ===============================
-- JOIN SCD2 (History) TABLES ON ID + TIME RANGE
-- Ensures correct historical version is retrieved based on the event timestamp.
-- ===============================

LEFT JOIN dynamics_company_history e1 
ON e1.bkey_company_source = tr.bkey_company_source
AND tr.valid_from >= e1.valid_from
AND tr.valid_from < COALESCE(e1.valid_to, '2999-12-31 23:59:59.999999')