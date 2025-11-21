-- ===============================
-- STEP 1: Extracting Historical Data (SCD2)
-- Generating valid_from and valid_to using modifieddate
-- ===============================

WITH mds_account_hierarchy_history AS (
  -- Entity attributes where only the latest version is relevant (SCD1)
    SELECT 
	    ts010s0.Account + '_MDS' AS bkey_account_source,
	    ts010s0.Account AS bkey_account,
	    'MDS' AS bkey_source,
	    smah.AccountDescription,
	    smah.AccountCategory,
	    CASE 
            WHEN ts010s0.Account = '430010' AND smah.ReportSign = -1 THEN 1 
            ELSE smah.ReportSign 
        END AS ReportSign,
	    smah.RunningTotalSign,
	    CAST(smah.LastChgDateTime AS DATETIME2(6)) AS valid_from,
	    CAST(
	        LEAD(smah.LastChgDateTime) OVER (PARTITION BY ts010s0.Account ORDER BY smah.LastChgDateTime)
	        AS DATETIME2(6)
	    ) AS valid_to
	FROM (SELECT DISTINCT Account FROM {{ ref("sv_mona_ts010s0") }}) AS ts010s0
	LEFT JOIN {{ ref("sv_mds_accounthierarchy") }} smah ON smah.Code = ts010s0.Account
),

-- ===============================
-- STEP 2: Generate Time Ranges for SCD2
-- Consolidating timestamps across history sources to create a unified timeline
-- ===============================

timeranges AS (
    SELECT 
        bkey_account_source,
        bkey_account,
        bkey_source,
        CAST(valid_from AS DATETIME2(6)) AS valid_from,
        CAST(COALESCE(LEAD(valid_from) OVER (PARTITION BY bkey_account ORDER BY valid_from),'2999-12-31 23:59:59.999999') AS DATETIME2(6)) AS valid_to
    FROM (
        SELECT bkey_account_source, bkey_account, bkey_source, valid_from, valid_to FROM mds_account_hierarchy_history
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
    tr.bkey_account_source,
    tr.bkey_account,
    tr.bkey_source,

    -- From Main Entity History Table (Time-Dependent Attributes)
    tr.bkey_account AS account_number,
    e1.AccountDescription AS account_description,
    e1.AccountCategory AS account_type,
    e1.ReportSign AS account_reporting_sign,
    e1.RunningTotalSign AS account_running_total_sign,
    
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
  
LEFT JOIN mds_account_hierarchy_history e1 
ON e1.bkey_account_source = tr.bkey_account_source
AND e1.valid_from <= tr.valid_from 
AND COALESCE(e1.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from
  
-- ===============================
-- JOIN SCD1 (Current) TABLE ON ID ONLY (1-to-1 Relationship)
-- Since these values do not change over time, we only keep the latest version.
-- ===============================