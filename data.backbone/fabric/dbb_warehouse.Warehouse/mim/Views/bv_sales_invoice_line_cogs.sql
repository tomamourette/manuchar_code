-- Auto Generated (Do not modify) EA03CE32A3F5FBA94105EDA9E0A9E9116AF9A84C181A3E35EF9EE7864B750E6A
create view "mim"."bv_sales_invoice_line_cogs" as WITH sales_invoice_line_cogs AS (
    SELECT
        hub.bkey_sales_invoice_line_cogs,
        hub.bkey_source,
        sat.bkey_sales_invoice,
        sat.sales_invoice_line_cogs_company,
        sat.sales_invoice_line_cogs_invoice_id,
        sat.sales_invoice_line_cogs_line_num,

        --LineProductName AS sales_invoice_line_product_name,
        sat.sales_invoice_line_cogs_quantity,
        sat.sales_invoice_line_cogs_uom,
        sat.sales_invoice_line_cogs_currency_code,
        sat.sales_invoice_line_product_id,
        sat.csv_sales_amount_m_local,
        sat.csv_sales_amount_m_home,
        sat.erp_sales_amount_m_local,
        sat.erp_sales_amount_m_home,
        sat.erp_cost_amount_posted,

        -- New Dynamics COGS columns
        sat.erp_cogs1_purchase_amount_m_local,
        sat.erp_cogs1_purchase_amount_m_local_currency,
        sat.erp_cogs1_purchase_amount_m_home,
        sat.erp_cogs1_purchase_amount_m_group,

        sat.erp_cogs1_freight_amount_m_local,
        sat.erp_cogs1_freight_amount_m_local_currency,
        sat.erp_cogs1_freight_amount_m_home,
        sat.erp_cogs1_freight_amount_m_group,

        sat.erp_cogs1_other_amount_m_local,
        sat.erp_cogs1_other_amount_m_local_currency,
        sat.erp_cogs1_other_amount_m_home,
        sat.erp_cogs1_other_amount_m_group,

        sat.erp_cogs1_amount_m_local,
        sat.erp_cogs1_amount_m_local_currency,
        sat.erp_cogs1_amount_m_home,
        sat.erp_cogs1_amount_m_group,

        sat.erp_cogs2_internal_transport_amount_m_local,
        sat.erp_cogs2_internal_transport_amount_m_local_currency,
        sat.erp_cogs2_internal_transport_amount_m_home,
        sat.erp_cogs2_internal_transport_amount_m_group,

        sat.erp_cogs2_external_transport_amount_m_local,
        sat.erp_cogs2_external_transport_amount_m_local_currency,
        sat.erp_cogs2_external_transport_amount_m_home,
        sat.erp_cogs2_external_transport_amount_m_group,

        sat.erp_cogs2_other_amount_m_local,
        sat.erp_cogs2_other_amount_m_local_currency,
        sat.erp_cogs2_other_amount_m_home,
        sat.erp_cogs2_other_amount_m_group,

        -- New STG COGS column
        sat.csv_cogs1_amount,
        sat.csv_external_transport_amount,
        sat.csv_internal_transport_amount,
        sat.csv_other_cogs2_amount,
        sat.csv_cogs2_amount,

        sat.valid_from,
        sat.valid_to,
        sat.is_current
    FROM "dbb_warehouse"."mim"."rv_hub_sales_invoice_line_cogs" hub
    LEFT JOIN "dbb_warehouse"."mim"."rv_sat_sales_invoice_line_cogs" sat ON hub.bkey_sales_invoice_line_cogs_source = sat.bkey_sales_invoice_line_cogs_source
)

SELECT
    *
FROM sales_invoice_line_cogs;