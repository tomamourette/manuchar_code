WITH source_oil_monaconso_journal_mapping AS (
        SELECT 
            journal + '_oil_monaconso' AS bkey_journal_mapping_source,
            journal AS bkey_journal_mapping,
            'oil_monaconso' AS bkey_source,
            journal AS journal_mapping_code,
            allocation,
            bundle,
            bundle_local_adjustments,
            conso_adjusted,
            conso_legal,
            intercompany,
            manual,
            technical_eliminations,
            CAST('1900-01-01 00:00:00.000000' AS DATETIME2(6)) AS valid_from,
            CAST('2999-12-31 23:59:59.999999' AS DATETIME2(6)) AS valid_to,
            CASE 
                WHEN '2999-12-31 23:59:59.999999' = '2999-12-31 23:59:59.999999' THEN 1 
                ELSE 0 
            END AS is_current
    FROM {{ ref("sv_oil_monaconso_ref_journal_mapping") }}  
    WHERE journal IS NOT NULL
)

SELECT 
    *
FROM source_oil_monaconso_journal_mapping
