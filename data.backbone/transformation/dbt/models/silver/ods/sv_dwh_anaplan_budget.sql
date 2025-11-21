WITH source_anaplan_budget AS (
    SELECT *, 
           ROW_NUMBER() OVER (
               PARTITION BY [Period], [Plan], [Version], CompanyCode, MonthCode, 
                            FK_Product, FK_Customer, DestinationCountryCode, SalesAmountGroupCurrency 
               ORDER BY ingestion_timestamp DESC
           ) AS rn
    FROM {{ source('dwh', 'Anaplan_Budget') }}
),

deduplicated AS (
    SELECT *
    FROM source_anaplan_budget
    WHERE rn = 1
)

SELECT *
FROM deduplicated;
