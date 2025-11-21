
WITH parsed_groups AS (
    SELECT
        g.Group_Id AS group_id,
        g.Group_Name AS group_name,
        
		-- COMPANY
	    LEFT(g.Group_Name, CHARINDEX('_', g.Group_Name) - 1) AS company_code,
        	
	    -- ENVIRONMENT
		CASE WHEN SUBSTRING(
        	g.Group_Name,
            CHARINDEX('_', g.Group_Name) + 1,
            CHARINDEX('_', g.Group_Name, CHARINDEX('_', g.Group_Name) + 1) 
                - CHARINDEX('_', g.Group_Name) - 1
         ) IN ('T', 'A', 'Q', 'P') THEN SUBSTRING(
            g.Group_Name,
            CHARINDEX('_', g.Group_Name) + 1,
            CHARINDEX('_', g.Group_Name, CHARINDEX('_', g.Group_Name) + 1) 
                - CHARINDEX('_', g.Group_Name) - 1
    	 )
         ELSE NULL END AS environment,
        
        -- FABRIC WORKSPACE
		CASE 
		    WHEN g.Group_Name LIKE '%FAB-wrksp_%' THEN
		        SUBSTRING(
		            g.Group_Name,
		            CHARINDEX('FAB-wrksp_', g.Group_Name) + LEN('FAB-wrksp_'),
		            CASE 
		                WHEN CHARINDEX('_', g.Group_Name, CHARINDEX('FAB-wrksp_', g.Group_Name) + LEN('FAB-wrksp_')) > 0
		                THEN CHARINDEX('_', g.Group_Name, CHARINDEX('FAB-wrksp_', g.Group_Name) + LEN('FAB-wrksp_'))
		                     - (CHARINDEX('FAB-wrksp_', g.Group_Name) + LEN('FAB-wrksp_'))
		                ELSE LEN(g.Group_Name) - (CHARINDEX('FAB-wrksp_', g.Group_Name) + LEN('FAB-wrksp_')) + 1
		            END
		        )
		    ELSE NULL
		END AS fabric_workspace,
		
		-- FABRIC DATABASE
		CASE 
		    WHEN g.Group_Name LIKE '%FAB-DB_%' THEN
		        SUBSTRING(
		            g.Group_Name,
		            CHARINDEX('FAB-DB_', g.Group_Name) + LEN('FAB-DB_'),
		            CASE 
		                WHEN CHARINDEX('_', g.Group_Name, CHARINDEX('FAB-DB_', g.Group_Name) + LEN('FAB-DB_')) > 0
		                THEN CHARINDEX('_', g.Group_Name, CHARINDEX('FAB-DB_', g.Group_Name) + LEN('FAB-DB_'))
		                     - (CHARINDEX('FAB-DB_', g.Group_Name) + LEN('FAB-DB_'))
		                ELSE LEN(g.Group_Name) - (CHARINDEX('FAB-DB_', g.Group_Name) + LEN('FAB-DB_')) + 1
		            END
		        )
		    ELSE NULL
		END AS fabric_database,
		
		-- FABRIC DATA PRODUCT (ACCESS)
		CASE 
		    WHEN g.Group_Name LIKE '%FAB-DP_%' AND g.Group_Name NOT LIKE '%-RLS_%' THEN
		        SUBSTRING(
		            g.Group_Name,
		            CHARINDEX('FAB-DP_', g.Group_Name) + LEN('FAB-DP_'),
		            CASE 
		                WHEN CHARINDEX('_', g.Group_Name, CHARINDEX('FAB-DP_', g.Group_Name) + LEN('FAB-DP_')) > 0
		                THEN CHARINDEX('_', g.Group_Name, CHARINDEX('FAB-DP_', g.Group_Name) + LEN('FAB-DP_'))
		                     - (CHARINDEX('FAB-DP_', g.Group_Name) + LEN('FAB-DP_'))
		                ELSE LEN(g.Group_Name) - (CHARINDEX('FAB-DP_', g.Group_Name) + LEN('FAB-DP_')) + 1
		            END
		        )
		    ELSE NULL
		END AS fabric_data_product,
		
		-- FABRIC DATA PRODUCT RLS
		CASE 
		    WHEN g.Group_Name LIKE '%FAB-DP-RLS%' THEN
		        CASE 
		            WHEN CHARINDEX('Mgroup-', g.Group_Name) > 0 THEN 'Mgroup'
		            WHEN CHARINDEX('Mindustry-', g.Group_Name) > 0 THEN 'Mindustry'
		            ELSE 'Mcompany'
		        END
		    ELSE NULL
		END AS fabric_rls,
        
		-- GROUP ROLE
		CASE 
            WHEN CHARINDEX('Mgroup-', g.Group_Name) > 0 THEN 
                RIGHT(g.Group_Name, LEN(g.Group_Name) - CHARINDEX('Mgroup-', g.Group_Name) - LEN('Mgroup-') + 1)
            WHEN CHARINDEX('FAB-DP-RLS_', g.Group_Name) > 0 AND LEFT(g.Group_Name,4) <> 'GLO_' THEN
                RIGHT(g.Group_Name, LEN(g.Group_Name) - CHARINDEX('FAB-DP-RLS_', g.Group_Name) - LEN('FAB-DP-RLS_') + 1)
            ELSE RIGHT(g.Group_Name, CHARINDEX('_', REVERSE(g.Group_Name)) - 1)
        END AS group_role,
		
		-- INDUSTRY
        CASE WHEN CHARINDEX('Mindustry-', g.Group_Name) > 0 THEN 
		    UPPER(RIGHT(g.Group_Name, LEN(g.Group_Name) - CHARINDEX('Mindustry-', g.Group_Name) - LEN('Mindustry-') + 1))
		    ELSE NULL
		END AS industry_code
		
  
	FROM {{ ref('sv_oil_genericdata_ms_entra_groups') }} g
    WHERE g.Group_Name LIKE '%FAB-wrksp_%' OR g.Group_Name LIKE '%FAB-DB_%' OR g.Group_Name LIKE '%FAB-DP-RLS_%' OR g.Group_Name LIKE '%FAB-DP_%'  
)

SELECT *
FROM parsed_groups
