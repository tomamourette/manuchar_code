WITH source_dynamics_dirpartylocation AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM {{ source('dynamics', 'DirectoryPartyLocation') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_dirpartylocation
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated

