-- Auto Generated (Do not modify) 65FB71DE553E0B69CB95AC3BC6F006C95D893A10DA5BCBA45C3B245C67E91C45
create view "data_mon"."quality_equity_fact_financial_statements" as WITH source_fact_kpi_equity AS (
	SELECT
		SUBSTRING(conso.bkey_consolidation_period, 1, 6) AS bkey_date,
		com.bkey_company AS bkey_affiliate,
		ffs.amount AS amount,
		'Fact Financial Statements' AS source_name,
		'Equity' AS kpi_name
	FROM "dbb_warehouse"."dds_finance"."fact_financial_statements" ffs
	LEFT JOIN "dbb_warehouse"."dds_finance"."dim_company" com
		ON ffs.tkey_company = com.tkey_company
	LEFT JOIN "dbb_warehouse"."dds_finance"."dim_account" acc
		ON ffs.tkey_account = acc.tkey_account
	LEFT JOIN "dbb_warehouse"."dds_finance"."dim_consolidation_period" conso
		ON ffs.tkey_consolidation_period = conso.tkey_consolidation_period
	WHERE acc.bkey_account IN ('100000', '101000', '110000', '120000', '130000', '131000', '132000', '133000', '134000', '136920', '140000', '145000', '136500')
		AND conso.bkey_consolidation_period LIKE '%IFR%'
		AND acc.account_reporting_view = 'Statutory View - IFRS'
		AND SUBSTRING(conso.bkey_consolidation_period, 1, 6) IN (FORMAT(DATEADD(MM, -1, GETDATE()), 'yyyyMM'), FORMAT(DATEADD(MM, -2, GETDATE()), 'yyyyMM'), FORMAT(DATEADD(MM, -3, GETDATE()), 'yyyyMM'))
),

source_fact_kpi_equity_aggregated AS (
	SELECT
		bkey_date,
		bkey_affiliate,
		SUM(amount) AS amount,
		source_name,
		kpi_name
	FROM source_fact_kpi_equity
	GROUP BY 
		bkey_date,
		bkey_affiliate,
		source_name,
		kpi_name
)

SELECT
	bkey_date,
	bkey_affiliate,
	amount,
	source_name,
	kpi_name
FROM source_fact_kpi_equity_aggregated;