-- Auto Generated (Do not modify) 7F7EFBED709D5842407B332EA0B557012085B5CD7C580880144237AD0403737A
create view "security"."rls" as -- RLS Logic for Security Model
WITH parsed_groups AS (
    SELECT
        g.Group_Id AS group_id,
        g.Group_Name AS group_name,
        -- company
        LEFT(g.Group_Name, CHARINDEX('_', g.Group_Name) - 1) AS company_code,
        -- environment
        CASE WHEN SUBSTRING(
            g.Group_Name,
            CHARINDEX('_', g.Group_Name) + 1,
            CHARINDEX('_', g.Group_Name, CHARINDEX('_', g.Group_Name) + 1) 
                - CHARINDEX('_', g.Group_Name) - 1
        ) IN ('P','Q') THEN SUBSTRING(
            g.Group_Name,
            CHARINDEX('_', g.Group_Name) + 1,
            CHARINDEX('_', g.Group_Name, CHARINDEX('_', g.Group_Name) + 1) 
                - CHARINDEX('_', g.Group_Name) - 1
        )
        ELSE NULL END AS environment,
        -- group type
        CASE 
            WHEN CHARINDEX('Mgroup-', g.Group_Name) > 0 THEN 'Mgroup'
            WHEN CHARINDEX('Mindustry-', g.Group_Name) > 0 THEN 'Mindustry'
            ELSE 'Mcompany'
        END AS group_category,
        -- role for Mgroup & Company
        CASE 
            WHEN CHARINDEX('Mgroup-', g.Group_Name) > 0 THEN 
                RIGHT(g.Group_Name, LEN(g.Group_Name) - CHARINDEX('Mgroup-', g.Group_Name) - LEN('Mgroup-') + 1)
            WHEN CHARINDEX('FAB-DP-RLS_', g.Group_Name) > 0 AND LEFT(g.Group_Name,4) <> 'GLO_' THEN
                RIGHT(g.Group_Name, LEN(g.Group_Name) - CHARINDEX('FAB-DP-RLS_', g.Group_Name) - LEN('FAB-DP-RLS_') + 1)
            ELSE NULL
        END AS group_role,
        -- industry for Mindustry
        CASE WHEN CHARINDEX('Mindustry-', g.Group_Name) > 0 THEN 
		    UPPER(RIGHT(g.Group_Name, LEN(g.Group_Name) - CHARINDEX('Mindustry-', g.Group_Name) - LEN('Mindustry-') + 1))
		    ELSE NULL
		END AS industry_code
    FROM "dbb_warehouse"."ods"."sv_oil_genericdata_ms_entra_groups" g
    WHERE g.Group_Name LIKE '%FAB-DP-RLS%'
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
        m.userPrincipalName AS user_principal_name,
        m.displayName AS user_display_name,
        m.jobTitle AS user_job_title,
        m.officeLocation AS user_office_location,
        m.companyName AS user_company_name,
        
        -- Group info
        m.groupID AS group_id,
        pg.group_name,
        pg.group_category,
        pg.group_role,
        pg.environment,
        pg.company_code,
        pg.industry_code

    FROM "dbb_warehouse"."ods"."sv_oil_genericdata_ms_entra_group_members" m
    INNER JOIN parsed_groups pg
        ON m.groupID = pg.group_id
),

-- Company list by environment
company_list AS (
    SELECT DISTINCT company_code, environment
    FROM parsed_groups
    WHERE group_category = 'Mcompany'
),

-- 1) Mindustry: access to all companies in same environment
mindustry_rls AS (
    -- Global row (company = NULL, industry set)
    SELECT DISTINCT
        u.user_principal_name,
        u.user_display_name,
        u.user_job_title,
        u.user_office_location,
        u.user_company_name,
        u.group_id,
        u.group_name,
        u.group_category,
        u.group_role,
        u.environment,
        NULL AS company_code,
        u.industry_code

    FROM members_with_groups u
    WHERE u.group_category = 'Mindustry'

    UNION ALL

    -- Expanded rows for each company in same environment (industry cleared)
    SELECT DISTINCT
        u.user_principal_name,
        u.user_display_name,
        u.user_job_title,
        u.user_office_location,
        u.user_company_name,
        u.group_id,
        u.group_name,
        u.group_category,
        u.group_role,
        u.environment,
        u.company_code,
        NULL AS industry_code
        
    FROM members_with_groups u
    CROSS JOIN company_list c
    WHERE u.group_category = 'Mindustry'
      AND u.environment = c.environment
),

-- 2) Mgroup: access to all 'Regionmanager'companies in same environment
mgroup_rls AS (
    SELECT DISTINCT
        u.user_principal_name,
        u.user_display_name,
        u.user_job_title,
        u.user_office_location,
        u.user_company_name,
        u.group_id,
        u.group_name,
        u.group_category,
        u.group_role,
        u.environment,
        g.company_code,
        NULL AS industry_code

    FROM members_with_groups u
    JOIN parsed_groups g
        ON g.group_category = 'Mcompany'
       AND g.group_role = 'RegionManager'
       AND g.environment = u.environment
    WHERE u.group_category = 'Mgroup'
),

-- 3) Mcompany: keep as-is
mcompany_rls AS (
    SELECT DISTINCT
        u.user_principal_name,
        u.user_display_name,
        u.user_job_title,
        u.user_office_location,
        u.user_company_name,
        u.group_id,
        u.group_name,
        u.group_category,
        u.group_role,
        u.environment,
        u.company_code,
        NULL AS industry_code

    FROM members_with_groups u
    WHERE u.group_category = 'Mcompany'
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
) AS rls;