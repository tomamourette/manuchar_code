-- ===============================
-- STEP 1: Extracting Historical Data (SCD2)
-- Generating valid_from and valid_to using modifieddate
-- ===============================

WITH mds_consolidation_period_history AS (
	-- Entity details over time (SCD2)
    SELECT
	    mvc.ConsoCode + '_MONA' AS bkey_consolidation_period_source,
        mvc.ConsoCode AS bkey_consolidation_period,
        'MONA' AS bkey_source,
        mvcc.ConsoID,
        mvc.ConsoName,
        mvc.ConsoYear,
        mvc.ConsoMonth,
        mvc.ConsoDate,
        COALESCE(map.version_dbb, mvc.ConsoSequence) AS ConsoSequence,
        COALESCE(map.category_dbb, mvc.CategoryCode) AS CategoryCode,
        map.function_name AS function_name, 
        map.scope_dbb AS scope,
        map.l4l_scope,
        CAST(mvc.ODSIngestionDate  AS DATETIME2(6)) AS valid_from,  -- Ensure precision
        CAST(LEAD(mvc.ODSIngestionDate) OVER (PARTITION BY mvc.ConsoCode ORDER BY mvc.ODSIngestionDate) AS DATETIME2(6)) AS valid_to
    FROM {{ ref("sv_mona_v_conso_code") }} mvcc
    LEFT JOIN {{ ref("sv_mona_v_conso") }} mvc ON mvc.ConsoID = mvcc.ConsoID
    LEFT JOIN {{ ref("sv_oil_monaconso_ref_conso_reporting_category") }} map
        ON mvc.CategoryCode = map.category_mona
        AND mvc.ConsoSequence = map.version_mona
        AND DATEFROMPARTS(mvc.ConsoYear, mvc.ConsoMonth, 1) BETWEEN map.valid_from AND map.valid_to
),

-- ===============================
-- STEP 2: Generate Time Ranges for SCD2
-- Consolidating timestamps across history sources to create a unified timeline
-- ===============================

timeranges AS (
    SELECT DISTINCT 
        bkey_consolidation_period_source,
        bkey_consolidation_period,
        bkey_source, 
        CAST(valid_from AS DATETIME2(6)) AS valid_from,
        CAST(COALESCE(LEAD(valid_from) OVER (PARTITION BY bkey_consolidation_period ORDER BY valid_from),'2999-12-31 23:59:59.999999') AS DATETIME2(6)) AS valid_to
    FROM (
        SELECT bkey_consolidation_period_source, bkey_consolidation_period, bkey_source, valid_from, valid_to FROM mds_consolidation_period_history
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
    tr.bkey_consolidation_period_source,
    tr.bkey_consolidation_period,
    tr.bkey_source,

    -- From Main Entity History Table (Time-Dependent Attributes)
    e1.ConsoID AS consolidation_id,
    e1.ConsoName AS consolidation_name,
    e1.ConsoYear AS consolidation_year,
    e1.ConsoMonth AS consolidation_month,
    e1.ConsoDate AS consolidation_date,
    e1.ConsoSequence AS consolidation_version,
    e1.CategoryCode AS consolidation_category,
    e1.function_name AS consolidation_category_description,
    e1.scope AS consolidation_scope,
    e1.l4l_scope AS consolidation_l4l_scope,

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

LEFT JOIN mds_consolidation_period_history e1 
ON e1.bkey_consolidation_period_source = tr.bkey_consolidation_period_source
AND e1.valid_from <= tr.valid_from 
AND COALESCE(e1.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from

-- ===============================
-- JOIN SCD1 (Current) TABLE ON ID ONLY (1-to-1 Relationship)
-- Since these values do not change over time, we only keep the latest version.
-- ===============================