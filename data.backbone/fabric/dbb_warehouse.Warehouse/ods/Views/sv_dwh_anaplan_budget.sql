-- Auto Generated (Do not modify) 956B2837BD56AEED976525FF4980C54EE3CC449FD9B50854932C9E709166FD86
create view "ods"."sv_dwh_anaplan_budget" as WITH source_anaplan_budget AS (
    SELECT *, 
           ROW_NUMBER() OVER (
               PARTITION BY [Period], [Plan], [Version], CompanyCode, MonthCode, 
                            FK_Product, FK_Customer, DestinationCountryCode, SalesAmountGroupCurrency 
               ORDER BY ingestion_timestamp DESC
           ) AS rn
    FROM "dbb_lakehouse"."dbo"."DWH__ds_Anaplan_Budget"
),

deduplicated AS (
    SELECT *
    FROM source_anaplan_budget
    WHERE rn = 1
)

SELECT *
FROM deduplicated;;