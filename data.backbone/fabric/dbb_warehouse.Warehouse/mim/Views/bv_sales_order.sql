-- Auto Generated (Do not modify) 3161B96C49B94F317A9B6B4FACD92434C3EEA126156A88BA9AC527A18BD01FEE
create view "mim"."bv_sales_order" as WITH sales_order AS (
    SELECT 
        hub.bkey_sales_order,
        hub.bkey_source,
        sat.sales_order_sales_id,
        --sat.sales_order_sales_status,
        sat.sales_order_currencycode,
        sat.sales_order_cust_account,
        sat.sales_order_sales_amount_accrual,
        sat.sales_order_sales_volume_accrual,
        sat.sales_order_sales_volume_mt_accrual,
        sat.sales_order_sales_accrual_accounting_date,
        sat.sales_order_company,
        sales_order_ledger_voucher,
        sat.sales_order_ledger_account_value,
        sat.sales_order_ledger_account,
        sat.sales_order_procen_value,
        sat.valid_from,
        sat.valid_to,
        sat.is_current
    FROM "dbb_warehouse"."mim"."rv_hub_sales_order" hub
    LEFT JOIN "dbb_warehouse"."mim"."rv_sat_sales_order" sat ON hub.bkey_sales_order_source = sat.bkey_sales_order_source
    WHERE hub.bkey_source = 'DYNAMICS'
)

SELECT 
    *
FROM sales_order;