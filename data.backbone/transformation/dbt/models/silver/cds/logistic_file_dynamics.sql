-- ===============================
-- STEP 1: Extracting Historical Data (SCD2)
-- Generating valid_from and valid_to using modifieddate
-- ===============================

WITH logistic_file_history AS (
    SELECT 
        lft.recid AS tkey_logistic_file,
        lft.logisticfileid AS bkey_logistic_file,
        lft.logisticfileid + '_DYNAMICS' AS bkey_logistic_file_source,
        'DYNAMICS' AS bkey_source,
        lft.dataareaid AS logfile_company,
        lft.logisticfileid AS logfile_filenumber,
        lft.etd AS logfile_etsdate,
        lft.eta AS logfile_etadate,
        lft.mnrtitletransferdate AS logfile_bidate,
        lft.customerref AS logfile_cust_ref,
        lft.mnrtransportdocumentreference AS logfile_transport_doc_nb,
        lft.mnrvesselid AS logfile_vesselid,
        lft.mnrvoyagenum AS logfile_voyage_number,
        lft.centeridfrom AS logfile_loading_location,
        lft.mnrfromcountry AS logfile_loading_countrycode,
        lft.centeridto AS logfile_destination_location,
        lft.mnrtocountry AS logfile_destination_countrycode,
        lft.mnrfinaldestination AS logfile_finaldestincation_location,
        lft.mnrfinaldestinationcountry AS logfile_finaldestination_countrycode,
        lft.purchid AS logfile_purchase_order_id,
        lft.salesid AS logfile_sales_order_id,
        lft.unitid AS logfile_shipment_uom,
        CAST(lft.modifieddatetime AS DATETIME2(6)) AS valid_from,
        CAST(LEAD(lft.modifieddatetime) OVER (PARTITION BY lft.logisticfileid ORDER BY lft.modifieddatetime) AS DATETIME2(6)) AS valid_to
    FROM {{ ref('sv_dynamics_lgslogisticfiletable')}} lft
    LEFT JOIN {{ ref('sv_dynamics_purchtable')}} pur
        ON lft.purchid = pur.purchid
        AND lft.dataareaid = pur.dataareaid
    LEFT JOIN {{ ref('sv_dynamics_salestable')}} sal
        ON lft.salesid = sal.salesid
       AND lft.dataareaid = sal.dataareaid
    WHERE lft.logisticfileid IS NOT NULL
),

-- ===============================
-- STEP 2: Generate Time Ranges for SCD2
-- Consolidating timestamps separately for customer and vendor invoices
-- ===============================

logistic_file_timeranges AS (
    SELECT 
        tkey_logistic_file,
        CAST(valid_from AS DATETIME2(6)) AS valid_from,
        CAST(COALESCE(LEAD(valid_from) OVER (PARTITION BY tkey_logistic_file ORDER BY valid_from), '2999-12-31 23:59:59.999999') AS DATETIME2(6)) AS valid_to
    FROM logistic_file_history
)

-- ===============================
-- STEP 3: Combine Everything into a Full Entity Timeline
-- - SCD2 (history tables) are joined on recid + valid time range.
-- ===============================

SELECT distinct
    tr.tkey_logistic_file,
    e1.bkey_logistic_file,
    e1.bkey_logistic_file_source,
    e1.bkey_source,
    e1.logfile_company,
    e1.logfile_filenumber,
    e1.logfile_etsdate,
    e1.logfile_etadate,
    e1.logfile_bidate,
    e1.logfile_cust_ref,
    e1.logfile_transport_doc_nb,
    e1.logfile_vesselid,
    e1.logfile_voyage_number,
    e1.logfile_loading_location,
    e1.logfile_loading_countrycode,
    e1.logfile_destination_location,
    e1.logfile_destination_countrycode,
    e1.logfile_finaldestincation_location,
    e1.logfile_finaldestination_countrycode,
    e1.logfile_purchase_order_id,
    e1.logfile_sales_order_id,
    e1.logfile_shipment_uom,
    tr.valid_from,
    tr.valid_to,
    CASE 
        WHEN tr.valid_to = '2999-12-31 23:59:59.999999' THEN 1 
        ELSE 0
    END AS is_current
FROM logistic_file_timeranges tr
LEFT JOIN logistic_file_history e1
    ON e1.tkey_logistic_file = tr.tkey_logistic_file
    AND e1.valid_from <= tr.valid_from 
    AND COALESCE(e1.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from