WITH sales_invoice_line_dynamics AS (
    SELECT
        CAST(bkey_sales_invoice_line_source AS VARCHAR(100)) AS bkey_sales_invoice_line_source,
        CAST(bkey_sales_invoice AS VARCHAR(100)) AS bkey_sales_invoice,
        CAST(bkey_source AS VARCHAR) AS bkey_source,
        sales_invoice_id,
        CAST(sales_invoice_line_invoice_line_num AS DECIMAL(18, 0)) AS sales_invoice_line_invoice_line_num,
        sales_invoice_line_product_id,
        sales_invoice_line_product_name,
        sales_invoice_line_quantity,
        sales_invoice_line_quantity_mt,
        sales_invoice_line_uom,
        
        CAST(sales_invoice_line_amount_trans_cur AS DECIMAL(18,4)) AS sales_invoice_line_amount_trans_cur,
        CAST(sales_invoice_line_amount_func_cur AS DECIMAL(18,4)) AS sales_invoice_line_amount_func_cur,
        CAST(sales_invoice_line_amount_group_cur_conso_avg AS DECIMAL(18,4)) AS sales_invoice_line_amount_group_cur_conso_avg,
        CAST(sales_invoice_line_amount_group_cur_oanda_eod AS DECIMAL(18,4)) AS sales_invoice_line_amount_group_cur_oanda_eod,

        sales_invoice_line_group_cur_conso_avg_rate,
        sales_invoice_line_func_cur_rate,
        
        sales_invoice_line_company,
        sales_invoice_line_transactional_currency_code,
        sales_invoice_line_group_currency_code,
        sales_invoice_line_functional_currency_code,
        sales_invoice_line_ledger_voucher,
        CAST(sales_invoice_line_business_unit AS VARCHAR) AS sales_invoice_line_business_unit,
        CAST(sales_invoice_line_product_global_code AS VARCHAR(100)) AS sales_invoice_line_product_global_code,
        valid_from,
        valid_to,
        is_current
    FROM {{ ref('sales_invoice_line_dynamics') }}
),

sales_invoice_line_stg_sales AS (
    SELECT
        CAST(bkey_sales_invoice_line_source AS VARCHAR(100)) AS bkey_sales_invoice_line_source,
        CAST(bkey_sales_invoice AS VARCHAR(100)) AS bkey_sales_invoice,
        CAST(bkey_source AS VARCHAR) AS bkey_source,
        sales_invoice_id,
        CAST(sales_invoice_line_invoice_line_num AS DECIMAL(18, 0)) AS sales_invoice_line_invoice_line_num,
        sales_invoice_line_product_id,
        sales_invoice_line_product_name,
        CAST(sales_invoice_line_quantity AS DECIMAL(18, 2)) AS sales_invoice_line_quantity,
        sales_invoice_line_quantity_mt,
        sales_invoice_line_uom,
        
        CAST(sales_invoice_line_amount_trans_cur AS DECIMAL(18,4)) AS sales_invoice_line_amount_trans_cur,
        CAST(sales_invoice_line_amount_func_cur AS DECIMAL(18,4)) AS sales_invoice_line_amount_func_cur,
        CAST(sales_invoice_line_amount_group_cur_conso_avg AS DECIMAL(18,4)) AS sales_invoice_line_amount_group_cur_conso_avg,
        CAST(sales_invoice_line_amount_group_cur_oanda_eod AS DECIMAL(18,4)) AS sales_invoice_line_amount_group_cur_oanda_eod,

        sales_invoice_line_group_cur_conso_avg_rate,
        sales_invoice_line_func_cur_rate,

        sales_invoice_line_company,
        sales_invoice_line_transactional_currency_code,
        sales_invoice_line_group_currency_code,
        sales_invoice_line_functional_currency_code,
        CAST(sales_invoice_line_ledger_voucher AS VARCHAR) AS sales_invoice_line_ledger_voucher,
        CAST(sales_invoice_line_business_unit AS VARCHAR) AS sales_invoice_line_business_unit,
        CAST(sales_invoice_line_product_global_code AS VARCHAR(100)) AS sales_invoice_line_product_global_code,
        valid_from,
        valid_to,
        is_current
    FROM {{ ref('sales_invoice_line_stg_sales') }}
),

sales_invoice_line AS (
    SELECT * FROM sales_invoice_line_dynamics
    UNION ALL
    SELECT * FROM sales_invoice_line_stg_sales
)

SELECT 
    *
FROM sales_invoice_line
