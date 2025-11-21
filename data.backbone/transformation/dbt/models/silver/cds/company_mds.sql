-- ===============================
-- STEP 1: Extracting Historical Data (SCD2)
-- Generating valid_from and valid_to using modifieddate
-- ===============================

WITH mds_companies_history AS (
    SELECT
        Code + '_MDS' AS bkey_company_source,
        Code AS bkey_company,
        'MDS' AS bkey_source,
        Active_Code,
        CASE 
            WHEN ROW_NUMBER() OVER (PARTITION BY Code ORDER BY EnterDateTime) = 1 
            THEN CAST('1900-01-01 00:00:00.000000' AS DATETIME2(6))
            ELSE CAST(EnterDateTime AS DATETIME2(6)) 
        END AS valid_from,
        CAST(LEAD(EnterDateTime) OVER (PARTITION BY Code ORDER BY EnterDateTime) AS DATETIME2(6)) AS valid_to
    FROM {{ ref("sv_mds_companies") }}
),

mds_companypov_history AS (
    SELECT 
        Name + '_MDS' AS bkey_company_source,
        Name AS bkey_company,
        'MDS' AS bkey_source,
        SubSegment,
        Segment,
        -- Apply SCD2 logic based on whether EnterDateTime is before or after 2025 
        CASE 
            WHEN ROW_NUMBER() OVER (PARTITION BY Name ORDER BY EnterDateTime) = 1 THEN 
                CAST('1900-01-01 00:00:00.000000' AS DATETIME2(6))
            WHEN YEAR(EnterDateTime) < 2025 THEN 
                CAST(CAST(YEAR(EnterDateTime) AS VARCHAR) + '-01-01 00:00:00.000000' AS DATETIME2(6))
            ELSE 
                CAST(EnterDateTime AS DATETIME2(6))
        END AS valid_from,

        -- Adjust the LEAD logic to align with this valid_from behavior
        CAST(
            LEAD(
                CASE 
                    WHEN YEAR(EnterDateTime) < 2025 THEN 
                        CAST(CAST(YEAR(EnterDateTime) AS VARCHAR) + '-01-01 00:00:00.000000' AS DATETIME2(6))
                    ELSE 
                        CAST(EnterDateTime AS DATETIME2(6))
                END
            ) OVER (PARTITION BY Name ORDER BY EnterDateTime)
        AS DATETIME2(6)) AS valid_to

    FROM {{ ref("sv_mds_companypov") }}
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
        valid_from,
        CAST(
            COALESCE(
                LEAD(valid_from) OVER (PARTITION BY bkey_company ORDER BY valid_from),
                '2999-12-31 23:59:59.999999'
            ) AS DATETIME2(6)
        ) AS valid_to
    FROM (
        SELECT bkey_company_source, bkey_company, bkey_source, valid_from FROM mds_companies_history
        UNION
        SELECT bkey_company_source, bkey_company, bkey_source, valid_from FROM mds_companypov_history
    ) AS time_events
),

-- ===============================
-- STEP 3: Extracting Current Data (SCD1)
-- Only Latest Record per Entity is Kept
-- ===============================

mds_companies_current AS (
    -- Entity attributes where only the latest version is relevant (SCD1)
    SELECT 
        *
    FROM (
        SELECT 
            Code + '_MDS' AS bkey_company_source,
            Code AS bkey_company,
            'MDS' AS bkey_source,
            Name,
            ROW_NUMBER() OVER (PARTITION BY Code ORDER BY EnterDateTime DESC) AS rn
        FROM {{ ref("sv_mds_companies") }}
    ) latest_values
    WHERE latest_values.rn = 1
)

-- ===============================
-- STEP 4: Combine Everything into a Full Entity Timeline
-- - SCD2 (history tables) are joined on ID + valid time range.
-- - SCD1 (current tables) are joined on ID only.
-- ===============================

SELECT 
    tr.bkey_company_source,
    tr.bkey_company,
    tr.bkey_source,

    -- From Main Entity History Table (Time-Dependent Attributes)
    e1.Active_Code AS company_active_code,

    -- From Additional Entity History Table (Time-Dependent Attributes)
    e2.SubSegment AS company_tree_level_1,
    e2.Segment AS company_tree_level_2,

    -- From Entity Current Table (Static Attributes)
    ec.Name AS company_name,

    -- Missing fields
    NULL AS company_consolidation_method,
    NULL AS company_group_percentage,
    NULL AS company_minor_percentage,
    NULL AS company_group_control_percentage,
    NULL AS company_local_currency,
    NULL AS company_home_currency,
    NULL AS company_country_code,
    NULL AS company_min_reporting_period,
  
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

LEFT JOIN mds_companies_history e1 
ON e1.bkey_company_source = tr.bkey_company_source
AND e1.valid_from <= tr.valid_from 
AND COALESCE(e1.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from

LEFT JOIN mds_companypov_history e2
ON e2.bkey_company_source = tr.bkey_company_source
AND e2.valid_from <= tr.valid_from 
AND COALESCE(e2.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from

-- ===============================
-- JOIN SCD1 (Current) TABLE ON ID ONLY (1-to-1 Relationship)
-- Since these values do not change over time, we only keep the latest version.
-- ===============================

LEFT JOIN mds_companies_current ec 
ON ec.bkey_company_source = tr.bkey_company_source

UNION ALL 

SELECT
    '3PAR' + '_MDS' AS bkey_company_source,
    '3PAR' AS bkey_company,
    'MDS' AS bkey_source,
    1 AS company_active_code,
    NULL AS company_tree_level2,
    NULL AS company_tree_level1,
    '3rd Party' AS company_name,
    NULL AS company_consolidation_method,
    NULL AS company_group_percentage,
    NULL AS company_minor_percentage,
    NULL AS company_group_control_percentage,
    NULL AS company_local_currency,
    NULL AS company_home_currency,
    NULL AS company_country_code,
    NULL AS company_min_reporting_period,
    CAST('1900-01-01 00:00:00.000000' AS DATETIME2(6)) AS valid_from,
    CAST('2999-12-31 23:59:59.999999' AS DATETIME2(6)) AS valid_to,
    1 AS is_current