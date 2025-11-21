-- ===============================
-- STEP 1: Extracting Historical Data (SCD2)
-- Generating valid_from and valid_to using modifieddate
-- ===============================

WITH mds_country_history AS (
	-- Entity details over time (SCD2)
    SELECT
	    Code + '_MDS' AS bkey_country_source,
        Code AS bkey_country,
        'MDS' AS bkey_source,
        CAST(EnterDateTime  AS DATETIME2(6)) AS valid_from,  -- Ensure precision
        CAST(LEAD(EnterDateTime) OVER (PARTITION BY Code ORDER BY EnterDateTime) AS DATETIME2(6)) AS valid_to
    FROM {{ ref("sv_mds_countries") }}
),

-- ===============================
-- STEP 2: Generate Time Ranges for SCD2
-- Consolidating timestamps across history sources to create a unified timeline
-- ===============================

timeranges AS (
    SELECT 
        bkey_country_source,
        bkey_country,
        bkey_source, 
        CAST(valid_from AS DATETIME2(6)) AS valid_from,
        CAST(COALESCE(LEAD(valid_from) OVER (PARTITION BY bkey_country ORDER BY valid_from),'2999-12-31 23:59:59.999999') AS DATETIME2(6)) AS valid_to
    FROM (
        SELECT bkey_country_source, bkey_country, bkey_source, valid_from, valid_to FROM mds_country_history
    ) AS time_events
),

-- ===============================
-- STEP 3: Extracting Current Data (SCD1)
-- Only Latest Record per Entity is Kept
-- ===============================

mds_country_current AS (
  -- Entity attributes where only the latest version is relevant (SCD1)
    SELECT 
        *
    FROM (
        SELECT     
            Code + '_MDS' AS bkey_country_source,
            Code AS bkey_country,
            'MDS' AS bkey_source,
            Name,
            ISO_Alpha_3_Code,
            ISO_Numeric_Code,
            Commercial_Region_Name,
            Commercial_Region_ID,
            ROW_NUMBER() OVER (PARTITION BY Code ORDER BY EnterDateTime DESC) AS rn
        FROM {{ ref("sv_mds_countries") }}
    ) latest_values
    WHERE rn = 1
)

-- ===============================
-- STEP 4: Combine Everything into a Full Entity Timeline
-- - SCD2 (history tables) are joined on ID + valid time range.
-- - SCD1 (current tables) are joined on ID only.
-- ===============================

SELECT 
    tr.bkey_country_source,
    tr.bkey_country,
    tr.bkey_source,

    -- From Entity Current Table (Static Attributes)
    ec.Name AS country_name,
    ec.ISO_Alpha_3_Code AS country_iso_code,
    ec.ISO_Numeric_Code AS country_sort,
    NULL AS country_region_level_1,
    NULL AS country_region_level_1_sort,
    ec.Commercial_Region_Name AS country_region_level_2,
    ec.Commercial_Region_ID AS country_region_level_2_sort,

    -- Missing Fields
    NULL AS country_continent,

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

LEFT JOIN mds_country_history e 
ON e.bkey_country_source = tr.bkey_country_source
AND e.valid_from <= tr.valid_from 
AND COALESCE(e.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from

-- ===============================
-- JOIN SCD1 (Current) TABLE ON ID ONLY (1-to-1 Relationship)
-- Since these values do not change over time, we only keep the latest version.
-- ===============================

LEFT JOIN mds_country_current ec
ON ec.bkey_country_source = tr.bkey_country_source