{{ config(
    tags=['Group-FinancialStatements', 'Fact', 'Row Level Security']
) }}

-- RLS Logic For Fabric Data Products
WITH parsed_groups AS (
    SELECT
        g.group_id,
        g.group_name,
        g.environment,
        g.fabric_rls AS rls_category,
        g.group_role AS rls_role,
        g.company_code, 
        g.industry_code
        
    FROM {{ ref('security_group_oil_genericdata') }} g
    WHERE group_name LIKE '%FAB-DP-RLS%'
),

-- log invalid groups
invalid_groups AS (
    SELECT *
    FROM parsed_groups
    WHERE environment IS NULL
),

members_with_groups AS (
    SELECT
        -- User info
        u.user_principal_name,
        
        -- Group info
        pg.group_id,
        pg.environment,
        pg.rls_category,
        pg.rls_role,
        pg.company_code,
        pg.industry_code

    FROM {{ ref('security_user_oil_genericdata') }} u
    INNER JOIN parsed_groups pg
        ON u.user_group_id = pg.group_id
),

-- Company list by environment
company_list AS (
    SELECT DISTINCT company_code, environment
    FROM parsed_groups
    WHERE rls_category = 'Mcompany'
),

-- 1) Mindustry: access to all companies in same environment
mindustry_rls AS (
    -- Global row (company = NULL, industry set)
    SELECT DISTINCT
        u.user_principal_name,
        u.group_id,
        u.environment,
        NULL AS company_code,
        u.industry_code

    FROM members_with_groups u
    WHERE u.rls_category = 'Mindustry'

    UNION ALL

    -- Expanded rows for each company in same environment (industry cleared)
    SELECT DISTINCT
        u.user_principal_name,
        u.group_id,
        u.environment,
        u.company_code,
        NULL AS industry_code
        
    FROM members_with_groups u
    CROSS JOIN company_list c
    WHERE u.rls_category = 'Mindustry'
      AND u.environment = c.environment
),

-- 2) Mgroup: access to all 'Regionmanager'companies in same environment
mgroup_rls AS (
    SELECT DISTINCT
        u.user_principal_name,
        u.group_id,
        u.environment,
        g.company_code,
        NULL AS industry_code

    FROM members_with_groups u
    JOIN parsed_groups g
        ON g.rls_category = 'Mcompany'
       AND g.rls_role = 'RegionManager'
       AND g.environment = u.environment
    WHERE u.rls_category = 'Mgroup'
),

-- 3) Mcompany: keep as-is
mcompany_rls AS (
    SELECT DISTINCT
        u.user_principal_name,
        u.group_id,
        u.environment,
        u.company_code,
        NULL AS industry_code

    FROM members_with_groups u
    WHERE u.rls_category = 'Mcompany'
)

-- FINAL: precedence (Mindustry > Mgroup > Mcompany)
SELECT DISTINCT *
FROM (
    SELECT * FROM mindustry_rls
	UNION
	SELECT * FROM mgroup_rls
	WHERE user_principal_name NOT IN (SELECT user_principal_name FROM mindustry_rls)
	UNION
	SELECT * FROM mcompany_rls
	WHERE user_principal_name NOT IN (SELECT user_principal_name FROM mindustry_rls)
) AS rls