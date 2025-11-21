-- ===============================
-- STEP 1: Extracting Historical Data (SCD2)
-- Generating valid_from and valid_to using modifieddate
-- ===============================

WITH mds_account_headers_history AS (
  -- Entity attributes where only the latest version is relevant (SCD1)
	SELECT 
	    COALESCE(ar.Code, CONCAT(ah.Reporting_View, ' - ', Header)) + '_MDS' AS bkey_account_header_source,
        COALESCE(ar.Code, CONCAT(ah.Reporting_View, ' - ', Header)) AS bkey_account_header,
        'MDS' AS bkey_source,
	    Account_Code,
        Category,
	    COALESCE(Subheader, Header) AS Subheader,
	    COALESCE(Subheader2, Header) AS Subheader2,
	    COALESCE(ar.Reporting_View, ah.Reporting_View) AS Reporting_View,
	    Header,
	    Detail,
	    SortOrder,
	    CalcType,
	    CAST(ah.EnterDateTime AS DATETIME2(6)) AS valid_from,  -- Ensure precision
	    CAST(LEAD(ah.EnterDateTime) OVER (PARTITION BY COALESCE(ar.Code, CONCAT(ah.Reporting_View, ' - ', Header)) ORDER BY ah.EnterDateTime) AS DATETIME2(6)) AS valid_to
	FROM {{ ref("sv_mds_accountreporting") }} ar 
	FULL JOIN {{ ref("sv_mds_accountheaders") }} ah ON ah.Code = ar.MONA_Account_Header_Code -- FULL JOIN to include Headers with CalcType = 2
),
-- ===============================
-- STEP 2: Generate Time Ranges for SCD2
-- Consolidating timestamps across history sources to create a unified timeline
-- ===============================

timeranges AS (
   SELECT 
        bkey_account_header_source,
        bkey_account_header,
        bkey_source, 
        CAST(valid_from AS DATETIME2(6)) AS valid_from,
        CAST(COALESCE(LEAD(valid_from) OVER (PARTITION BY bkey_account_header ORDER BY valid_from),'2999-12-31 23:59:59.999999') AS DATETIME2(6)) AS valid_to
    FROM (
        SELECT bkey_account_header_source, bkey_account_header, bkey_source, valid_from, valid_to FROM mds_account_headers_history
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
    tr.bkey_account_header_source,
    tr.bkey_account_header,
    tr.bkey_source,

    -- From Main Entity History Table (Time-Dependent Attributes)
    e1.Account_Code AS account_header_number,
    e1.Category AS account_header_type,
    e1.Subheader AS account_header_hierarchy_level_2,
    e1.Subheader2 AS account_header_hierarchy_level_3,
    e1.Reporting_View AS account_header_reporting_view,
    e1.Header AS account_header_hierarchy_level_1,
    e1.Detail AS account_header_detail,
    e1.SortOrder AS account_header_sort_order,
    e1.CalcType AS account_header_calculation_type,

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
  
FULL JOIN mds_account_headers_history e1
ON e1.bkey_account_header_source = tr.bkey_account_header_source
AND e1.valid_from <= tr.valid_from 
AND COALESCE(e1.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from
  
-- ===============================
-- JOIN SCD1 (Current) TABLE ON ID ONLY (1-to-1 Relationship)
-- Since these values do not change over time, we only keep the latest version.
-- ===============================


