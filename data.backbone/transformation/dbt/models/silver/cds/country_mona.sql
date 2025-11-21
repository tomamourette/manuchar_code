-- ===============================
-- STEP 1: Extracting Historical Data (SCD2)
-- Generating valid_from and valid_to using modifieddate
-- ===============================

WITH mona_country_history AS (
	-- Entity details over time (SCD2)
    SELECT
	    CountryCode + '_MONA' AS bkey_country_source,
        CountryCode AS bkey_country,
        'MONA' AS bkey_source,
        CAST(ODSIngestionDate AS DATETIME2(6)) AS valid_from,  -- Ensure precision
        CAST(LEAD(ODSIngestionDate) OVER (PARTITION BY CountryCode ORDER BY ODSIngestionDate) AS DATETIME2(6)) AS valid_to
    FROM {{ ref("sv_mona_ts024c0") }}
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
        SELECT bkey_country_source, bkey_country, bkey_source, valid_from, valid_to FROM mona_country_history
    ) AS time_events
),

-- ===============================
-- STEP 3: Extracting Current Data (SCD1)
-- Only Latest Record per Entity is Kept
-- ===============================

mona_country_current AS (
    -- Entity attributes where only the latest version is relevant (SCD1)
    SELECT 
        *
    FROM (
        SELECT 
            CountryCode + '_MONA' AS bkey_country_source,
            CountryCode AS bkey_country,
            'MONA' AS bkey_source,
            CountryNameDefault,
            Region,
            Continent,
            ROW_NUMBER() OVER (PARTITION BY CountryCode ORDER BY ODSIngestionDate DESC) AS rn
        FROM {{ ref("sv_mona_ts024c0") }}
    ) latest_values
    WHERE rn = 1
)

-- ===============================
-- STEP 4: Combine Everything into a Full Entity Timeline
-- - SCD2 (history tables) are joined on ID + valid time range.
-- - SCD1 (current tables) are joined on ID only.
-- ===============================

SELECT 
    tr.bkey_country,
    tr.bkey_country_source,
    tr.bkey_source,

    -- From Entity Current Table (Static Attributes)
    ec.CountryNameDefault AS country_name,
    ec.Region AS country_region_level_2,
    ec.Continent AS country_continent,

    -- Missing Fields
    NULL AS country_iso_code,
    NULL AS country_sort,
    NULL AS country_region_level_1,
    NULL AS country_region_level_1_sort,
    NULL AS country_region_level_2_sort,

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

LEFT JOIN mona_country_history e
ON e.bkey_country_source = tr.bkey_country_source
AND e.valid_from <= tr.valid_from 
AND COALESCE(e.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from

-- ===============================
-- JOIN SCD1 (Current) TABLE ON ID ONLY (1-to-1 Relationship)
-- Since these values do not change over time, we only keep the latest version.
-- ===============================

LEFT JOIN mona_country_current ec
ON ec.bkey_country_source = tr.bkey_country_source