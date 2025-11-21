-- ===============================
-- STEP 1: Extracting Historical Data (SCD2)
-- Generating valid_from and valid_to using modifieddate
-- ===============================

WITH logistic_file_line_history AS (
    SELECT
        lfl.recid AS tkey_logistic_file_line,
        lfl.logisticfileid + '_' + ISNULL(CONVERT(VARCHAR, purl.linenumber), '') + '_' + ISNULL(CONVERT(VARCHAR, sall.linenum), '') AS bkey_logistic_file_line,
        lfl.logisticfileid + '_' + ISNULL(CONVERT(VARCHAR, purl.linenumber), '') + '_' + ISNULL(CONVERT(VARCHAR, sall.linenum), '') + '_DYNAMICS' AS bkey_logistic_file_line_source,
        'DYNAMICS' AS bkey_source,
        lfl.dataareaid AS logfileline_company,
        lfl.logisticfileid AS logfileline_filenumber,
        lfl.purchlinerecid AS logfileline_purchlinerecid,
        lfl.purchid AS logfileline_purchid,
        purl.linenumber AS logfileline_purchase_line_num,
        lfl.saleslinerecid AS logfileline_saleslinerecid,
        lfl.salesid AS logfileline_salesid,
        sall.linenum AS logfileline_sales_line_num,
        lfl.itemid AS logfileline_product_id,
        lfl.itemname AS logfileline_description,
        lfl.qty AS logfileline_quantity,
        lfl.mnrgrossquantity AS logfileline_grossquantity,
        lfl.unitid AS logfileline_UOM,
        lfl.mnrnumofpackages AS logfileline_number_of_packages,
        NULL AS logfile_number_of_packages_unit,
        CAST(lfl.modifieddatetime AS DATETIME2(6)) AS valid_from,
        CAST(LEAD(lfl.modifieddatetime) OVER (PARTITION BY lfl.recid ORDER BY lfl.recid) AS DATETIME2(6)) AS valid_to
    FROM {{ ref('sv_dynamics_lgslogisticfileline')}} lfl
    LEFT JOIN {{ ref('sv_dynamics_purchline')}} purl
        ON lfl.purchlinerecid = purl.recid
    LEFT JOIN {{ ref('sv_dynamics_salesline')}} sall
        ON lfl.saleslinerecid = sall.recid
    WHERE lfl.IsDelete IS NULL
      AND purl.IsDelete IS NULL
      AND sall.IsDelete IS NULL
),

-- ===============================
-- STEP 2: Generate Time Ranges for SCD2
-- Consolidating timestamps separately for customer and vendor invoices
-- ===============================

logistic_file_line_timeranges AS (
    SELECT 
        tkey_logistic_file_line,
        CAST(valid_from AS DATETIME2(6)) AS valid_from,
        CAST(COALESCE(LEAD(valid_from) OVER (PARTITION BY tkey_logistic_file_line ORDER BY valid_from), '2999-12-31 23:59:59.999999') AS DATETIME2(6)) AS valid_to
    FROM logistic_file_line_history
)

-- ===============================
-- STEP 3: Combine Everything into a Full Entity Timeline
-- - SCD2 (history tables) are joined on recid + valid time range.
-- ===============================

SELECT distinct
    tr.tkey_logistic_file_line,
    e1.bkey_logistic_file_line,
    e1.bkey_logistic_file_line_source,
    e1.bkey_source,
    e1.logfileline_company,
    e1.logfileline_filenumber,
    e1.logfileline_purchlinerecid,
    e1.logfileline_purchid,
    e1.logfileline_purchase_line_num,
    e1.logfileline_saleslinerecid,
    e1.logfileline_salesid,
    e1.logfileline_sales_line_num,
    e1.logfileline_product_id,
    e1.logfileline_description,
    e1.logfileline_quantity,
    e1.logfileline_grossquantity,
    e1.logfileline_UOM,
    e1.logfileline_number_of_packages,
    e1.logfile_number_of_packages_unit,
    tr.valid_from,
    tr.valid_to,
    CASE 
        WHEN tr.valid_to = '2999-12-31 23:59:59.999999' THEN 1 
        ELSE 0
    END AS is_current
FROM logistic_file_line_timeranges tr
LEFT JOIN logistic_file_line_history e1
    ON e1.tkey_logistic_file_line = tr.tkey_logistic_file_line
    AND e1.valid_from <= tr.valid_from 
    AND COALESCE(e1.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from