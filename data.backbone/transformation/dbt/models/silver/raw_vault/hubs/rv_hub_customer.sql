WITH source_customer_mds AS (
    SELECT 
        bkey_customer_source,
        bkey_customer,
        bkey_source,
        valid_from AS ldts,
        CAST('MDS' AS VARCHAR(25)) AS record_source
    FROM {{ ref('customer_mds') }}
), 

source_customer_dynamics AS (
    SELECT 
        bkey_customer_source,
        bkey_customer,
        bkey_source,
        valid_from AS ldts,
        CAST('Dynamics' AS VARCHAR(25)) AS record_source
    FROM {{ ref('customer_dynamics') }}
), 

sources_combined AS (
    SELECT 
        bkey_customer_source,
        bkey_customer,
        bkey_source,
        ldts,
        record_source
    FROM source_customer_mds
    UNION
    SELECT 
        bkey_customer_source,
        bkey_customer,
        bkey_source,
        ldts,
        record_source
    FROM source_customer_dynamics
), 

sources_deduplicated AS (
    SELECT 
        bkey_customer_source,
        bkey_customer,
        bkey_source,
        ldts,
        record_source,
        ROW_NUMBER() OVER (PARTITION BY bkey_customer_source ORDER BY ldts ASC) AS row_number
    FROM sources_combined
)

SELECT 
    bkey_customer_source,
    bkey_customer,
    bkey_source,
    ldts,
    record_source
FROM sources_deduplicated
WHERE row_number = 1