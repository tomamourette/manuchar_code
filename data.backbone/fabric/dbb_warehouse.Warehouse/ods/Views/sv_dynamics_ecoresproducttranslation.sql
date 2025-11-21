-- Auto Generated (Do not modify) BF5F7354B81075268C17EA32DE1DB4933A4D61857A52323842A5B22A439A37B0
create view "ods"."sv_dynamics_ecoresproducttranslation" as WITH source_dynamics_ecoresproducttranslation AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Dynamics__dbo_ecoresproducttranslation"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_ecoresproducttranslation
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;