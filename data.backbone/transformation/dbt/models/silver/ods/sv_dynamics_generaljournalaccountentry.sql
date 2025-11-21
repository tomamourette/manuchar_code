WITH source_dynamics_generaljournalaccountentry AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM {{ source('dynamics', 'GeneralJournalAccountEntry') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_generaljournalaccountentry
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated

