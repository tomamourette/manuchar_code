WITH dynamics AS (
    SELECT
	    dat.tkey_date AS tkey_invoice_date,
	    cdat.tkey_date AS tkey_closure_date,
	    prd.tkey_product AS tkey_product,
	    sup.tkey_supplier AS tkey_supplier,
	    tcur.tkey_currency AS tkey_currency_transactional,
		gcur.tkey_currency AS tkey_currency_group,
		fcur.tkey_currency AS tkey_currency_functional,
	    com.tkey_company AS tkey_company,
	    inc.tkey_incoterm AS tkey_incoterm,
	    pay.tkey_payment_term AS tkey_payment_term,
		orig.tkey_country AS tkey_country_origin,
		orig.tkey_country AS tkey_country_destination,
	    brg.file_number,
	    brg.lot_number,
	    brg.invoice_supplier_id,
	    brg.local_supplier_id,
	    brg.local_product,
	    brg.internal_invoice_id,
		brg.line_number,
		brg.invoice_amount_transactional_currency,
		brg.invoice_amount_functional_currency,
		brg.invoice_amount_group_currency_oanda_eod,
		brg.group_cur_oanda_eod_rate,
		brg.func_cur_rate,
		brg.quantity,
		brg.quantity_mt,
	    brg.unit_of_measure
    FROM {{ ref('bv_brg_purchasing')}} brg
    LEFT JOIN {{ ref('dim_date')}} dat
	    ON brg.bkey_date = dat.date
    LEFT JOIN {{ ref('dim_date')}} cdat
    	ON brg.bkey_closure_date = cdat.date
    LEFT JOIN {{ ref('dim_product')}} prd
	    ON brg.bkey_product = prd.bkey_product
    LEFT JOIN {{ ref('dim_supplier')}} sup
	    ON brg.bkey_supplier = sup.bkey_supplier
		AND sup.is_current = 1
    LEFT JOIN {{ ref('dim_currency')}} tcur
	    ON brg.bkey_currency_transactional = tcur.bkey_currency
	LEFT JOIN {{ ref('dim_currency')}} gcur
		ON brg.bkey_currency_group = gcur.bkey_currency
	LEFT JOIN {{ ref('dim_currency')}} fcur
		ON brg.bkey_currency_functional = fcur.bkey_currency
    LEFT JOIN {{ ref('dim_company')}} com
	    ON brg.bkey_company = com.bkey_company
	    AND com.is_current = 1
    LEFT JOIN {{ ref('dim_payment_term')}} pay
	    ON brg.bkey_payment_term = pay.bkey_payment_term
	LEFT JOIN {{ ref('dim_incoterm')}} inc
		ON brg.bkey_incoterm = inc.bkey_incoterm
	LEFT JOIN {{ ref('dim_country')}} orig
		ON brg.bkey_country_origin = orig.bkey_country
	LEFT JOIN {{ ref('dim_country')}} dest
		ON brg.bkey_country_destination = dest.bkey_country
)

SELECT
    *
FROM dynamics