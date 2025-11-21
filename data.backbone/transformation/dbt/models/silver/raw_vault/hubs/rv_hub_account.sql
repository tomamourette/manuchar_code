WITH source_account_mds AS (
    SELECT 
        bkey_account_source,
        bkey_account,
        bkey_source,
        valid_from AS ldts,
        CAST('MDS' AS VARCHAR(25)) AS record_source
    FROM {{ ref('account_mds') }}
),

sources_combined AS (
    SELECT 
        bkey_account_source,
        bkey_account,
        bkey_source,
        ldts,
        record_source
    FROM source_account_mds
), 

sources_deduplicated AS (
    SELECT 
        bkey_account_source,
        bkey_account,
        bkey_source,
        ldts,
        record_source,
        ROW_NUMBER() OVER (PARTITION BY bkey_account_source ORDER BY ldts ASC) AS row_number
    FROM sources_combined
)

SELECT
    bkey_account_source,
    bkey_account,
    bkey_source,
    ldts,
    record_source
FROM sources_deduplicated
WHERE row_number = 1