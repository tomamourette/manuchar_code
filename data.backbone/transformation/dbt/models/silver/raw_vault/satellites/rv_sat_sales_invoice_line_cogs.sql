WITH dynamics AS (
    SELECT 
        dyn.bkey_sales_invoice_line_cogs_source,
        dyn.bkey_sales_invoice,
        dyn.sales_invoice_line_cogs_company,
        dyn.sales_invoice_line_cogs_invoice_id,
        dyn.sales_invoice_line_cogs_line_num,

        --LineProductName AS sales_invoice_line_product_name,
        dyn.sales_invoice_line_cogs_quantity,
        dyn.sales_invoice_line_cogs_uom,
        dyn.sales_invoice_line_cogs_currency_code,
        dyn.sales_invoice_line_product_id,
        dyn.csv_sales_amount_m_local,
        dyn.csv_sales_amount_m_home,
        dyn.erp_sales_amount_m_local,
        dyn.erp_sales_amount_m_home,
        dyn.erp_cost_amount_posted,

        -- New Dynamics COGS columns
        dyn.erp_cogs1_purchase_amount_m_local,
        CAST(dyn.erp_cogs1_purchase_amount_m_local_currency AS VARCHAR(3)) AS erp_cogs1_purchase_amount_m_local_currency,
        dyn.erp_cogs1_purchase_amount_m_home,
        dyn.erp_cogs1_purchase_amount_m_group,

        dyn.erp_cogs1_freight_amount_m_local,
        CAST(dyn.erp_cogs1_freight_amount_m_local_currency AS VARCHAR(3)) AS erp_cogs1_freight_amount_m_local_currency,
        dyn.erp_cogs1_freight_amount_m_home,
        dyn.erp_cogs1_freight_amount_m_group,

        dyn.erp_cogs1_other_amount_m_local,
        CAST(dyn.erp_cogs1_other_amount_m_local_currency AS VARCHAR(3)) AS erp_cogs1_other_amount_m_local_currency,
        dyn.erp_cogs1_other_amount_m_home,
        dyn.erp_cogs1_other_amount_m_group,

        dyn.erp_cogs1_amount_m_local,
        CAST(dyn.erp_cogs1_amount_m_local_currency AS VARCHAR(3)) AS erp_cogs1_amount_m_local_currency,
        dyn.erp_cogs1_amount_m_home,
        dyn.erp_cogs1_amount_m_group,

        dyn.erp_cogs2_internal_transport_amount_m_local,
        CAST(dyn.erp_cogs2_internal_transport_amount_m_local_currency AS VARCHAR(3)) AS erp_cogs2_internal_transport_amount_m_local_currency,
        dyn.erp_cogs2_internal_transport_amount_m_home,
        dyn.erp_cogs2_internal_transport_amount_m_group,

        dyn.erp_cogs2_external_transport_amount_m_local,
        CAST(dyn.erp_cogs2_external_transport_amount_m_local_currency AS VARCHAR(3)) AS erp_cogs2_external_transport_amount_m_local_currency,
        dyn.erp_cogs2_external_transport_amount_m_home,
        dyn.erp_cogs2_external_transport_amount_m_group,

        dyn.erp_cogs2_other_amount_m_local,
        CAST(dyn.erp_cogs2_other_amount_m_local_currency AS VARCHAR(3)) AS erp_cogs2_other_amount_m_local_currency,
        dyn.erp_cogs2_other_amount_m_home,
        dyn.erp_cogs2_other_amount_m_group,

        -- New STG COGS column
        dyn.csv_cogs1_amount,
        dyn.csv_external_transport_amount,
        dyn.csv_internal_transport_amount,
        dyn.csv_other_cogs2_amount,
        dyn.csv_cogs2_amount,

        dyn.valid_from,
        dyn.valid_to,
        dyn.is_current
    FROM {{ ref('sales_invoice_line_cogs_dynamics')}} dyn
),

stg AS (
    SELECT 
        stg.bkey_sales_invoice_line_cogs_source,
        stg.bkey_sales_invoice,
        stg.sales_invoice_line_cogs_company,
        stg.sales_invoice_line_cogs_invoice_id,
        stg.sales_invoice_line_cogs_line_num,

        --LineProductName AS sales_invoice_line_product_name,
        stg.sales_invoice_line_cogs_quantity,
        stg.sales_invoice_line_cogs_uom,
        stg.sales_invoice_line_cogs_currency_code,
        stg.sales_invoice_line_product_id,
        stg.csv_sales_amount_m_local,
        stg.csv_sales_amount_m_home,
        stg.erp_sales_amount_m_local,
        stg.erp_sales_amount_m_home,
        stg.erp_cost_amount_posted,

        -- New Dynamics COGS columns
        stg.erp_cogs1_purchase_amount_m_local,
        CAST(stg.erp_cogs1_purchase_amount_m_local_currency AS VARCHAR(3)) AS erp_cogs1_purchase_amount_m_local_currency,
        stg.erp_cogs1_purchase_amount_m_home,
        stg.erp_cogs1_purchase_amount_m_group,

        stg.erp_cogs1_freight_amount_m_local,
        CAST(stg.erp_cogs1_freight_amount_m_local_currency AS VARCHAR(3)) AS erp_cogs1_freight_amount_m_local_currency,
        stg.erp_cogs1_freight_amount_m_home,
        stg.erp_cogs1_freight_amount_m_group,

        stg.erp_cogs1_other_amount_m_local,
        CAST(stg.erp_cogs1_other_amount_m_local_currency AS VARCHAR(3)) AS erp_cogs1_other_amount_m_local_currency,
        stg.erp_cogs1_other_amount_m_home,
        stg.erp_cogs1_other_amount_m_group,

        stg.erp_cogs1_amount_m_local,
        CAST(stg.erp_cogs1_amount_m_local_currency AS VARCHAR(3)) AS erp_cogs1_amount_m_local_currency,
        stg.erp_cogs1_amount_m_home,
        stg.erp_cogs1_amount_m_group,

        stg.erp_cogs2_internal_transport_amount_m_local,
        CAST(stg.erp_cogs2_internal_transport_amount_m_local_currency AS VARCHAR(3)) AS erp_cogs2_internal_transport_amount_m_local_currency,
        stg.erp_cogs2_internal_transport_amount_m_home,
        stg.erp_cogs2_internal_transport_amount_m_group,

        stg.erp_cogs2_external_transport_amount_m_local,
        CAST(stg.erp_cogs2_external_transport_amount_m_local_currency AS VARCHAR(3)) AS erp_cogs2_external_transport_amount_m_local_currency,
        stg.erp_cogs2_external_transport_amount_m_home,
        stg.erp_cogs2_external_transport_amount_m_group,

        stg.erp_cogs2_other_amount_m_local,
        CAST(stg.erp_cogs2_other_amount_m_local_currency AS VARCHAR(3)) AS erp_cogs2_other_amount_m_local_currency,
        stg.erp_cogs2_other_amount_m_home,
        stg.erp_cogs2_other_amount_m_group,

        -- New STG COGS column
        stg.csv_cogs1_amount,
        stg.csv_external_transport_amount,
        stg.csv_internal_transport_amount,
        stg.csv_other_cogs2_amount,
        stg.csv_cogs2_amount,

        stg.valid_from,
        stg.valid_to,
        stg.is_current
    FROM {{ ref('sales_invoice_line_cogs_stg')}} stg
)

--SELECT
--    *
--FROM dynamics
--UNION ALL
SELECT
    *
FROM stg