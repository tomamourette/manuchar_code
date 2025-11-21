-- ===============================
-- STEP 1: Extracting Historical Data (SCD2)
-- Generating valid_from and valid_to using modifieddate
-- ===============================

WITH dynamics_vessel_history AS (
	-- Entity details over time (SCD2)
    SELECT
	    shipvesselid + '_DYNAMICS' AS bkey_vessel_source,
        shipvesselid AS bkey_vessel,
        'DYNAMICS' AS bkey_source,
        shipvesseldescription AS vessel_description,
        CAST(modifieddatetime  AS DATETIME2(6)) AS valid_from,  -- Ensure precision
        CAST(LEAD(modifieddatetime) OVER (PARTITION BY shipvesselid ORDER BY modifieddatetime) AS DATETIME2(6)) AS valid_to
    FROM {{ ref("sv_dynamics_itmvesseltable") }}
),

-- ===============================
-- STEP 2: Generate Time Ranges for SCD2
-- Consolidating timestamps across history sources to create a unified timeline
-- ===============================

timeranges AS (
    SELECT 
        bkey_vessel_source,
        bkey_vessel,
        bkey_source,
        CAST(valid_from AS DATETIME2(6)) AS valid_from,
        CAST(COALESCE(LEAD(valid_from) OVER (PARTITION BY bkey_vessel ORDER BY valid_from),'2999-12-31 23:59:59.999999') AS DATETIME2(6)) AS valid_to
    FROM (
        SELECT bkey_vessel_source, bkey_vessel, bkey_source, valid_from, valid_to FROM dynamics_vessel_history
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
    tr.bkey_vessel_source,
    tr.bkey_vessel,
    tr.bkey_source,

    -- From Main Entity History Table (Time-Dependent Attributes)
    e1.vessel_description,

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

LEFT JOIN dynamics_vessel_history e1 
ON e1.bkey_vessel = tr.bkey_vessel
AND e1.valid_from <= tr.valid_from 
AND COALESCE(e1.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from

-- ===============================
-- JOIN SCD1 (Current) TABLE ON ID ONLY (1-to-1 Relationship)
-- Since these values do not change over time, we only keep the latest version.
-- ===============================