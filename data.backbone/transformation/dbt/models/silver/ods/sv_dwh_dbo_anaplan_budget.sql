WITH source_dbo_anaplan_budget AS (
    SELECT *, 
           ROW_NUMBER() OVER (
               PARTITION BY [Period], [Plan], [Version], CompanyCode, MonthCode, 
                            FK_Product, FK_Customer, DestinationCountryCode 
               ORDER BY ingestion_timestamp DESC
           ) AS rn
    FROM {{ source('dwh', 'dbo_Anaplan_Budget') }}
),

deduplicated AS (
    SELECT *
    FROM source_dbo_anaplan_budget
    WHERE rn = 1
)

SELECT *
FROM deduplicated;
