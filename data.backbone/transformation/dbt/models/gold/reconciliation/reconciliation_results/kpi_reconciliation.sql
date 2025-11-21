WITH kpi_sources AS (
    SELECT
        bkey_date,
	    bkey_affiliate,
	    amount,
	    source_name,
	    kpi_name
    FROM {{ ref('quality_equity_mona_onprem')}}
    UNION ALL
    SELECT
        bkey_date,
	    bkey_affiliate,
	    amount,
	    source_name,
	    kpi_name
    FROM {{ ref('quality_equity_mona_oil')}}
    UNION ALL
    SELECT
        bkey_date,
        bkey_affiliate,
        amount,
        source_name,
        kpi_name
    FROM {{ ref('quality_equity_fact_financial_statements')}}
)

SELECT
    *
FROM kpi_sources