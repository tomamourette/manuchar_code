-- ===============================
-- STEP 1: Extracting Historical Data (SCD2)
-- Generating valid_from and valid_to using modifieddate
-- ===============================

WITH purchase_order_line_history AS (
    SELECT
	    pl.recid,
	    pl.purchid,
	    pl.linenumber,
	    pl.dataareaid,
	    pl.name,
	    pl.dlvterm,
	    pl.qtyordered,
	    pl.purchunit,
	    pl.lineamount,
	    pl.currencycode,
	    pl.priceunit,
	    pl.dlvmode,
	    pl.createddatetime,
	    pl.purchstatus,
	    pl.inventdimid,
	    pl.partition,
	    pl.lgslogisticfileid,
	    pl.itemid,
	    pl.purchprice,
	    pl.vendaccount,
        IIF(pl.purchunit = 'bg', pl.purchqty * CAST(LEFT(ivs.inventsizeid, COALESCE(CHARINDEX('kg', ivs.inventsizeid), 1)-1) AS INT), pl.purchqty) AS qty,
        IIF(pl.purchunit = 'bg', pl.purchqty * CAST(LEFT(ivs.inventsizeid, COALESCE(CHARINDEX('kg', ivs.inventsizeid), 1)-1) AS INT), pl.purchqty) / uom.ConversionToMT AS qty_mt,
        IIF(pl.purchunit = 'bg', 'kg', pl.purchunit) AS uom,
        CAST(pl.modifieddatetime AS DATETIME2(6)) AS valid_from,
        CAST(LEAD(pl.modifieddatetime) OVER (PARTITION BY pl.recid ORDER BY pl.modifieddatetime) AS DATETIME2(6)) AS valid_to
    FROM {{ ref('sv_dynamics_purchline')}} pl
    LEFT JOIN {{ ref('sv_dynamics_inventsum')}} ivs
		ON pl.itemid = ivs.itemid
		AND pl.inventdimid = ivs.inventdimid
    LEFT JOIN {{ ref('sv_mds_uom')}} uom
		ON UPPER(IIF(pl.purchunit = 'bg', 'kg', pl.purchunit)) = uom.Code
    WHERE pl.dataareaid NOT IN ('acem', 'acemus', 'bau', 'mppa', 'mshan', 'mst', 'msthk', 'mwoo', 'ptc', 'tradum', 'meur')
),

-- ===============================
-- STEP 2: Generate Time Ranges for SCD2
-- Consolidating timestamps separately for customer and vendor invoices
-- ===============================

purchase_order_line_timeranges AS (
    SELECT 
        recid,
        CAST(valid_from AS DATETIME2(6)) AS valid_from,
        CAST(COALESCE(LEAD(valid_from) OVER (PARTITION BY recid ORDER BY valid_from), '2999-12-31 23:59:59.999999') AS DATETIME2(6)) AS valid_to
    FROM purchase_order_line_history
)

-- ===============================
-- STEP 3: Combine Everything into a Full Entity Timeline
-- - SCD2 (history tables) are joined on recid + valid time range.
-- ===============================

SELECT
    e1.recid AS tkey_purchase_order_line,
    CONVERT(VARCHAR, e1.purchid) + CONVERT(VARCHAR, e1.linenumber) + '_DYNAMICS' AS bkey_purchase_order_line_source,
    CONVERT(VARCHAR, e1.purchid) + CONVERT(VARCHAR, e1.linenumber) AS bkey_purchase_order_line,
    'DYNAMICS' AS bkey_source,
    e1.purchid AS purchase_order_line_purchase_id,
    e1.linenumber AS purchase_order_line_line_number,
    e1.dataareaid AS purchase_order_line_company,
    e1.name AS purchase_order_line_name,
    e1.dlvterm AS purchase_order_line_delivery_term,
    e1.qtyordered AS purchase_order_line_quantity_ordered,
    e1.purchunit AS purchase_order_line_purchase_unit,
    e1.lineamount AS purchase_order_line_amount_trans_cur,
    NULL AS purchase_order_line_amount_func_cur,
    NULL AS purchase_order_line_amount_group_cur_oanda_spot,
    NULL AS purchase_order_line_group_cur_oanda_rate,
    NULL AS purchase_order_line_func_cur_rate,
    e1.currencycode AS purchase_order_line_transactional_currency_code,
    'USD' AS purchase_order_line_group_currency_code,
    CONVERT(VARCHAR, NULL) AS purchase_order_line_functional_currency_code,
    e1.priceunit AS purchase_order_line_price_unit,
    e1.dlvmode AS purchase_order_line_delivery_mode,
    e1.createddatetime AS purchase_order_line_created_date_time,
    e1.purchstatus AS purchase_order_line_purchase_status,
    e1.inventdimid AS purchase_order_line_inventory_dimension_id,
    e1.partition AS purchase_order_line_partition,
    e1.lgslogisticfileid AS purchase_order_line_lgs_logistic_file_id,
    e1.itemid AS purchase_order_line_product_id,
    e1.purchprice AS purchase_order_line_purchase_price,
    e1.vendaccount AS purchase_order_line_vendor_account,
    e1.qty AS purchase_order_line_purchase_quantity,
    e1.qty_mt AS purchase_order_line_purchase_quantity_mt,
    e1.uom AS purchase_order_line_uom,
    tr.valid_from,
    tr.valid_to,
    CASE 
        WHEN tr.valid_to = '2999-12-31 23:59:59.999999' THEN 1 
        ELSE 0
    END AS is_current
FROM purchase_order_line_timeranges tr
LEFT JOIN purchase_order_line_history e1
    ON e1.recid = tr.recid 
    AND e1.valid_from <= tr.valid_from 
    AND COALESCE(e1.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from