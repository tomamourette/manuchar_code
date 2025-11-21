-- ===============================
-- Extracting Current Data (SCD1)
-- Only Latest Record per Entity is Kept
-- This is already covered in the source view of the transactional tables
-- ===============================

-- Define the consolidated amounts (Grain-defining CTE)
WITH source_mona_consolidated_amount AS (
    SELECT 
        smvdc.ConsolidatedAmountID,
        smvdc.Account,
        smvdc.ConsoCode,
        smvdc.CompanyCode,
        smvdc.CurrCode,
        smvdc.PartnerCompanyCode,
        smvdc.JournalType,
        smvdc.JournalCategory,
        smvdc.Amount
    FROM {{ ref('sv_mona_v_data_conso') }} smvdc
),

-- Define the consolidated amounts on an industry level
source_mona_consolidated_industry_amount AS (
    SELECT 
        td055.ConsolidatedAmountID,
		smvcc.ConsoCode,
        smvd.DimensionDetailCode,
		smvd.DimensionDetailDescription,
		ROUND(td055.Amount, 2) AS Amount,
        -- Sum all industry amounts for a given consolidatedAmountID, as they must match the amount in v_data_conso.
        SUM(ROUND(td055.Amount, 2)) OVER (PARTITION BY td055.ConsolidatedAmountID, smvcc.ConsoCode) AS total_industry_amount
    FROM {{ ref('sv_mona_td055c2') }} td055
	LEFT JOIN {{ ref('sv_mona_v_conso_code') }} smvcc 
    ON smvcc.ConsoID = td055.ConsoID
    LEFT JOIN {{ ref('sv_mona_v_dimensiondetail') }} smvd 
    ON td055.Dim1DetailID = smvd.DimensionDetailID 
    AND td055.ConsoID = smvd.ConsoID
    WHERE smvd.DimensionCode = 'Industry'
),

-- Calculate bundle local adjustments
bundle_local_adjustment AS (
    SELECT 
        smvcc.ConsoCode,
        ts014.CompanyCode,
        ts010.Account,
        ts014.CurrCode,
        '3PAR' AS PartnerCompanyCode,
        'UNEXP' AS DimensionDetailCode,
        SUM(td030e2.Amount) AS bundle_local_adjustment_amount
    FROM {{ ref('sv_mona_ts014c0') }} ts014 
    INNER JOIN {{ ref('sv_mona_td030e0') }} td030eO
    ON ts014.ConsoID = td030eO.ConsoID
    AND ts014.CompanyID = td030eO.CompanyID
    AND ts014.CurrCode = td030eO.CurrCode
    INNER JOIN {{ ref('sv_mona_td030e2') }} td030e2
    ON ts014.ConsoID = td030e2.ConsoID
    AND td030eO.LocalAdjustmentsHeaderID = td030e2.LocalAdjustmentsHeaderID
    INNER JOIN {{ ref('sv_mona_ts010s0') }} ts010
    ON td030eO.ConsoID = ts010.ConsoID
    AND td030e2.AccountID = ts010.AccountID
    LEFT JOIN {{ ref('sv_mona_v_conso_code') }} smvcc
    ON ts014.ConsoID = smvcc.ConsoID
    GROUP BY 
        smvcc.ConsoCode,
        ts014.CompanyCode,
        ts010.Account,
        ts014.CurrCode
),

-- Calculate bundle local amounts
bundle_local AS (
    SELECT 
        smvcc.ConsoCode,
        ts014.CompanyCode,
        ts010.Account,
        ts014.CurrCode,
        '3PAR' AS PartnerCompanyCode,
        'UNEXP' AS DimensionDetailCode,
        SUM(td030b1.Amount) AS bundle_local_amount
    FROM {{ ref('sv_mona_ts014c0') }} ts014
    INNER JOIN {{ ref('sv_mona_td030b1') }} td030b1
    ON ts014.ConsoID = td030b1.ConsoID
    AND ts014.CompanyID = td030b1.CompanyID
    AND ts014.CurrCode = td030b1.CurrCode
    INNER JOIN {{ ref('sv_mona_ts010s0') }} ts010
    ON td030b1.ConsoID = ts010.ConsoID
    AND td030b1.AccountID = ts010.AccountID
    INNER JOIN {{ ref('sv_mona_v_conso_code') }} smvcc
    ON ts014.ConsoID = smvcc.ConsoID
    GROUP BY
        smvcc.ConsoCode,
        ts014.CompanyCode,
        ts010.Account,
        ts014.CurrCode
), 

consolidated_amount_combined AS (
    -- Combine all the consolidated amounts on industry level and calculate bundle local adjustments and amounts
    SELECT
        smca.Account,
        smca.ConsoCode,
        smca.CompanyCode,
        smca.CurrCode,
        COALESCE(NULLIF(smca.PartnerCompanyCode, 'N/A'), '3PAR') AS PartnerCompanyCode,
        COALESCE(smcia.DimensionDetailCode, 'UNEXP') AS DimensionDetailCode,
        smca.JournalType,
        smca.JournalCategory,
        -- Check if the amount in the consolidated amount table matches the total industry amount
        -- If it does, use the amount from the consolidated industry amount table
        -- If it doesn't, assign the consolidated amount to either 'UNEXP' or 'TECHNICAL' or NULL (when there is no industry mapping linked)
        CASE
            WHEN (ROUND(smca.Amount, 2) - smcia.total_industry_amount) BETWEEN -1 AND 1 THEN smcia.Amount
            WHEN smcia.DimensionDetailCode IS NULL OR smcia.DimensionDetailCode IN ('UNEXP', 'TECHNICAL') THEN ROUND(smca.Amount, 2)
            ELSE 0
        END AS Amount,
        NULL AS bundle_local_adjustment_amount,
        NULL AS bundle_local_amount
    FROM source_mona_consolidated_amount smca
    LEFT JOIN source_mona_consolidated_industry_amount smcia
    ON smcia.ConsolidatedAmountID = smca.ConsolidatedAmountID
    AND smcia.ConsoCode = smca.ConsoCode

    UNION ALL

    SELECT
        blad.Account,
        blad.ConsoCode,
        blad.CompanyCode,
        blad.CurrCode,
        blad.PartnerCompanyCode,
        blad.DimensionDetailCode,
        NULL AS JournalType,
        NULL AS JournalCategory,
        NULL AS Amount,
        blad.bundle_local_adjustment_amount,
        NULL AS bundle_local_amount
    FROM bundle_local_adjustment blad 

    UNION ALL

    SELECT
        bl.Account,
        bl.ConsoCode,
        bl.CompanyCode,
        bl.CurrCode,
        bl.PartnerCompanyCode,
        bl.DimensionDetailCode,
        NULL AS JournalType,
        NULL AS JournalCategory,
        NULL AS Amount,
        NULL AS bundle_local_adjustment_amount,
        bl.bundle_local_amount
    FROM bundle_local bl
)

SELECT 
    CONCAT(Account, '_', ConsoCode, '_', CompanyCode, '_', CurrCode, '_', PartnerCompanyCode, '_', DimensionDetailCode, '_', JournalType, '_', JournalCategory) AS bkey_consolidated_amount,
    CONCAT(Account, '_', ConsoCode, '_', CompanyCode, '_', CurrCode, '_', PartnerCompanyCode, '_', DimensionDetailCode, '_', JournalType, '_', JournalCategory) + '_MONA' AS bkey_consolidated_amount_source,
    'MONA' AS bkey_source,
    Account AS consolidated_account,
    ConsoCode AS consolidated_consolidation_period,
    CompanyCode AS consolidated_company,
    CurrCode AS consolidated_currency,
    PartnerCompanyCode AS consolidated_partner_company,
    DimensionDetailCode AS consolidated_industry,
    JournalType AS consolidated_journal_type,
    JournalCategory AS consolidated_journal_category,
    SUM(Amount) AS consolidated_amount,
    MAX(bundle_local_adjustment_amount) AS consolidated_bundle_local_adjustment_amount,
    MAX(bundle_local_amount) AS consolidated_bundle_local_amount,
    '1900-01-01 00:00:00.000000' AS valid_from,
    '2999-12-31 23:59:59.999999' AS valid_to,
    CASE 
        WHEN '2999-12-31 23:59:59.999999' = '2999-12-31 23:59:59.999999' THEN 1 
        ELSE 0 
    END AS is_current
FROM consolidated_amount_combined
GROUP BY
    Account,
    ConsoCode,
    CompanyCode,
    CurrCode,
    PartnerCompanyCode,
    DimensionDetailCode,
    JournalType,
    JournalCategory
