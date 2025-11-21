-- Auto Generated (Do not modify) 08ED74324AF6F0E723BAFDB3B7C83575FA95EA5CC0076940DEBF282AA7E8C2F6
create view "dds_finance"."dim_account_bc" as 

WITH
last_bv_account_header_bcPre AS (SELECT bkey_account_header, MAX(src_load_dt) AS max_load_dt FROM "dbb_warehouse"."mim"."bv_account_header_bc" group by bkey_account_header),

last_bv_account_header_bc AS (SELECT a.* FROM "dbb_warehouse"."mim"."bv_account_header_bc" a INNER JOIN last_bv_account_header_bcPre b ON a.bkey_account_header = b.bkey_account_header AND a.src_load_dt = b.max_load_dt)

,dim_pre AS (
    SELECT
        -- Keys
        CAST(ROW_NUMBER() OVER(ORDER BY ac.bkey_account) AS BIGINT) AS tkey_account,
	    CAST(ac.bkey_account AS VARCHAR(255)) AS bkey_account,
	    -- Attributes
        ac.account_number AS account_number,
        ac.account_description,
        COALESCE(ac.account_type, ach.account_header_type) AS account_type,
        ac.account_reporting_sign AS account_reporting_sign,
        ac.account_running_total_sign AS account_running_total_sign,
        ach.account_header_hierarchy_level_2 AS account_hierarchy_level_2,
        ach.account_header_hierarchy_level_3 AS account_hierarchy_level_3,
        ach.account_header_reporting_view AS account_reporting_view,
        ach.account_header_hierarchy_level_1 AS account_hierarchy_level_1,
        ach.account_header_detail AS account_detail,
        ach.account_header_sort_order AS account_sort_order,
        ach.account_header_calculation_type AS account_calculation_type,
      	-- History metadata
    	--CAST(ac.valid_from AS DATETIME2(6)) AS valid_from,
      	--CAST(ac.valid_to AS DATETIME2(6)) AS valid_to,
    	--CAST(COALESCE(ac.is_current, ach.is_current) AS BIT) AS is_current
        ac.src_load_dt,
        ac.is_deleted
    FROM "dbb_warehouse"."mim"."bv_account_bc" ac
    FULL JOIN last_bv_account_header_bc ach ON ac.account_number = ach.account_header_number
    where ach.account_header_reporting_view = 'Management View 2020' OR ach.account_header_reporting_view IS NULL -- filer only on the latest reporting view
),
dim_start_end AS (
    SELECT 
        tkey_account,
        bkey_account,
        account_number,
        account_description,
        account_type,
        account_reporting_sign,
        account_running_total_sign,
        account_hierarchy_level_2,
        account_hierarchy_level_3,
        account_reporting_view,
        account_hierarchy_level_1,
        account_detail,
        account_sort_order,
        account_calculation_type,
        --valid_from,
        --valid_to,
        --is_current
        src_load_dt as valid_from,
        COALESCE(LEAD(src_load_dt) over (partition by bkey_account order by bkey_account, src_load_dt),'9999-12-31 00:00:00') as valid_to,
        CASE WHEN LEAD(src_load_dt) over (partition by bkey_account order by bkey_account, src_load_dt) IS NULL THEN 1 ELSE 0 END as is_current,
        is_deleted
    FROM dim_pre
)
select * 
    ,CONCAT('7175f2c7-e1aa-404a-b8b2-0ed494ecb03a','_','"dbb_warehouse"."dds_finance"."dim_account_bc"') as model_exec_id
from dim_start_end;