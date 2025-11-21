-- ===============================
-- STEP 1: Extracting Historical Data (SCD2)
-- Generating valid_from and valid_to using modifieddate
-- ===============================

WITH dynamics_uom_history AS (
	-- Entity details over time (SCD2)
	SELECT 		
		uom.symbol + '_DYNAMICS' AS bkey_unit_of_measure_source,	
		uom.symbol AS bkey_unit_of_measure,
		'DYNAMICS' AS bkey_source,
		uomdesc.description,	
		iif(uom.symbol = 'L', 1000, iif(uom.symbol in ('ADMT','DMT'), 1, NULL)) AS conversiontometricton,
		CAST(uom.modifieddatetime AS DATETIME2(6)) AS valid_from,
        LEAD(CAST(uom.modifieddatetime AS DATETIME2(6))) OVER (PARTITION BY uom.symbol ORDER BY CAST(uom.modifieddatetime AS DATETIME2(6))) AS valid_to
  	FROM dbb_warehouse.ods.sv_dynamics_unitofmeasure uom		
	LEFT JOIN dbb_warehouse.ods.sv_dynamics_unitofmeasuretranslation uomdesc		
	 	ON uom.recid = uomdesc.recid
),

-- ===============================
-- STEP 2: Generate Time Ranges for SCD2
-- Consolidating timestamps across history sources to create a unified timeline
-- ===============================

timeranges AS (
    SELECT
        bkey_unit_of_measure_source,
        bkey_unit_of_measure,
        bkey_source,
        CAST(valid_from AS DATETIME2(6)) AS valid_from,
        CAST(COALESCE(LEAD(valid_from) OVER (PARTITION BY bkey_unit_of_measure ORDER BY valid_from),'2999-12-31 23:59:59.999999') AS DATETIME2(6)) AS valid_to
    FROM (
        SELECT bkey_unit_of_measure_source, bkey_unit_of_measure, bkey_source, valid_from, valid_to FROM dynamics_uom_history
    ) AS time_events
)

-- ===============================
-- STEP 3: Extracting Current Data (SCD1)
-- Only Latest Record per Entity is Kept
-- ===============================

-- ===============================
-- STEP 4: Combine Everything into a Full Entity Timeline
-- - SCD2 (history tables) are joined on ID + valid time range.
-- - SCD1 (current tables) are joined on ID only.
-- ===============================

SELECT 
    tr.bkey_unit_of_measure_source,
    tr.bkey_unit_of_measure,
    tr.bkey_source,

    -- From Main Entity History Table (Time-Dependent Attributes)
    e1.description AS unit_of_measure_name,
    e1.description AS unit_of_measure_description,
    e1.conversiontometricton AS unit_of_measure_conversion_to_mt,

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

LEFT JOIN dynamics_uom_history e1 
ON e1.bkey_unit_of_measure_source = tr.bkey_unit_of_measure_source
AND e1.valid_from <= tr.valid_from 
AND COALESCE(e1.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from

-- ===============================
-- JOIN SCD1 (Current) TABLE ON ID ONLY (1-to-1 Relationship)
-- Since these values do not change over time, we only keep the latest version.
-- ===============================