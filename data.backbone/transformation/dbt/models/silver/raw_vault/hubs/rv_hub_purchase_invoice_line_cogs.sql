WITH source_purchase_invoice_line_cogs_dynamics_mits AS ( 
    SELECT 
        mits.bkey_purchase_invoice_line_cogs_source,
        mits.bkey_purchase_invoice_line_cogs,
        mits.bkey_source,
        mits.valid_from AS ldts,
        CAST('DYNAMICS' AS VARCHAR(25)) AS record_source
    FROM {{ ref('purchase_invoice_line_cogs_dynamics_mits') }} mits
),

source_purchase_invoice_line_cogs_dynamics_mst AS (
    SELECT
        mst.bkey_purchase_invoice_line_cogs_source,
        mst.bkey_purchase_invoice_line_cogs,
        mst.bkey_source,
        mst.valid_from AS ldts,
        CAST('DYNAMICS' AS VARCHAR(25)) AS record_source
    FROM {{ ref('purchase_invoice_line_cogs_dynamics_mst')}} mst
),

source_purchase_invoice_line_cogs_mtm AS (
    SELECT
        mtm.bkey_purchase_invoice_line_cogs_source,
        mtm.bkey_purchase_invoice_line_cogs,
        mtm.bkey_source,
        mtm.valid_from AS ldts,
        CAST('MTM' AS VARCHAR(25)) AS record_source
    FROM {{ ref('purchase_invoice_line_cogs_mtm')}} mtm
),

sources_combined AS (
    SELECT 
        mits.bkey_purchase_invoice_line_cogs_source,
        mits.bkey_purchase_invoice_line_cogs,
        mits.bkey_source,
        mits.ldts,
        mits.record_source
    FROM source_purchase_invoice_line_cogs_dynamics_mits mits
    UNION ALL
    SELECT
        mst.bkey_purchase_invoice_line_cogs_source,
        mst.bkey_purchase_invoice_line_cogs,
        mst.bkey_source,
        mst.ldts,
        mst.record_source
    FROM source_purchase_invoice_line_cogs_dynamics_mst mst
    UNION ALL
    SELECT
        mtm.bkey_purchase_invoice_line_cogs_source,
        mtm.bkey_purchase_invoice_line_cogs,
        mtm.bkey_source,
        mtm.ldts,
        mtm.record_source
    FROM source_purchase_invoice_line_cogs_mtm mtm
),

sources_deduplicated AS (
    SELECT 
        bkey_purchase_invoice_line_cogs_source,
        bkey_purchase_invoice_line_cogs,
        bkey_source,
        ldts,
        record_source,
        ROW_NUMBER() OVER (PARTITION BY bkey_purchase_invoice_line_cogs_source ORDER BY ldts ASC) AS row_number
    FROM sources_combined
)

SELECT 
    bkey_purchase_invoice_line_cogs_source,
    bkey_purchase_invoice_line_cogs,
    bkey_source,
    ldts,
    record_source
FROM sources_deduplicated
WHERE row_number = 1
