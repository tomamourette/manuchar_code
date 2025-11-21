WITH dynamics AS (
    SELECT
        cdat.tkey_date AS tkey_created_date,
        adat.tkey_date AS tkey_accounting_date,
        prd.tkey_product AS tkey_product,
        com.tkey_company AS tkey_company,
        sup.tkey_supplier AS tkey_supplier,
        inc.tkey_incoterm AS tkey_incoterm,
        pay.tkey_payment_term AS tkey_payment_term,
        orig.tkey_country AS tkey_country_origin,
        dest.tkey_country AS tkey_country_destination,
        brg.file_number,
	    brg.lot_number,
	    brg.invoice_supplier_id,
	    brg.local_supplier_id,
	    brg.local_product,
	    brg.internal_invoice_id,
        brg.purchase_id,
		brg.line_number,
	    brg.adjusted_cogs_functional,
        brg.adjusted_cogs_transactional,
        brg.adjusted_cogs_group,
        brg.cogs1_purchase_amount_functional,
        brg.cogs1_purchase_amount_transactional,
        brg.cogs1_purchase_amount_group,
        brg.cogs1_freight_amount_functional,
        brg.cogs1_freight_amount_transactional,
        brg.cogs1_freight_amount_group,
        brg.cogs1_other_amount_functional,
        brg.cogs1_other_amount_transactional,
        brg.cogs1_other_amount_group
    FROM {{ ref('bv_brg_purchasing_landing_costs')}} brg
    LEFT JOIN {{ ref('dim_date')}} cdat
	    ON brg.bkey_created_date = cdat.date
    LEFT JOIN {{ ref('dim_date')}} adat
    	ON brg.bkey_accounting_date = adat.date
    LEFT JOIN {{ ref('dim_product')}} prd
	    ON brg.bkey_product = prd.bkey_product
    LEFT JOIN {{ ref('dim_company')}} com
	    ON brg.bkey_company = com.bkey_company
	    AND com.is_current = 1
    LEFT JOIN {{ ref('dim_supplier')}} sup
	    ON brg.bkey_supplier = sup.bkey_supplier
		AND sup.is_current = 1
    LEFT JOIN {{ ref('dim_incoterm')}} inc
		ON brg.bkey_incoterm = inc.bkey_incoterm
    LEFT JOIN {{ ref('dim_payment_term')}} pay
	    ON brg.bkey_payment_term = pay.bkey_payment_term	
	LEFT JOIN {{ ref('dim_country')}} orig
		ON brg.bkey_country_origin = orig.bkey_country
	LEFT JOIN {{ ref('dim_country')}} dest
		ON brg.bkey_country_destination = dest.bkey_country
)

SELECT
    *
FROM dynamics