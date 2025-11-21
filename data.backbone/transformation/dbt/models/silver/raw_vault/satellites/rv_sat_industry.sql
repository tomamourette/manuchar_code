WITH industry AS (
    SELECT
        mds.bkey_industry_source,
        mds.industry_name,
        mds.industry_group,
        mds.valid_from,
        mds.valid_to,
        mds.is_current
    FROM {{ ref('industry_mds') }} mds
    UNION ALL
    SELECT
        mona.bkey_industry_source,
        REPLACE(REPLACE(mona.industry_name, '<messages><message lcid="2057">', ''), '</message></messages>', '') AS industry_name,
        CAST(mona.industry_group AS VARCHAR) AS industry_group,
        mona.valid_from,
        mona.valid_to,
        mona.is_current
    FROM {{ ref('industry_mona') }} mona
)

SELECT
    *
FROM industry