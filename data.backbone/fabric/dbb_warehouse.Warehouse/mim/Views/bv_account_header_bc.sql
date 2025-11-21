-- Auto Generated (Do not modify) C91A2A15189D3AD81A3F9D716DF98907BCEB059D957BE1B271E0E09C4E46A67C
create view "mim"."bv_account_header_bc" as -- ===============================
-- STEP 1: Extracting Entity Data
-- From Different Sources in a Single CTE
-- ===============================



WITH source_account_header AS (
    SELECT
        hub.bkey_account_header,
        hub.bkey_source,
        sat.account_header_number,
        sat.account_header_type,
        sat.account_header_hierarchy_level_2,
        sat.account_header_hierarchy_level_3,
        sat.account_header_reporting_view,
        sat.account_header_hierarchy_level_1,
        sat.account_header_detail,
        sat.account_header_sort_order,
        sat.account_header_calculation_type,
        --sat.valid_from,
        --sat.valid_to
        src_load_dt
    FROM "dbb_warehouse"."mim"."rv_hub_account_header_bc" hub
    LEFT JOIN "dbb_warehouse"."mim"."rv_sat_account_header_bc" sat ON hub.bkey_account_header_source = sat.bkey_account_header_source
    --WHERE sat.is_current = 1 -- add only the latest version
)
select 
    *
    ,CONCAT('7175f2c7-e1aa-404a-b8b2-0ed494ecb03a','_','"dbb_warehouse"."mim"."bv_account_header_bc"') as model_exec_id 
    from source_account_header;