WITH supplier AS (
    SELECT 
        dyn.bkey_supplier_source,
        dyn.bkey_supplier_global,
        dyn.supplier_group,
        dyn.supplier_group_description,
        dyn.supplier_name,
        dyn.supplier_id,
        dyn.supplier_company,
        dyn.supplier_address,
        dyn.supplier_city,
        dyn.supplier_zip_code,
        dyn.supplier_affiliate,
        dyn.supplier_country_code,
        dyn.supplier_legal_number,
        dyn.valid_from,
        dyn.valid_to,
        dyn.is_current
    FROM {{ ref('supplier_dynamics') }} AS dyn
    UNION ALL
    SELECT
        mds.bkey_supplier_source,
        mds.bkey_supplier_global,
        mds.supplier_group,
        mds.supplier_group_description,
        mds.supplier_name,
        mds.supplier_id,
        mds.supplier_company,
        mds.supplier_address,
        mds.supplier_city,
        mds.supplier_zip_code,
        mds.supplier_affiliate,
        mds.supplier_country_code,
        mds.supplier_legal_number,
        mds.valid_from,
        mds.valid_to,
        mds.is_current
    FROM {{ ref('supplier_mds')}} AS mds
)

SELECT
    *
FROM supplier
