WITH source_currency AS (
    SELECT
        hub.bkey_currency,
        hub.bkey_source,
        sat.currency_name,
        sat.valid_from,
        sat.valid_to
    FROM {{ ref('rv_hub_currency')}} hub
    LEFT JOIN {{ ref('rv_sat_currency')}} sat ON hub.bkey_currency_source = sat.bkey_currency_source
    WHERE is_current = 1 -- add only the latest version
),

-- ===============================
-- STEP 2: Generating Non-overlapping 
-- Time Ranges for Each bkey_currency
-- ===============================

time_ranges AS (
    SELECT
        bkey_currency,
        CAST(time_event AS DATETIME2(6)) AS valid_from,
        CAST(COALESCE(LEAD(time_event) OVER (PARTITION BY bkey_currency ORDER BY time_event), '2999-12-31 23:59:59.999999') AS DATETIME2(6)) AS valid_to
    FROM (
        SELECT bkey_currency, valid_from AS time_event FROM source_currency
        UNION
        SELECT bkey_currency, valid_to AS time_event FROM source_currency
    ) AS time_events
    WHERE time_event <> '2999-12-31 23:59:59.999999'
)

-- ===============================
-- STEP 3: Combine Everything into a Timeline
-- Take One Leading Source for Each Attribute
-- ===============================

SELECT
    tr.bkey_currency,
    COALESCE(mona.currency_name, mds.currency_name) AS currency_name,
    tr.valid_from,
    tr.valid_to,
    CASE
        WHEN tr.valid_to = CAST('2999-12-31 23:59:59.999999' AS DATETIME2(6))
            THEN 1
        ELSE 0
    END AS is_current
FROM time_ranges tr

LEFT JOIN source_currency mona
ON mona.bkey_currency = tr.bkey_currency 
AND mona.valid_from <= tr.valid_from 
AND COALESCE(mona.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from
AND mona.bkey_source = 'MONA' -- add only the source specific bkey's

LEFT JOIN source_currency mds
ON mds.bkey_currency = tr.bkey_currency 
AND mds.valid_from <= tr.valid_from 
AND COALESCE(mds.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from
AND mds.bkey_source = 'MDS' -- add only the source specific bkey's