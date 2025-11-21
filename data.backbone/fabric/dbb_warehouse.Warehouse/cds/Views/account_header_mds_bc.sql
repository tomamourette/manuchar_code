-- Auto Generated (Do not modify) 5B34F6F0170DC1BDAB70B90E52CCDB4DBA09CFF4B2DC7C5CDF4F75C18F5EEE3D
create view "cds"."account_header_mds_bc" as 

WITH qry_join AS (
  -- Entity attributes where only the latest version is relevant (SCD1)
	SELECT 
	    COALESCE(ar.Code, CONCAT(ah.Reporting_View, ' - ', Header)) + '_MDS' AS bkey_account_header_source,
        COALESCE(ar.Code, CONCAT(ah.Reporting_View, ' - ', Header)) AS bkey_account_header,
        'MDS' AS bkey_source,
	    Account_Code AS account_header_number,
        Category AS account_header_type,
	    COALESCE(Subheader, Header) AS account_header_hierarchy_level_2,
	    COALESCE(Subheader2, Header) AS account_header_hierarchy_level_3,
	    COALESCE(ar.Reporting_View, ah.Reporting_View) AS account_header_reporting_view,
	    Header AS account_header_hierarchy_level_1,
	    Detail AS account_header_detail,
	    SortOrder AS account_header_sort_order,
	    CalcType AS account_header_calculation_type,
		--behouden?
		--CAST(ah.EnterDateTime AS DATETIME2(6)) AS valid_from,
		CAST(ah.EnterDateTime AS DATETIME2(6)) AS accountreporting_EnterDateTime,
		CAST(ah.EnterDateTime AS DATETIME2(6)) AS accountheaders_EnterDateTime,
		--
        ar.LastChgDateTime AS accountreporting_LastChgDateTime,  
        ah.LastChgDateTime AS accountheaders_LastChgDateTime, 
	    greatest(ar.LastChgDateTime,ah.LastChgDateTime) as src_load_dt
	FROM "dbb_warehouse"."ods"."sv_mds_accountreporting_bc" ar 
	FULL JOIN "dbb_warehouse"."ods"."sv_mds_accountheaders_bc" ah ON ah.Code = ar.MONA_Account_Header_Code -- FULL JOIN to include Headers with CalcType = 2
)

select * 
,CONCAT('7175f2c7-e1aa-404a-b8b2-0ed494ecb03a','_','"dbb_warehouse"."cds"."account_header_mds_bc"') as model_exec_id
from qry_join;