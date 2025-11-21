WITH sales_order AS (
    SELECT 
        bkey_sales_order_source,
        bkey_source,
        sales_order_sales_id,
        sales_order_currencycode,
        sales_order_cust_account,
        sales_order_sales_amount_accrual,
        sales_order_sales_volume_accrual,
        sales_order_sales_volume_mt_accrual,
        sales_order_sales_accrual_accounting_date,
        sales_order_company,
        sales_order_ledger_voucher,
        sales_order_ledger_account_value,
        sales_order_ledger_account,
        sales_order_procen_value,
        valid_from,
        valid_to,
        is_current 
    FROM {{ ref('sales_order_dynamics') }} 
)

SELECT 
    *
FROM sales_order