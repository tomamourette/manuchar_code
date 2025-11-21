WITH currency AS (
    SELECT
        mds.bkey_currency_source,
        mds.currency_name,
        mds.valid_from,
        mds.valid_to,
        mds.is_current
    FROM {{ ref('currency_mds') }} mds
    UNION ALL
    SELECT
        mona.bkey_currency_source,
        REPLACE(REPLACE(mona.currency_name, '<messages><message lcid="2057">', ''), '</message></messages>', '') AS currency_name,
        mona.valid_from,
        mona.valid_to,
        mona.is_current
    FROM {{ ref('currency_mona') }} mona
)

SELECT
    *
FROM currency