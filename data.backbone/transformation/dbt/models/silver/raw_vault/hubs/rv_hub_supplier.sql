WITH source_dynamics_vendtable AS (
    SELECT 
        bkey_supplier_source,
        bkey_supplier,
        bkey_source,
        CAST(sd.valid_from AS DATETIME2(6)) AS ldts,
        CAST('Dynamics 365' AS VARCHAR(25)) AS record_source
    FROM {{ ref('supplier_dynamics') }} AS sd
), 

source_mds_businesspartnercompanies AS (
    SELECT
        sm.bkey_supplier_source,
        sm.bkey_supplier,
        sm.bkey_source,
        CAST(sm.valid_from AS DATETIME2(6)) AS ldts,
        CAST('MDS' AS VARCHAR(25)) AS record_source
    FROM {{ ref('supplier_mds')}} AS sm
),

sources_combined AS (
    SELECT 
        bkey_supplier_source,
        bkey_supplier,
        bkey_source,
        ldts,
        record_source
    FROM source_dynamics_vendtable
    UNION ALL
    SELECT
        bkey_supplier_source,
        bkey_supplier,
        bkey_source,
        ldts,
        record_source
    FROM source_mds_businesspartnercompanies
), 

sources_deduplicated AS (
    SELECT 
        bkey_supplier_source,
        bkey_supplier,
        bkey_source,
        ldts,
        record_source,
        ROW_NUMBER() OVER (PARTITION BY bkey_supplier_source ORDER BY ldts ASC) AS row_number
    FROM sources_combined
)

SELECT 
    bkey_supplier_source,
    bkey_supplier,
    bkey_source,
    ldts,
    record_source
FROM sources_deduplicated
WHERE row_number = 1;
