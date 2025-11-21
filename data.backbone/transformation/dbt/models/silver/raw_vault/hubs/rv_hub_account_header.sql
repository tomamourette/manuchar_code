WITH source_account_heeader_mds AS (
    SELECT 
        bkey_account_header_source,
        bkey_account_header,
        bkey_source,
        valid_from AS ldts,
        CAST('MDS' AS VARCHAR(25)) AS record_source
    FROM {{ ref('account_header_mds') }}
), 

sources_combined AS (
    SELECT 
        bkey_account_header_source,
        bkey_account_header,
        bkey_source,
        ldts,
        record_source
    FROM source_account_heeader_mds
),

sources_deduplicated AS (
    SELECT 
        bkey_account_header_source,
        bkey_account_header,
        bkey_source,
        ldts,
        record_source,
        ROW_NUMBER() OVER (PARTITION BY bkey_account_header_source ORDER BY ldts ASC) AS row_number
    FROM sources_combined
)

SELECT 
    bkey_account_header_source,
    bkey_account_header,
    bkey_source,
    ldts,
    record_source
FROM sources_deduplicated
WHERE row_number = 1