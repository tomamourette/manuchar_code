-- Auto Generated (Do not modify) 52DD45D8B570873C6B9CD57C0678E1823501FEEBF7ECE0AD4912521804FE9008
create view "ods"."sv_boomi_anaplan_budget" as WITH source_anaplan_budget AS (
    SELECT *, 
           ROW_NUMBER() OVER (
               PARTITION BY Period, [Plan], Version, CompanyCode, MonthCode, 
                            FK_Product, FK_Customer, DestinationCountryCode 
               ORDER BY InsertedDate DESC
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