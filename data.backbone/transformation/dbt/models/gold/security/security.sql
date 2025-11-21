WITH [security] AS (
    SELECT 
        
        -- group info
        g.group_id,
        g.group_name,
        g.environment,
        g.fabric_workspace,
        g.fabric_database,
        g.fabric_data_product,
        g.fabric_rls,
        g.group_role,
        g.company_code AS global_affiliate_code,

        -- user info
        u.user_principal_name,
        u.user_display_name,
        u.user_job_title,
        u.user_office_location,
        u.user_company_name,
        
        -- rls info
        rls.company_code,
        rls.industry_code

    FROM {{ ref('security_group_oil_genericdata') }} g
    LEFT JOIN {{ ref('security_user_oil_genericdata') }} u
        ON g.group_id = u.user_group_id
    LEFT JOIN {{ ref('security_rls') }} rls
        ON rls.group_id = g.group_id
        AND rls.user_principal_name = u.user_principal_name
)

SELECT *
FROM [security]