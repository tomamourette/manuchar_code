-- ===============================
-- STEP 1: Extracting Historical Data (SCD2)
-- Generating valid_from and valid_to using modifieddate
-- ===============================

-- ===============================
-- STEP 2: Generate Time Ranges for SCD2
-- Consolidating timestamps across history sources to create a unified timeline
-- ===============================

-- ===============================
-- STEP 3: Extracting Current Data (SCD1)
-- Only Latest Record per Entity is Kept
-- ===============================

WITH mona_industry_current AS (
    -- Entity attributes where only the latest version is relevant (SCD1)
    SELECT 
        *,
        CAST(ODSIngestionDate AS DATETIME2(6)) AS valid_from,
        CAST(COALESCE(LEAD(ODSIngestionDate) OVER (PARTITION BY bkey_industry ORDER BY ODSIngestionDate),'2999-12-31 23:59:59.999999') AS DATETIME2(6)) AS valid_to
    FROM (
        SELECT 
            mdvd.DimensionDetailCode + '_MONA' AS bkey_industry_source,
            mdvd.DimensionDetailCode AS bkey_industry,
            'MONA' AS bkey_source,
            mdvd.DimensionDetailDescription,
            mdvd.ODSIngestionDate,
            ROW_NUMBER() OVER (PARTITION BY mdvd.DimensionDetailCode ORDER BY mdvd.ODSIngestionDate DESC) AS rn
        FROM {{ ref('sv_mona_td055c2')}} mdt
        LEFT JOIN {{ ref('sv_mona_v_dimensiondetail')}} mdvd ON mdt.ConsoID = mdvd.ConsoID AND mdt.Dim1DetailID = mdvd.DimensionDetailID 
        WHERE mdvd.DimensionCode = 'Industry'
    ) latest_values
    WHERE rn = 1
)

-- ===============================
-- STEP 4: Combine Everything into a Full Entity Timeline
-- - SCD2 (history tables) are joined on ID + valid time range.
-- - SCD1 (current tables) are joined on ID only.
-- ===============================

SELECT 
    ec1.bkey_industry_source,
    ec1.bkey_industry,
    ec1.bkey_source,

    -- From Main Entity History Table (Time-Dependent Attributes)
    ec1.DimensionDetailDescription AS industry_name,
    NULL AS industry_group,

    -- Metadata for time tracking
    ec1.valid_from,
    ec1.valid_to,
    CASE 
        WHEN ec1.valid_to = '2999-12-31 23:59:59.999999' THEN 1 
        ELSE 0
    END AS is_current

FROM mona_industry_current ec1

-- ===============================
-- JOIN SCD2 (History) TABLES ON ID + TIME RANGE
-- Ensures correct historical version is retrieved based on the event timestamp.
-- ===============================

-- ===============================
-- JOIN SCD1 (Current) TABLE ON ID ONLY (1-to-1 Relationship)
-- Since these values do not change over time, we only keep the latest version.
-- ===============================