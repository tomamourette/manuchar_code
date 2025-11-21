-- ===============================
-- STEP 1: Extracting Historical Data (SCD2)
-- Generating valid_from and valid_to using modifieddate
-- ===============================

WITH mona_ts014c0_history AS (
	SELECT
		CompanyCode + '_MONA' AS bkey_company_source,
        CompanyCode AS bkey_company,
        'MONA' AS bkey_source,
        mdtc.ConsoID,
        mdvcc.ConsoCode,
        ConsoMethod,
        GroupPerc,
        MinorPerc,
        GroupCtrlPerc,
        ConsoMonth, 
        ConsoYear,
        CASE 
            WHEN ROW_NUMBER() OVER (PARTITION BY CompanyCode ORDER BY CAST(CONCAT(mdvc.ConsoYear, '-', mdvc.ConsoMonth, '-01 00:00:00.000000') AS DATETIME2(6))) = 1 
            THEN CAST('1900-01-01 00:00:00.000000' AS DATETIME2(6))
            ELSE CAST(CONCAT(mdvc.ConsoYear, '-', mdvc.ConsoMonth, '-01 00:00:00.000000') AS DATETIME2(6)) 
        END AS valid_from,
        CAST(
            LEAD(CAST(CONCAT(mdvc.ConsoYear, '-', mdvc.ConsoMonth, '-01 00:00:00.000000') AS DATETIME2(6))) 
            OVER (PARTITION BY CompanyCode ORDER BY CAST(CONCAT(mdvc.ConsoYear, '-', mdvc.ConsoMonth, '-01 00:00:00.000000') AS DATETIME2(6)))
        AS DATETIME2(6)) AS valid_to
  	FROM {{ ref("sv_mona_ts014c0") }} mdtc 
  	LEFT JOIN {{ ref("sv_mona_v_conso_code") }} mdvcc ON mdvcc.ConsoID = mdtc.ConsoID
  	LEFT JOIN {{ ref("sv_mona_v_conso") }} mdvc ON mdvc.ConsoID = mdvcc.ConsoID
	WHERE mdvcc.ConsoCode LIKE '%ACT000'
),

mds_companypov_history AS (
    SELECT 
        Name + '_MONA' AS bkey_company_source,
        Name AS bkey_company,
        'MONA' AS bkey_source,
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
        SELECT bkey_company_source, bkey_company, bkey_source, valid_from FROM mona_ts014c0_history
        UNION
        SELECT bkey_company_source, bkey_company, bkey_source, valid_from FROM mds_companypov_history
    ) AS time_events
),

-- ===============================
-- STEP 3: Extracting Current Data (SCD1)
-- Only Latest Record per Entity is Kept
-- ===============================

mona_ts014c0_current AS (
  -- Entity attributes where only the latest version is relevant (SCD1)
    SELECT 
        CompanyCode + '_MONA' AS bkey_company_source,
        CompanyCode AS bkey_company,
        'MONA' AS bkey_source,
        CompanyName,
        CurrCode,
        HomeCurrency,
        CountryCode
    FROM (
        SELECT 
            ts014c.CompanyCode,
            ts014c.CompanyName,
            ts014c.CountryCode,
            ts014c.CurrCode,
            COALESCE(ch.Value, ts014m.InfoText) AS HomeCurrency,
            ts014c.ConsoID
        FROM {{ ref("sv_mona_ts014c0") }} ts014c
        LEFT JOIN {{ ref('sv_mona_ts014m1') }} ts014m
            ON ts014m.CompanyID = ts014c.CompanyID
            AND ts014m.ConsoID = '29422'
            AND ts014m.AddInfoID = '46'
        LEFT JOIN {{ ref("sv_mds_companyhistory") }} ch
            ON ts014c.CompanyCode = ch.Company_Code
            AND CONVERT(DATE, ch.End_Date) = DATEFROMPARTS(2100, 12, 31)
            AND ch.[Key] = 'Home Currency'
    ) latest_values
    WHERE ConsoID = '29422' -- not latest entry but entry at dummy period 'GRABIT'
),

mona_min_reporting_period AS (
    SELECT
        mdtc.CompanyCode + '_MONA' AS bkey_company_source,
        MIN(LEFT(mdvcc.ConsoCode, 6)) AS company_min_reporting_period
    FROM {{ ref("sv_mona_ts014c0") }} mdtc 
    LEFT JOIN {{ ref("sv_mona_v_conso_code") }} mdvcc ON mdvcc.ConsoID = mdtc.ConsoID
    WHERE mdvcc.ConsoCode <> '201802ACT001'
    GROUP BY mdtc.CompanyCode
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
    e1.ConsoMethod AS company_consolidation_method,
    e1.GroupPerc AS company_group_percentage,
    e1.MinorPerc AS company_minor_percentage,
    e1.GroupCtrlPerc AS company_group_control_percentage,

    -- From Additional Entity History Table (Time-Dependent Attributes)
    e2.SubSegment AS company_tree_level_1,
    e2.Segment AS company_tree_level_2,

    -- From Entity Current Table (Static Attributes)
    ec1.CompanyName AS company_name,
    ec1.CurrCode AS company_local_currency,
    ec1.HomeCurrency AS company_home_currency,
    ec1.CountryCode AS company_country_code,

    ec2.company_min_reporting_period,

    -- Missing Fields
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

LEFT JOIN mona_ts014c0_history e1 
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

LEFT JOIN mona_ts014c0_current ec1 
ON ec1.bkey_company_source = tr.bkey_company_source

LEFT JOIN mona_min_reporting_period ec2
ON ec2.bkey_company_source = tr.bkey_company_source