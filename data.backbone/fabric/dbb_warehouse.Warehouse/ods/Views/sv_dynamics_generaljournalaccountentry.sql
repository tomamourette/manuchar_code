-- Auto Generated (Do not modify) 40D5BF895FE8606D5842D436CA691A273120F212DC612FADFBD62624C41F303D
create view "ods"."sv_dynamics_generaljournalaccountentry" as WITH source_dynamics_generaljournalaccountentry AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Dynamics__dbo_generaljournalaccountentry"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_generaljournalaccountentry
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;