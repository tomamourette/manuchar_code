-- Auto Generated (Do not modify) 708A9B4658D839780B9B026AF5C1FA714DBB0235B8C4B897E1A785199F31CC18
create view "mim"."bv_brg_purchasing_landing_costs" as --DYNAMICS
WITH dynamics AS (
    SELECT
        pur.bkey_purchase_invoice_line_cogs,
        --Date Keys
        CONVERT(DATETIME2(6), pur.purchase_invoice_line_cogs_created_date_time) AS bkey_created_date,
        CONVERT(DATETIME2(6), pur.purchase_invoice_line_cogs_accounting_date) AS bkey_accounting_date,
        -- Dimension Keys
        pur.purchase_invoice_line_cogs_product AS bkey_product,
        UPPER(pur.purchase_invoice_line_cogs_company) AS bkey_company,
        UPPER(pur.purchase_invoice_line_cogs_company) + '_' + pur.purchase_invoice_line_cogs_invoice_account AS bkey_supplier,
        pur.purchase_invoice_line_cogs_incoterm AS bkey_incoterm,
		pur.purchase_invoice_line_cogs_payment AS bkey_payment_term,
		pur.purchase_invoice_line_cogs_origin_country AS bkey_country_origin,
		pur.purchase_invoice_line_cogs_destination_country AS bkey_country_destination,
        -- Fact Fields
		pur.purchase_invoice_line_cogs_file_number AS file_number,
        NULL AS lot_number,
		pur.purchase_invoice_line_cogs_invoice_account AS invoice_supplier_id,
		NULL AS local_supplier_id,
		NULL AS local_product,
		pur.purchase_invoice_line_cogs_internal_invoice_id AS internal_invoice_id,
        pur.purchase_invoice_line_cogs_purchase_id AS purchase_id,
		pur.purchase_invoice_line_cogs_line_number AS line_number,
        -- Numerical Fields
        pur.purchase_invoice_line_cogs_adjusted_cogs_functional AS adjusted_cogs_functional,
        pur.purchase_invoice_line_cogs_adjusted_cogs_transactional AS adjusted_cogs_transactional,
        pur.purchase_invoice_line_cogs_adjusted_cogs_group AS adjusted_cogs_group,
        pur.purchase_invoice_line_cogs_cogs1_purchase_amount_functional AS cogs1_purchase_amount_functional,
        pur.purchase_invoice_line_cogs_cogs1_purchase_amount_transactional AS cogs1_purchase_amount_transactional,
        pur.purchase_invoice_line_cogs_cogs1_purchase_amount_group AS cogs1_purchase_amount_group,
        pur.purchase_invoice_line_cogs_cogs1_freight_amount_functional AS cogs1_freight_amount_functional,
        pur.purchase_invoice_line_cogs_cogs1_freight_amount_transactional AS cogs1_freight_amount_transactional,
        pur.purchase_invoice_line_cogs_cogs1_freight_amount_group AS cogs1_freight_amount_group,
        pur.purchase_invoice_line_cogs_cogs1_other_amount_functional AS cogs1_other_amount_functional,
        pur.purchase_invoice_line_cogs_cogs1_other_amount_transactional AS cogs1_other_amount_transactional,
        pur.purchase_invoice_line_cogs_cogs1_other_amount_group AS cogs1_other_amount_group
    FROM "dbb_warehouse"."mim"."bv_purchase_invoice_line_cogs" pur
    LEFT JOIN "dbb_warehouse"."dds_finance"."dim_date" dat
        ON CONVERT(CHAR(8), pur.valid_from, 112) = dat.bkey_date
    WHERE pur.bkey_source = 'DYNAMICS'
	    AND pur.is_current = 1
)

SELECT
    bkey_purchase_invoice_line_cogs,
    bkey_created_date,
    bkey_accounting_date,
    bkey_product,
    bkey_company,
    bkey_supplier,
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
    purchase_id,
    line_number,
    adjusted_cogs_functional,
    adjusted_cogs_transactional,
    adjusted_cogs_group,
    cogs1_purchase_amount_functional,
    cogs1_purchase_amount_transactional,
    cogs1_purchase_amount_group,
    cogs1_freight_amount_functional,
    cogs1_freight_amount_transactional,
    cogs1_freight_amount_group,
    cogs1_other_amount_functional,
    cogs1_other_amount_transactional,
    cogs1_other_amount_group
FROM dynamics;