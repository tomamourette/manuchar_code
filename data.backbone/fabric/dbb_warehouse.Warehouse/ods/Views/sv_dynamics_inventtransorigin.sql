-- Auto Generated (Do not modify) 217CD2C04DC0FFAF67C6DDA0376BBED180946C72D4D64B992E5E2BE8F9AAA732
create view "ods"."sv_dynamics_inventtransorigin" as WITH source_dynamics_inventtransorigin AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Dynamics__dbo_inventtransorigin"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_inventtransorigin
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;