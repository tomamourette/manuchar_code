-- ===============================
-- STEP 1: Extracting Historical Data (SCD2)
-- Tracking changes in product grouping details over time
-- ===============================

WITH mds_productgroup_history AS (
    SELECT 
        p.Code + '_MDS' AS bkey_product_global_source,
        p.Code AS bkey_product_global,
        'MDS' AS bkey_source,
        pg.Product_Business_Unit_Name,
        CASE 
            WHEN ROW_NUMBER() OVER (
                    PARTITION BY p.Code
                    ORDER BY pg.LastChgDateTime
                ) = 1 
            THEN CAST('1900-01-01' AS DATETIME2(6))
            ELSE CAST(pg.LastChgDateTime AS DATETIME2(6))
        END AS valid_from,
        LEAD(CAST(pg.LastChgDateTime AS DATETIME2(6))) OVER (
            PARTITION BY p.Code
            ORDER BY p.LastChgDateTime
        ) AS valid_to
    FROM  {{ ref("sv_mds_product") }} p
    LEFT JOIN {{ ref("sv_mds_productgroupingmapping") }} pgm ON p.Code = pgm.Product_Code_Code
    LEFT JOIN {{ ref("sv_mds_productgrouping") }} pg ON pgm.Product_Grouping_Code_Code = pg.Code
    WHERE p.Code IS NOT NULL
),

-- ===============================
-- STEP 2: Generate Time Ranges for SCD2
-- Consolidating timestamps for a unified timeline
-- ===============================

timeranges AS (
    SELECT 
        bkey_product_global_source,
        bkey_product_global,
        bkey_source,
        CAST(valid_from AS DATETIME2(6)) AS valid_from,
        CAST(COALESCE(LEAD(valid_from) OVER (PARTITION BY bkey_product_global ORDER BY valid_from),'2999-12-31 23:59:59.999999') AS DATETIME2(6)) AS valid_to
    FROM (
        SELECT bkey_product_global_source, bkey_product_global, bkey_source, valid_from, valid_to FROM mds_productgroup_history
    ) AS time_events
),


-- ===============================
-- STEP 3: Extracting Current Data (SCD1)
-- Only Latest Record per Product is Kept
-- ===============================

mds_product_current AS (
    SELECT 
        *
    FROM (
        SELECT 
            p.Code + '_MDS' AS bkey_product_global_source,
            p.Code AS bkey_product_global,
            'MDS' AS bkey_source,
            p.Code,
            p.Name,
            ROW_NUMBER() OVER (PARTITION BY p.Code ORDER BY p.LastChgDateTime DESC) AS rn
        FROM {{ ref("sv_mds_product") }} p
    ) latest_values
    WHERE rn = 1
),

mds_productgrouping_current AS (
    SELECT 
        *
    FROM (
        SELECT 
            p.Code + '_MDS' AS bkey_product_global_source,
            p.Code AS bkey_product_global,
            'MDS' AS bkey_source,
            pg.Name,
            pg.Product_Category,
            pg.Product_Sub_Category,
            ROW_NUMBER() OVER (PARTITION BY p.Code ORDER BY p.LastChgDateTime DESC) AS rn
        FROM {{ ref("sv_mds_product") }} p
        LEFT JOIN {{ ref("sv_mds_productgroupingmapping") }} pgm ON p.Code = pgm.Product_Code_Code
        LEFT JOIN {{ ref("sv_mds_productgrouping") }} pg ON pgm.Product_Grouping_Code_Code = pg.Code
    ) latest_values
    WHERE rn = 1
)

-- ===============================
-- STEP 4: Combine Everything into a Full Product Timeline
-- - SCD2 (history) is joined on ProductCode + valid time range.
-- - SCD1 (current) is joined on ProductCode only.
-- ===============================

SELECT 
    tr.bkey_product_global_source,
    tr.bkey_product_global,
    tr.bkey_source,   
    ec1.Name AS product_global_name,
    ec2.Name AS product_group,
    ec2.Product_Category AS product_group_category,
    ec2.Product_Sub_Category AS product_group_subcategory,
    e1.Product_Business_Unit_Name AS product_business_unit,
    tr.valid_from,
    tr.valid_to,
    CASE 
        WHEN tr.valid_to = '2999-12-31 23:59:59.999999' THEN 1 
        ELSE 0
    END AS is_current
FROM timeranges tr

-- ===============================
-- JOIN SCD2 (History) TABLE ON bkey_product_global + TIME RANGE
-- ===============================

LEFT JOIN mds_productgroup_history e1 
ON e1.bkey_product_global_source = tr.bkey_product_global_source
AND e1.valid_from <= tr.valid_from 
AND COALESCE(e1.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from

-- ===============================
-- JOIN SCD1 (Current) TABLE ON bkey_product_global ONLY
-- ===============================

LEFT JOIN mds_product_current ec1
ON ec1.bkey_product_global_source = tr.bkey_product_global_source

LEFT JOIN mds_productgrouping_current ec2
ON ec2.bkey_product_global_source = tr.bkey_product_global_source
