WITH source_dynamics_ecoresproduct AS (
    SELECT 
        bkey_product_source,
        bkey_product,
        bkey_source,
        CAST(pd.valid_from AS DATETIME2(6)) AS ldts,
        CAST('Dynamics 365' AS VARCHAR(25)) AS record_source
    FROM {{ ref('product_dynamics') }} AS pd
), 

source_mds_product AS (
    SELECT 
        bkey_product_source,
        bkey_product,
        bkey_source,
        CAST(pm.valid_from AS DATETIME2(6)) AS ldts,
        CAST('MDS' AS VARCHAR(25)) AS record_source
    FROM {{ ref('product_mds') }} AS pm
), 

sources_combined AS (
    SELECT 
        bkey_product_source,
        bkey_product,
        bkey_source,
        ldts,
        record_source
    FROM source_dynamics_ecoresproduct
    UNION
    SELECT 
        bkey_product_source,
        bkey_product,
        bkey_source,
        ldts,
        record_source
    FROM source_mds_product
), 

sources_deduplicated AS (
    SELECT 
        bkey_product_source,
        bkey_product,
        bkey_source,
        ldts,
        record_source,
        ROW_NUMBER() OVER (PARTITION BY bkey_product_source ORDER BY ldts ASC) AS row_number
    FROM sources_combined
)

SELECT 
    bkey_product_source,
    bkey_product,
    bkey_source,
    ldts,
    record_source
FROM sources_deduplicated
WHERE row_number = 1;
