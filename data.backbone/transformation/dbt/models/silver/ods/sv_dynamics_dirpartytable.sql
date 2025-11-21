WITH source_dynamics_dirpartytable AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM {{ source('dynamics', 'DirectoryParty') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_dirpartytable
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated

