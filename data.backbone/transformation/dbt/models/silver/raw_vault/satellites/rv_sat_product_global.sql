WITH product AS (
    SELECT 
        CAST(dyn.bkey_product_global_source AS VARCHAR(100)) AS bkey_product_global_source,
        CAST(dyn.product_global_name AS VARCHAR(100)) AS product_global_name,
        CAST(dyn.product_group AS VARCHAR(100)) AS product_group,
        CAST(dyn.product_group_category AS VARCHAR(100)) AS product_group_category,
        CAST(dyn.product_group_subcategory AS VARCHAR(100)) AS product_group_subcategory,
        CAST(dyn.product_business_unit AS VARCHAR(100)) AS product_business_unit,
        dyn.valid_from,
        dyn.valid_to,
        dyn.is_current
    FROM {{ ref('product_global_dynamics') }} AS dyn

    UNION ALL

    SELECT 
        CAST(mds.bkey_product_global_source AS VARCHAR(100)) AS bkey_product_global_source,
        CAST(mds.product_global_name AS VARCHAR(100)) AS product_global_name,
        CAST(mds.product_group AS VARCHAR(100)) AS product_group,
        CAST(mds.product_group_category AS VARCHAR(100)) AS product_group_category,
        CAST(mds.product_group_subcategory AS VARCHAR(100)) AS product_group_subcategory,
        CAST(mds.product_business_unit AS VARCHAR(100)) AS product_business_unit,
        mds.valid_from,
        mds.valid_to,
        mds.is_current
    FROM {{ ref('product_global_mds') }} AS mds
)

SELECT *
FROM product;