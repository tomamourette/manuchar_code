-- ===============================
-- STEP 1: Extracting Historical Data (SCD2)
-- Tracking business unit changes over time
-- ===============================
WITH dynamics_business_unit_history AS (
    -- Track only business unit changes (SCD2)
    SELECT 
        * 
    FROM (
        SELECT  
            LOWER(p.displayproductnumber) + '_DYNAMICS' AS bkey_product_global_source,
            LOWER(p.displayproductnumber) AS bkey_product_global,
            'DYNAMICS' AS bkey_source,
            cat1.name AS subcategory,
            cat3.name AS business_unit_raw,
            cat4.name AS parent_business_unit,
            IIF(cat1.level = 4, cat2.name, cat3.name) AS [ProductCategory],
            IIF(cat4.name IS NULL, NULL, CONCAT_WS('-', CONCAT('BU ', IIF(cat1.level = 4, cat3.name, cat4.name)), IIF(cat1.level = 4, cat2.name, cat3.name), cat1.name)) AS ProductGroup,
            CAST(IIF(cat1.level = 4, cat3.modifieddatetime, cat4.modifieddatetime) AS DATETIME2(6)) AS valid_from,
            LEAD(CAST(IIF(cat1.level = 4, cat3.modifieddatetime, cat4.modifieddatetime) AS DATETIME2(6))) OVER (PARTITION BY LOWER(p.displayproductnumber) ORDER BY IIF(cat1.level = 4, cat3.modifieddatetime, cat4.modifieddatetime)) AS valid_to,
            cat1.level,
            RANK() OVER (PARTITION BY LOWER(p.displayproductnumber) ORDER BY cat1.level DESC) AS rank_level
        FROM {{ ref("sv_dynamics_ecoresproduct") }} p 
        LEFT JOIN {{ ref("sv_dynamics_ecoresproductcategory") }} pc ON pc.product = p.recid
        LEFT JOIN {{ ref("sv_dynamics_ecorescategory") }} cat1 ON cat1.recid = pc.category
        LEFT JOIN {{ ref("sv_dynamics_ecorescategory") }} cat2 ON cat2.recid = cat1.parentcategory
        LEFT JOIN {{ ref("sv_dynamics_ecorescategory") }} cat3 ON cat3.recid = cat2.parentcategory -- Business Unit
        LEFT JOIN {{ ref("sv_dynamics_ecorescategory") }} cat4 ON cat4.recid = cat3.parentcategory
    ) a
    WHERE rank_level = 1 
),

-- ===============================
-- STEP 2: Generate Time Ranges for SCD2
-- Creating a unified timeline for business unit changes
-- ===============================
timeranges AS (
    SELECT  
        bkey_product_global_source,
        bkey_product_global,
        bkey_source,
        CAST(valid_from AS DATETIME2(6)) AS valid_from,
        CAST(LEAD(valid_from, 1, '2999-12-31 23:59:59.999999') OVER (PARTITION BY bkey_product_global_source ORDER BY valid_from) AS DATETIME2(6)) AS valid_to
    FROM dynamics_business_unit_history
    WHERE business_unit_raw IS NOT NULL
),

-- ===============================
-- STEP 3: Extracting Category Timestamps (SCD1)
-- Keeping only the latest category timestamps
-- ===============================
dynamics_ecores_category_current AS (
    SELECT 
        LOWER(t.displayproductnumber) + '_DYNAMICS' AS bkey_product_global_source,
        LOWER(t.displayproductnumber) AS bkey_product_global,
        'DYNAMICS' AS bkey_source,
        t.displayproductnumber,
        latest_category.category,
        latest_category.categoryhierarchy
    FROM {{ ref("sv_dynamics_ecoresproduct") }} AS t
    LEFT JOIN (
        SELECT 
            product,
            category,
            categoryhierarchy,
            ROW_NUMBER() OVER (PARTITION BY product ORDER BY modifieddatetime DESC) AS rn
        FROM {{ ref("sv_dynamics_ecoresproductcategory") }}
    ) AS latest_category
    ON latest_category.product = t.recid AND latest_category.rn = 1
),

-- ===============================
-- Extracting Category Hierarchy (SCD1)
-- Keeping only the latest category hierarchy
-- ===============================
dynamics_ecores_category_hierarchy_current AS (
    SELECT 
        ctc.bkey_product_global_source,
        ctc.bkey_product_global,
        ctc.bkey_source,
        ctc.displayproductnumber,
        ctc.category,
        latest_hierarchy.recid AS category_hierarchy_id,
        latest_hierarchy.name AS product_group
    FROM dynamics_ecores_category_current ctc
    LEFT JOIN (
        SELECT 
            recid,
            name,
            ROW_NUMBER() OVER (PARTITION BY recid ORDER BY recid DESC) AS rn
        FROM {{ ref("sv_dynamics_ecorescategoryhierarchy") }}
    ) latest_hierarchy
    ON latest_hierarchy.recid = ctc.categoryhierarchy AND latest_hierarchy.rn = 1
),

-- ===============================
-- Extracting Static Product Data (SCD1)
-- Keeping only the latest product details
-- ===============================
dynamics_ecores_product_current AS (
    SELECT  
        LOWER(displayproductnumber) + '_DYNAMICS' AS bkey_product_global_source,
        LOWER(displayproductnumber) AS bkey_product_global,
        'DYNAMICS' AS bkey_source,
        displayproductnumber,
        searchname
    FROM (
        SELECT 
            displayproductnumber, 
            searchname, 
            ROW_NUMBER() OVER (PARTITION BY LOWER(displayproductnumber) ORDER BY modifieddatetime DESC) AS rn
        FROM {{ ref("sv_dynamics_ecoresproduct") }}
        WHERE TRIM(displayproductnumber) IS NOT NULL
    ) latest_values    
    WHERE rn = 1
)

-- ===============================
-- STEP 4: Combine Everything into a Full Product Timeline
-- Merging SCD2 and SCD1 data sources
-- ===============================
SELECT
    bkey_product_global_source,
    bkey_product_global,
    bkey_source,
    product_group,
    product_group_category,
    product_group_subcategory,
    product_business_unit,
    product_global_name,
    valid_from,
    valid_to,
     CASE 
        WHEN valid_to = '2999-12-31 23:59:59.999999' THEN 1 
        ELSE 0
    END AS is_current
FROM (
    SELECT 
        tr.bkey_product_global_source,
        tr.bkey_product_global,
        tr.bkey_source,
        bu.ProductGroup AS product_group,
        bu.ProductCategory AS product_group_category,
        bu.subcategory AS product_group_subcategory,
        CASE 
            WHEN LOWER(bu.business_unit_raw) = 'dummy to allocate' 
            OR LOWER(bu.parent_business_unit) = 'dummy to allocate' 
                THEN NULL 
            WHEN bu.business_unit_raw IS NOT NULL OR bu.parent_business_unit IS NOT NULL 
                THEN CONCAT('BU ', IIF(bu.business_unit_raw IS NOT NULL, bu.business_unit_raw, bu.parent_business_unit)) 
            ELSE NULL 
        END AS product_business_unit,
        -- CONCAT_WS(' - ', UPPER(IIF(bu.business_unit_raw IS NOT NULL, bu.business_unit_raw, bu.parent_business_unit)), REPLACE(bu.subcategory, ' (MAP)', '')) AS bkey_product_global, -- future bkey_product_global?
        ep.searchname AS product_global_name,
        COALESCE(tr.valid_from, '1900-01-01 00:00:00.000000') AS valid_from,
        COALESCE(tr.valid_to, '2999-12-31 23:59:59.999999') AS valid_to,
        ROW_NUMBER() OVER (PARTITION BY tr.bkey_product_global, CONCAT('BU ', IIF(bu.business_unit_raw IS NOT NULL, bu.business_unit_raw, bu.parent_business_unit)) ORDER BY COALESCE(tr.valid_from, '1900-01-01 00:00:00.000000') DESC ) AS rn

    FROM timeranges tr
    LEFT JOIN dynamics_business_unit_history bu
        ON bu.bkey_product_global_source = tr.bkey_product_global_source
        AND bu.valid_from <= tr.valid_from  
        AND COALESCE(bu.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from
    
    LEFT JOIN dynamics_ecores_product_current ep
        ON ep.bkey_product_global_source = tr.bkey_product_global_source
) t 
WHERE t.rn = 1;
