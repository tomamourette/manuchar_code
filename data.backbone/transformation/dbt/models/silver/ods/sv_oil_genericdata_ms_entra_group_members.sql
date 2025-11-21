WITH source_site_oil_genericdata_ms_entra_group_members AS (
    SELECT
        *
    FROM {{ source('oil_genericdata', 'MS_Entra_GroupMembers') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_site_oil_genericdata_ms_entra_group_members
)
 
SELECT
    *
FROM deduplicated