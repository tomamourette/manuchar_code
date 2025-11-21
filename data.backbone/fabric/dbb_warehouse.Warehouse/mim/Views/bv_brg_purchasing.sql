-- Auto Generated (Do not modify) 5445380A9902655B69B44D7260BBD064DBFA8D1A7A14AFB8E8CAA84904E75621
create view "mim"."bv_brg_purchasing" as -- DYNAMICS
WITH dynamics AS (
    SELECT 
        pur.bkey_purchase_order,
        -- Date Keys
		CONVERT(DATETIME2(6), pur.purchase_order_invoice_date, 120) AS bkey_date,
        CONVERT(DATETIME2(6), pur.purchase_order_accounting_date, 120) AS bkey_closure_date,
        -- Dimension Keys
		pur.purchase_order_product AS bkey_product,
		UPPER(pur.purchase_order_company) + '_' + pur.purchase_order_invoice_account AS bkey_supplier,
		pur.purchase_order_transactional_currency_code AS bkey_currency_transactional,
		pur.purchase_order_group_currency_code AS bkey_currency_group,
		pur.purchase_order_functional_currency_code AS bkey_currency_functional,
        UPPER(pur.purchase_order_company) AS bkey_company,
		pur.purchase_order_incoterm AS bkey_incoterm,
		pur.purchase_order_payment AS bkey_payment_term,
		pur.purchase_order_origin_country AS bkey_country_origin,
		pur.purchase_order_destination_country AS bkey_country_destination,
		-- Fact Fields
		pur.bkey_purchase_order AS file_number,
		NULL AS lot_number,
		pur.purchase_order_invoice_account AS invoice_supplier_id,
		NULL AS local_supplier_id,
		pur.purchase_order_local_product AS local_product,
		pur.purchase_order_internal_invoice_id AS internal_invoice_id,
		pur.purchase_order_line_number AS line_number,
		pur.purchase_order_amount_trans_cur AS invoice_amount_transactional_currency,
		pur.purchase_order_amount_func_cur AS invoice_amount_functional_currency,
		pur.purchase_order_amount_group_cur_oanda_eod AS invoice_amount_group_currency_oanda_eod,
		-- Numerical Fields
		pur.purchase_order_group_cur_oanda_eod_rate AS group_cur_oanda_eod_rate,
		pur.purchase_order_func_cur_rate AS func_cur_rate,
		pur.purchase_order_quantity AS quantity,
		pur.purchase_order_quantity_mt AS quantity_mt,
		pur.purchase_order_uom AS unit_of_measure
    FROM "dbb_warehouse"."mim"."bv_purchase_order" pur
    LEFT JOIN "dbb_warehouse"."dds_finance"."dim_date" dat
        ON CONVERT(CHAR(8), pur.valid_from, 112) = dat.bkey_date
    WHERE pur.bkey_source = 'DYNAMICS'
	AND pur.is_current = 1
)

SELECT
    bkey_purchase_order,
    bkey_date,
    bkey_closure_date,
    bkey_product,
	bkey_supplier,
	bkey_currency_transactional,
	bkey_currency_group,
	bkey_currency_functional,
    bkey_company,
	bkey_incoterm,
	bkey_payment_term,
	bkey_country_origin,
	bkey_country_destination,
	file_number,
	lot_number,
	invoice_supplier_id,
	local_supplier_id,
	local_product,
	internal_invoice_id,
	line_number,
	invoice_amount_transactional_currency,
	invoice_amount_functional_currency,
	invoice_amount_group_currency_oanda_eod,
	group_cur_oanda_eod_rate,
	func_cur_rate,
	quantity,
	quantity_mt,
	unit_of_measure
FROM dynamics;