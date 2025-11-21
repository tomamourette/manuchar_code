WITH source_anaplan_forecast AS (
    SELECT *, 
           ROW_NUMBER() OVER (
               PARTITION BY Period, [Plan], Version, CompanyCode, MonthCode, 
                            FK_Product, FK_Customer, DestinationCountryCode 
               ORDER BY ingestion_timestamp DESC
           ) AS rn
    FROM {{ source('dwh', 'Anaplan_Forecast') }}
),

deduplicated AS (
    SELECT *
    FROM source_anaplan_forecast
    WHERE rn = 1
)

SELECT *
FROM deduplicated;
