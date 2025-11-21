WITH security_user AS (
    SELECT
        -- User info
        m.userPrincipalName AS user_principal_name,
        m.displayName AS user_display_name,
        m.jobTitle AS user_job_title,
        m.officeLocation AS user_office_location,
        m.companyName AS user_company_name,
        m.groupID AS user_group_id

    FROM {{ ref('sv_oil_genericdata_ms_entra_group_members') }} m
)

SELECT
    *
FROM security_user