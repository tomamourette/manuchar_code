SELECT 
	*
FROM {{ source('mona', 'quality_equity_mona_onprem') }}