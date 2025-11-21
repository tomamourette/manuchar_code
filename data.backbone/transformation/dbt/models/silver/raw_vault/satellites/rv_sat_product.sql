WITH product AS (
    SELECT 
        CAST(dyn.bkey_product_source AS VARCHAR(100)) AS bkey_product_source,
        CAST(dyn.product_global_code AS VARCHAR(50)) AS product_global_code,
        CAST(dyn.product_name AS VARCHAR(255)) AS product_name,
        CAST(dyn.product_company AS VARCHAR(50)) AS product_company,
        CAST(dyn.product_id AS VARCHAR(100)) AS product_id,
        dyn.valid_from,
        dyn.valid_to,
        dyn.is_current
    FROM {{ ref('product_dynamics') }} AS dyn

    UNION ALL

    SELECT 
        CAST(mds.bkey_product_source AS VARCHAR(100)) AS bkey_product_source,
        CAST(mds.product_global_code AS VARCHAR(50)) AS product_global_code,
        CAST(mds.product_name AS VARCHAR(255)) AS product_name,
        CAST(mds.product_company AS VARCHAR(50)) AS product_company,
        CAST(mds.product_id AS VARCHAR(100)) AS product_id,
        mds.valid_from,
        mds.valid_to,
        mds.is_current
    FROM {{ ref('product_mds') }} AS mds
)

SELECT *
FROM product;