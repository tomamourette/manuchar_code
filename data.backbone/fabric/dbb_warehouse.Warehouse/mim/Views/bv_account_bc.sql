-- Auto Generated (Do not modify) C771A0E3EB7111E076BBCAA974B83A5DE3576A31B1DE0A7E69E3FC0A7B6A3E90
create view "mim"."bv_account_bc" as -- ===============================
-- STEP 1: Extracting Entity Data
-- From Different Sources in a Single CTE
-- ===============================


WITH source_account AS (
    SELECT
        hub.bkey_account,
        hub.bkey_source,
        sat.account_number,
        sat.account_description,
        sat.account_type,
        sat.account_reporting_sign,
        sat.account_running_total_sign,
        --sat.valid_from,
        --sat.valid_to
        src_load_dt,
        is_deleted
    FROM "dbb_warehouse"."mim"."rv_hub_account_bc" hub
    LEFT JOIN "dbb_warehouse"."mim"."rv_sat_account_bc" sat ON hub.bkey_account_source = sat.bkey_account_source
    --WHERE sat.is_current = 1 -- add only the latest version
)

select 
    *
    ,CONCAT('7175f2c7-e1aa-404a-b8b2-0ed494ecb03a','_','"dbb_warehouse"."mim"."bv_account_bc"') as model_exec_id 
    from source_account;