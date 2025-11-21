-- Auto Generated (Do not modify) 65FB71DE553E0B69CB95AC3BC6F006C95D893A10DA5BCBA45C3B245C67E91C45
create view "data_mon"."kpi_reconciliation" as WITH kpi_sources AS (
    SELECT
        bkey_date,
	    bkey_affiliate,
	    amount,
	    source_name,
	    kpi_name
    FROM "dbb_warehouse"."data_mon"."quality_equity_mona_onprem"
    UNION ALL
    SELECT
        bkey_date,
	    bkey_affiliate,
	    amount,
	    source_name,
	    kpi_name
    FROM "dbb_warehouse"."data_mon"."quality_equity_mona_oil"
    UNION ALL
    SELECT
        bkey_date,
        bkey_affiliate,
        amount,
        source_name,
        kpi_name
    FROM "dbb_warehouse"."data_mon"."quality_equity_fact_financial_statements"
)

SELECT
    *
FROM kpi_sources;