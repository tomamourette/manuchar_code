-- Auto Generated (Do not modify) BD8B953E60E2869D782611CFB157155FFA0F9DEAA536238B12A0007AC944012A
create view "cds"."account_mds_bc" as -- ===============================


WITH mds_account_ingestion as (
    SELECT DISTINCT Account, ingestion_timestamp FROM "dbb_warehouse"."ods"."sv_mona_ts010s0_bc"
),
qry_join AS (
  -- Entity attributes where only the latest version is relevant (SCD1)
    SELECT 
	    ts010s0.Account + '_MDS' AS bkey_account_source,
	    ts010s0.Account AS bkey_account,
	    'MDS' AS bkey_source,
        ts010s0.Account AS account_number,
        smah.AccountDescription AS account_description,
        smah.AccountCategory AS account_type,
        smah.ReportSign AS account_reporting_sign,
        smah.RunningTotalSign AS account_running_total_sign,
		  --behouden?
        CAST(smah.EnterDateTime AS DATETIME2(6)) AS accounthierarchy_EnterDateTime,
        ts010s0.ingestion_timestamp as ts_010s0_ingestion_timestamp,
        smah.LastChgDateTime as accounthierarchy_LastChgDateTime,
        greatest(ts010s0.ingestion_timestamp, smah.LastChgDateTime) AS src_load_dt
	FROM mds_account_ingestion AS ts010s0
	LEFT JOIN "dbb_warehouse"."ods"."sv_mds_accounthierarchy_bc" smah ON smah.Code = ts010s0.Account
)

select * 
,CONCAT('a95db7a2-6e43-479e-a3ff-a54053ae439a','_','"dbb_warehouse"."cds"."account_mds_bc"') as model_exec_id
from qry_join;