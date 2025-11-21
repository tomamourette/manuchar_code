WITH source_oil_monaconso_ref_journal_mapping AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY journal ORDER BY journal DESC) AS rn
    FROM {{ source('oil_monaconso', 'JournalMapping') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_oil_monaconso_ref_journal_mapping
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated