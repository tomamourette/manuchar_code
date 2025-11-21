WITH stock_invent_sum AS (
    SELECT 
    	*
    FROM (
    	SELECT
		    CONCAT(sdis.dataareaid, '_', sdis.inventdimid, '_', sdis.itemid) AS bkey_stock,
		    sdis.dataareaid,
		    sdis.inventdimid,
		    sdis.itemid,
		    sdis.inventbatchid,
		    sdis.reservphysical,
		    sdis.inventlocationid,
		    sdis.ordered,
			ROW_NUMBER() OVER (
	            PARTITION BY sdis.dataareaid, sdis.inventdimid, sdis.itemid
	            ORDER BY modifieddatetime DESC
	        ) AS rn
	    FROM {{ ref("sv_dynamics_inventsum") }} sdis
	    --WHERE inventbatchid = '000532D'
	    WHERE 
		    IsDelete IS NULL
    ) s
    WHERE rn = 1
),

stock_trans AS (
    SELECT 
        CONCAT(sdit.dataareaid, '_', sdit.inventdimid, '_', sdit.itemid) AS bkey_stock,
        MIN(CASE WHEN sdit.datephysical = '1900-01-01 00:00:00.0000000' THEN NULL ELSE datephysical END) AS datephysical, 
        MIN(CASE WHEN sdit.dateinvent = '1900-01-01 00:00:00.0000000' THEN NULL ELSE dateinvent END) AS dateinvent, 
        MAX(CASE WHEN sdit.dateclosed = '1900-01-01 00:00:00.0000000' THEN NULL ELSE dateclosed END) AS dateclosed 
    FROM {{ ref("sv_dynamics_inventtrans") }} sdit
    --5 is excluded since datephysical and dateinvent are 1900-01-01
    --status 0 is for NEGATIVE quantities (excluded) and cost amounts: 1/2/3 is for POSITIVE quantities and cost amounts
    WHERE sdit.statusreceipt IN (1,2,3)
    --AND CONCAT(sdit.dataareaid, '_', sdit.inventdimid, '_', sdit.itemid) = 'meur_#000000015001F0BC_100194'
    GROUP BY 
        sdit.itemid, 
        sdit.inventdimid, 
        sdit.dataareaid
),

stock_invent_trans AS (
    SELECT         
        CONCAT(sdit.dataareaid, '_', sdit.inventdimid, '_', sdit.itemid) AS bkey_stock,
        ISNULL(st.invoiceaccount, '') AS invoiceaccount,
        sdit.ingestion_timestamp,
        /* we integrate extra logic confirmed by Sam Bonte
        INFO: physicaldate = date when cost amount is booked; inventdate = date when quantity is confirmed but no cost booking yet
        if physicaldate is within month => we take cost and quantity
        if physicaldate is 1900-01-01 BUT Inventdate is within month => we take cost (which is zero by default since there is no physicaldate) and quantity
        if physicaldate is greater than month BUT inventdate is within month => we replace cost by zero (we don't take it into account since cost was booked in next month) 
        BUT we take quantity since there was an inventdate within the month
        */
        SUM(CASE
            WHEN (sdit.datephysical > sdit.ingestion_timestamp AND sdit.dateinvent <= sdit.ingestion_timestamp) THEN 0
            ELSE costamountposted
            END) +
        SUM(CASE
            WHEN (sdit.datephysical > sdit.ingestion_timestamp AND sdit.dateinvent <= sdit.ingestion_timestamp) THEN 0
            ELSE costamountadjustment
            END) AS costamount,
        SUM(costamountposted) AS costamountposted,
        SUM(costamountadjustment) AS costamountadjustment,
        SUM(sdit.qty) AS qty
    FROM {{ ref("sv_dynamics_inventtrans") }} sdit
    LEFT JOIN {{ ref("sv_dynamics_inventtransorigin") }} ito ON sdit.inventtransorigin = ito.recid
    LEFT JOIN {{ ref("sv_dynamics_salesline") }} sl ON sl.inventtransid = ito.inventtransid
	LEFT JOIN {{ ref("sv_dynamics_salestable") }} st ON st.salesid = sl.salesid
    WHERE (sdit.datephysical <= sdit.ingestion_timestamp AND sdit.datephysical > '1900-01-01') OR (sdit.dateinvent <= sdit.ingestion_timestamp AND sdit.dateinvent > '1900-01-01')
    GROUP BY 
        sdit.itemid, 
        sdit.inventdimid, 
        sdit.dataareaid,
        st.invoiceaccount,
        sdit.ingestion_timestamp
),

stock_dynamics AS (
    SELECT
        sdis.bkey_stock + '_' + sdit.invoiceaccount + '_DYNAMICS' AS bkey_stock_source,
        sdis.bkey_stock + '_' + sdit.invoiceaccount AS bkey_stock,
        'DYNAMICS' AS bkey_source,
        UPPER(sdis.dataareaid) AS stock_company,
        sdit.invoiceaccount AS stock_customer_id,
        COALESCE(comh.Value, ts014m.InfoText) AS stock_currency,
        CAST(DATEADD(DAY, 7 - DATEPART(WEEKDAY, sdit.ingestion_timestamp) + 1, CAST(sdit.ingestion_timestamp AS DATE)) AS DATETIME2(6)) AS stock_closure_date,
        CAST(IIF(sdt.dateinvent < sdt.datephysical, sdt.dateinvent, sdt.datephysical) AS DATETIME2(6)) AS stock_entry_date,
        sdil.name AS stock_warehouse_name,
        sdil.inventlocationid AS stock_invent_location_id,
        sdil.inventsiteid AS stock_site_id,
        sdis.inventbatchid AS stock_lot_number,
        sdis.itemid AS stock_product_code,
        sdis.itemid AS stock_product_id,
        sdit.qty AS stock_quantity,
        CAST(sdit.qty AS DECIMAL) / iif(UPPER(uom.unitid) = 'L', 1000, iif(UPPER(uom.unitid) in ('ADMT', 'DMT'), 1, ConversionToMT)) AS stock_quantity_mt,
        UPPER(uom.unitid) AS stock_uom,
        sdit.costamount AS stock_amount_func_cur,
        NULL AS stock_amount_group_conso_eom,
        NULL AS stock_amount_group_oanda_eod,
        CASE WHEN sdis.reservphysical > (sdit.qty / 2) THEN '1' ELSE '0' END AS stock_committed,
        IIF(sdil.inventlocationtype IN (2, 10, 11), 1, 0) AS stock_in_transit,
        sdit.ingestion_timestamp AS valid_from,
        COALESCE(LEAD(sdit.ingestion_timestamp) OVER (PARTITION BY sdis.bkey_stock, sdit.invoiceaccount ORDER BY sdit.ingestion_timestamp), CAST(GETDATE() AS DATETIME2(6))) AS valid_to
        
    FROM stock_invent_sum sdis
    LEFT JOIN {{ ref("sv_dynamics_inventlocation") }} sdil
        ON sdil.inventlocationid = sdis.inventlocationid
        AND sdil.dataareaid = sdis.dataareaid 
    LEFT JOIN stock_trans sdt
        ON sdt.bkey_stock = sdis.bkey_stock
    LEFT JOIN stock_invent_trans sdit
        ON sdit.bkey_stock = sdis.bkey_stock
    LEFT JOIN {{ ref("sv_mona_ts014c0") }} ts14c
            ON UPPER(sdis.dataareaid) = ts14c.CompanyCode
            AND ts14c.ConsoID = 29422
    LEFT JOIN {{ ref("sv_mona_ts014m1") }} ts014m
        ON ts014m.CompanyID = ts14c.CompanyID
        AND ts014m.ConsoID = 29422
        AND ts014m.AddInfoID = 46
    LEFT JOIN {{ ref("sv_mds_companyhistory") }} comh
        ON UPPER(sdis.dataareaid) = comh.Company_Code
        AND sdit.ingestion_timestamp BETWEEN comh.[Start_Date] AND comh.[End_Date]
        AND comh.[Key] = 'Home Currency'
    LEFT JOIN {{ ref("sv_dynamics_inventtablemodule") }} uom
    ON uom.itemid = sdis.itemid
    AND uom.moduletype = 0
    AND uom.modifieddatetime = (
        SELECT MAX(modifieddatetime)
        FROM {{ ref("sv_dynamics_inventtablemodule") }} sub
        WHERE sub.itemid = uom.itemid
        AND sub.moduletype = 0
    )
    LEFT JOIN {{ ref('sv_mds_uom') }} muom 
        ON muom.Code = UPPER(uom.unitid)

    --entry date is not NULL
    WHERE CONVERT(DATE, COALESCE(sdt.datephysical, sdt.dateinvent)) IS NOT NULL
    --AND sdis.inventbatchid IS NOT NULL
    --only show records with entry date BEFORE or equal to closuredate --> not required since we might have records with physicaldate in dec, but invent date in nov (and these need to be included for november)
    --AND CONVERT(date, coalesce(sdt.datephysical, sdt.dateinvent)) <= EOMONTH(sdit.valid_from)
    AND ordered = 0
    --both quantity and cost amount should not be zero
    AND NOT (sdit.qty = 0 AND sdit.costamountadjustment = 0 AND sdit.costamountposted = 0)
    --do not take 2024 or older data for MPH and MNIG
)

SELECT 
    bkey_stock_source,
    bkey_stock,
    bkey_source,
    stock_company,
    stock_customer_id,
    stock_currency,
    stock_closure_date,
    stock_entry_date,
    stock_warehouse_name,
    stock_invent_location_id,
    stock_site_id,
    stock_lot_number,
    stock_product_code,
    stock_product_id,
    stock_quantity,
    stock_quantity_mt,
    stock_uom,
    stock_amount_func_cur,
    stock_amount_group_conso_eom,
    stock_amount_group_oanda_eod,
    stock_committed,
    stock_in_transit,
    valid_from, 
    valid_to,
    CASE 
        WHEN valid_to = CAST(GETDATE() AS DATETIME2(6)) THEN 1 
        ELSE 0
    END AS is_current
FROM stock_dynamics