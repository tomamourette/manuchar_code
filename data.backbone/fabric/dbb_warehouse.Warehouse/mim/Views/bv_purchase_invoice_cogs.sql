-- Auto Generated (Do not modify) F551B1AC777F95818937B2DFBBF34096E79FC143EF8E957FD2FA836BB8DA2C32
create view "mim"."bv_purchase_invoice_cogs" as WITH purchase_invoice_cogs AS (
    SELECT
	    tkey_purchase_invoice_cogs,
	    bkey_purchase_invoice_line_source,
        bkey_purchase_invoice_line,
    	bkey_purchase_order_source,
    	bkey_purchase_order,
    	bkey_source,
	    purchase_invoice_cogs_line_number,
        purchase_invoice_cogs_company,
        purchase_invoice_cogs_product,
        purchase_invoice_cogs_line_description,
        purchase_invoice_cogs_quantity,
        purchase_invoice_cogs_unit_of_measure,
        purchase_invoice_cogs_currency_code,
        purchase_invoice_cogs_line_amount,
        purchase_invoice_cogs_line_amount_mst,
        purchase_invoice_cogs_ledger_account,
        erp_cogs1_purchasing_home_currency_amount,
        erp_cogs1_purchasing_local_currency_amount,
        erp_cogs1_purchasing_local_currency,
        erp_cogs1_purchasing_group_currency_amount,
        erp_cogs1_freight_home_currency_amount,
        erp_cogs1_freight_local_currency_amount,
        erp_cogs1_freight_local_currency,
        erp_cogs1_freight_group_currency_amount,
        erp_cogs1_other_home_currency_amount,
        erp_cogs1_other_local_currency_amount,
        erp_cogs1_other_local_currency,
        erp_cogs1_other_group_currency_amount,
        purchase_invoice_cogs_ledger_account_code,
        purchase_invoice_cogs_description,
        valid_from,
        valid_to,
        is_current
    FROM "dbb_warehouse"."mim"."rv_sat_purchase_invoice_cogs"
)

SELECT
    *
FROM purchase_invoice_cogs;