WITH source_dynamics_generaljournalentry AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM {{ source('dynamics', 'GeneralJournalEntry') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_generaljournalentry
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated

