-- ===============================
-- STEP 1: Extracting Current Cost Center Data (SCD1)
-- Retrieve the latest record per cost center using ingestion_timestamp and ROW_NUMBER()
-- ===============================
WITH cost_center_current AS (
    SELECT *
    FROM (
        SELECT 
            Code + '_DBB_LAKEHOUE' AS bkey_cost_center_source,
            Code AS bkey_cost_center,
            'DBB_LAKEHOUSE' AS bkey_source,
            Code,
            Description,
            ingestion_timestamp AS valid_from,
            '2999-12-31 23:59:59.999999' AS valid_to,
            ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
        FROM {{ ref("sv_dbb_lakehouse_costcenter") }}  
        WHERE Code IS NOT NULL
    ) t
  WHERE rn = 1
),

-- ===============================
-- STEP 2: Generate Time Ranges for SCD1
-- Consolidate the valid_from timestamps into a unified timeline using LEAD logic
-- ===============================
timeranges AS (
    SELECT 
        bkey_cost_center_source,
        bkey_cost_center,
        bkey_source,
        CAST(valid_from AS DATETIME2(6)) AS valid_from,
        CAST(LEAD(valid_from, 1, '2999-12-31 23:59:59.999999') OVER (PARTITION BY bkey_cost_center ORDER BY valid_from) AS DATETIME2(6)) AS valid_to
    FROM cost_center_current
)

-- ===============================
-- STEP 3: Combine Everything into a Full Cost Center Timeline
-- Join the unified timeline (timeranges) with the current cost center data on Code and effective time range
-- ===============================
SELECT 
    tr.bkey_cost_center_source,
    tr.bkey_cost_center,
    tr.bkey_source,
    tr.bkey_cost_center as cost_center_code,
    cc.Description as cost_center_description,
    tr.valid_from,
    tr.valid_to,
    CASE 
        WHEN tr.valid_to = '2999-12-31 23:59:59.999999' THEN 1 
        ELSE 0
    END AS is_current
FROM timeranges tr
LEFT JOIN cost_center_current cc
ON cc.bkey_cost_center_source = tr.bkey_cost_center_source
AND cc.valid_from <= tr.valid_from
AND COALESCE(cc.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from;