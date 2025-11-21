-- ===============================
-- STEP 1: Extracting Historical Data (SCD2)
-- Generating valid_from and valid_to using ODSIngestionDate
-- ===============================

WITH mona_currency_rates_history AS (
	-- Entity details over time (SCD2)
    SELECT
        CONCAT(ts017.CurrCode, '_', LEFT(smvcc.ConsoCode, 6)) + '_MONA' AS bkey_currency_rate_source,
        CONCAT(ts017.CurrCode, '_', LEFT(smvcc.ConsoCode, 6)) AS bkey_currency_rate,
        'MONA' AS bkey_source,
        CAST(ts017.ODSIngestionDate AS DATETIME2(6)) AS valid_from,  -- Ensure precision
        CAST(LEAD(ts017.ODSIngestionDate) OVER (PARTITION BY CONCAT(ts017.CurrCode, '_', LEFT(smvcc.ConsoCode, 6)) ORDER BY ts017.ODSIngestionDate) AS DATETIME2(6)) AS valid_to
    FROM {{ ref("sv_mona_ts017r0") }} ts017
    LEFT JOIN {{ ref("sv_mona_v_conso_code") }} smvcc ON smvcc.ConsoID = ts017.ConsoID
    INNER JOIN {{ ref("sv_mona_ts096s0") }} ts96
    ON ts017.ConsoID = ts96.ConsoID
    AND (
        (ts96.ConsoYear < 2025 AND ts96.ConsoCategoryID = 1554 AND ts96.ConsoSequence = 0)
        OR (ts96.ConsoYear >= 2025 AND ts96.ConsoCategoryID = 1752 AND ts96.ConsoSequence = 100) -- from 2025 IFR100 conso period is leading
    )
    AND ts96.ConsoYear >= 2020
),

-- ===============================
-- STEP 2: Generate Time Ranges for SCD2
-- Consolidating timestamps across history sources to create a unified timeline
-- ===============================

timeranges AS (
    SELECT 
        bkey_currency_rate_source, 
        bkey_currency_rate,
        bkey_source,
        CAST(valid_from AS DATETIME2(6)) AS valid_from,
        CAST(COALESCE(LEAD(valid_from) OVER (PARTITION BY bkey_currency_rate ORDER BY valid_from), '2999-12-31 23:59:59.999999') AS DATETIME2(6)) AS valid_to
    FROM (
        SELECT bkey_currency_rate_source, bkey_currency_rate, bkey_source, valid_from, valid_to FROM mona_currency_rates_history
    ) AS time_events
),

-- ===============================
-- STEP 3: Extracting Current Data (SCD1)
-- Only Latest Record per Entity is Kept
-- ===============================

mona_currency_rates_current AS (
    -- Entity attributes where only the latest version is relevant (SCD1)
    SELECT 
        *
    FROM (
        SELECT 
            CONCAT(ts017.CurrCode, '_', LEFT(smvcc.ConsoCode, 6)) + '_MONA' AS bkey_currency_rate_source,
            CONCAT(ts017.CurrCode, '_', LEFT(smvcc.ConsoCode, 6)) AS bkey_currency_rate,
            'MONA' AS bkey_source,
            ts017.ConsoID,
            smvcc.ConsoCode,
            ts017.CurrCode,
            ts017.ReferenceCurrCode,
            1.0 / NULLIF(ts017.ClosingRate, 0) AS ClosingRate,
            1.0 / NULLIF(ts017.AverageRate, 0) AS AverageRate,
            1.0 / NULLIF(ts017.AverageMonth, 0) AS AverageMonth,
            1.0 / NULLIF(budget.budget_closing_rate, 0) AS budget_closing_rate,
            1.0 / NULLIF(budget.budget_average_rate, 0) AS budget_average_rate,
            1.0 / NULLIF(budget.budget_average_month, 0) AS budget_average_month,
            ts96.ConsoYear,
            ts96.ConsoMonth,
            EOMONTH(DATEFROMPARTS(ts96.ConsoYear, ts96.ConsoMonth, 1)) AS closing_date,
            ROW_NUMBER() OVER (PARTITION BY CONCAT(CurrencyRateID, '_', ts017.ConsoID) ORDER BY ts017.ODSIngestionDate DESC) AS rn
        FROM {{ ref("sv_mona_ts017r0") }} ts017
        LEFT JOIN {{ ref("sv_mona_v_conso_code") }} smvcc ON smvcc.ConsoID = ts017.ConsoID
        INNER JOIN {{ ref("sv_mona_ts096s0") }} ts96
        ON ts017.ConsoID = ts96.ConsoID
        AND (
            (ts96.ConsoYear < 2025 AND ts96.ConsoCategoryID = 1554 AND ts96.ConsoSequence = 0)
            OR (ts96.ConsoYear >= 2025 AND ts96.ConsoCategoryID = 1752 AND ts96.ConsoSequence = 100) -- from 2025 IFR100 conso period is leading
        )
        LEFT OUTER JOIN
		(
			SELECT
				ts017.CurrCode,
				ts96.ConsoYear,
			    ts96.ConsoMonth,
				ts017.AverageRate AS budget_closing_rate,
				ts017.AverageMonth AS budget_average_month,
				ts017.ClosingRate AS budget_average_rate
			FROM {{ ref("sv_mona_ts017r0") }} ts017
            LEFT JOIN {{ ref("sv_mona_v_conso_code") }} smvcc ON smvcc.ConsoID = ts017.ConsoID
			INNER JOIN {{ ref("sv_mona_ts096s0") }} ts96
				ON ts017.ConsoID = ts96.ConsoID
				AND ts96.ConsoMonth = 12
				AND ts96.ConsoCategoryID = 1555
				AND ts96.ConsoSequence = 0
		) budget
            ON ts017.CurrCode = budget.CurrCode
            AND ts96.ConsoYear = budget.ConsoYear
    ) AS latest_values
    WHERE rn = 1
)

-- ===============================
-- STEP 4: Combine Everything into a Full Entity Timeline
-- - SCD2 (history tables) are joined on ID + valid time range.
-- - SCD1 (current tables) are joined on ID only.
-- ===============================

SELECT 
    tr.bkey_currency_rate_source,
    tr.bkey_currency_rate,
    tr.bkey_source,

    -- From Entity Current Table (Static Attributes)
    ec.ConsoID AS currency_rate_consolidation_id,
    ec.ConsoCode AS currency_rate_consolidation_code,
    ec.CurrCode AS currency_rate_currency_code,
    ec.ReferenceCurrCode AS currency_rate_reference_currency_code,
    ec.ClosingRate AS currency_rate_closing_rate,
    ec.AverageRate AS currency_rate_average_rate,
    ec.AverageMonth AS currency_rate_average_month,
    ec.budget_closing_rate AS currency_rate_budget_closing_rate,
    ec.budget_average_rate AS currency_rate_budget_average_rate,
    ec.budget_average_month AS currency_rate_budget_average_month,
    ec.ConsoMonth AS currency_rate_month,
    ec.ConsoYear AS currency_rate_year,
    ec.closing_date AS currency_rate_closing_date,
  
    -- Metadata for time tracking
    tr.valid_from,
    tr.valid_to,
    CASE 
        WHEN tr.valid_to = '2999-12-31 23:59:59.999999' THEN 1 
        ELSE 0
    END AS is_current

FROM timeranges tr

-- ===============================
-- JOIN SCD2 (History) TABLES ON ID + TIME RANGE
-- Ensures correct historical version is retrieved based on the event timestamp.
-- ===============================

LEFT JOIN mona_currency_rates_history e
ON e.bkey_currency_rate_source = tr.bkey_currency_rate_source
AND e.valid_from <= tr.valid_from 
AND COALESCE(e.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from

-- ===============================
-- JOIN SCD1 (Current) TABLE ON ID ONLY (1-to-1 Relationship)
-- Since these values do not change over time, we only keep the latest version.
-- ===============================

LEFT JOIN mona_currency_rates_current ec
ON ec.bkey_currency_rate_source = tr.bkey_currency_rate_source