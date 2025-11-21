--SELECT * FROM [REF_SHP].[GeoLoc_Country_STG] as TblSTG
--SELECT * FROM [REF_SHP].[GeoLoc_Country_ODS] as TblODS

CREATE PROC [REF_SHP].[UpSert_GeoLoc_Country_ODS]

AS
BEGIN

	/*
	 ********************************************************************************************************
	 *	Update the ODSHashValue Field in the Staging table with the Hash value of the record.				*
	 ********************************************************************************************************
	*/

UPDATE TblSTG
SET ODSKey= [Country_key]
,ODSVersion=0
, ODSHash =  CAST(HASHBYTES('MD5',
            ISNULL([Country_key],'')+ '|' + 
			ISNULL([Country_alpha2],'')+ '|' + 
			ISNULL([Country_alpha3],'')+ '|' + 
			ISNULL([Country_name],'')+ '|' + 
			ISNULL([GeoSubRegion_key],'')+ '|' + 
			ISNULL([GeoSubRegion_name],'')+ '|' + 
			ISNULL([GeoRegion_key],'')+ '|' + 
			ISNULL([GeoRegion_name],'')+ '|' + 
			ISNULL([Country_CommercialRegion],'')+ '|' + 
			CAST(ISNULL(CAST([RowModifiedOn] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26))  + '|' + 
			CAST(ISNULL([RowModifiedBy], 0) AS NVARCHAR(50)) 
       )AS BINARY(16))
FROM [OSS_GenericData_MHQ_Warehouse].[REF_SHP].[GeoLoc_Country_STG] as TblSTG;

							 
	/*
	 ********************************************************************************************************
	 *	If the Destination table has no records update the Staging table Record Source with the value (N)ew.*
	 ********************************************************************************************************
	*/

	IF  EXISTS (SELECT count(*) FROM [REF_SHP].[GeoLoc_Country_STG] HAVING count(*) > 0)
	BEGIN
	    UPDATE [REF_SHP].[GeoLoc_Country_STG]
		   SET [ODSChanged] = 'N' 
		 WHERE [ODSChanged] IS NULL
	END	;

	/*
	 ********************************************************************************************************
	 *	If the Destination table is not empty Update the ODSRecordStatus with values (N), (C) or (S).		*
	 ********************************************************************************************************
	*/

	IF EXISTS (SELECT count(*) FROM [REF_SHP].[GeoLoc_Country_ODS] HAVING count(*) > 0)
	BEGIN
	-- Set 'New' when records doesn't exist in ODS
		UPDATE Stg
		   SET Stg.[ODSChanged] = 'N', ODSVersion = 0
		  FROM [REF_SHP].[GeoLoc_Country_STG] Stg LEFT JOIN [REF_SHP].[GeoLoc_Country_ODS] Ods
		    ON Stg.[ODSKey] = Ods.[ODSKey]
		 WHERE Ods.[ODSKey] IS NULL

-----------------------
	-- Set 'Change' status
	UPDATE Stg
		   SET Stg.[ODSChanged] = 'C'
		  FROM [REF_SHP].[GeoLoc_Country_STG] Stg INNER JOIN [REF_SHP].[GeoLoc_Country_ODS] Ods
		    ON Stg.[ODSKey] = Ods.[ODSKey]
		 WHERE Stg.[ODSHash] <> Ods.[ODSHash]
	-- Update OdsVersion = MaxVersion on OdsKey	 
	UPDATE Stg
		   SET ODSVersion = Ods.ODSVersion
		  FROM [REF_SHP].[GeoLoc_Country_STG] Stg INNER JOIN (SELECT tbl.ODSKey, max(tbl.ODSVersion) ODSVersion from [REF_SHP].[GeoLoc_Country_ODS] tbl GROUP BY tbl.ODSKey) Ods
		    ON Stg.[ODSKey] = Ods.[ODSKey]
		 WHERE Stg.[ODSChanged] = 'C'

----------------
	UPDATE Stg
		   SET Stg.[ODSChanged] = 'S'
		  FROM [REF_SHP].[GeoLoc_Country_STG] Stg INNER JOIN [REF_SHP].[GeoLoc_Country_ODS] Ods
		    ON Stg.[ODSKey] = Ods.[ODSKey]
		 WHERE Stg.[ODSHash] = Ods.[ODSHash]	

	END;				
	/*
	 ********************************************************************************************************
	 *	Update ODS Fields if table Exists.																	*
	 ********************************************************************************************************
	*/
	
	UPDATE Ods
		   SET Ods.[ODSEndDate] = GETDATE(),
		   Ods.[ODSActive] = CONVERT(BIT, 0),
		   Ods.[ODSDeleted] =CONVERT(BIT, 0)
		  FROM [REF_SHP].[GeoLoc_Country_STG] Stg INNER JOIN [REF_SHP].[GeoLoc_Country_ODS] Ods
		    ON Stg.[ODSKey] = Ods.[ODSKey]
		 WHERE Stg.[ODSChanged] = 'C'
	   AND Ods.[ODSEndDate] = CONVERT(DATETIME, '31-12-9999', 103)
	   AND Ods.[ODSActive] = CONVERT(BIT, 1); 

	   -- Update For DELETED RECORDS
	   UPDATE Ods
		   SET Ods.[ODSEndDate] = GETDATE(),
		   Ods.[ODSActive] = CONVERT(BIT, 0),
		   Ods.[ODSDeleted] =CONVERT(BIT, 1)
		  FROM [REF_SHP].[GeoLoc_Country_ODS] Ods LEFT JOIN [REF_SHP].[GeoLoc_Country_STG] Stg
		    ON Stg.[ODSKey] = Ods.[ODSKey]
		   WHERE Stg.[ODSKey] is Null	
		   and Ods.[ODSDeleted] is null
			


	/*
	 ********************************************************************************************************
	 *	Insert New And Changed records in the ODS Table.													*
	 ********************************************************************************************************
	*/
	
	INSERT INTO [REF_SHP].[GeoLoc_Country_ODS]
		([ODSKey],
			[ODSVersion],
			[ODSActive],
			[Country_key],
			[Country_alpha2],
			[Country_alpha3],
			[Country_name],
			[GeoSubRegion_key],
			[GeoSubRegion_name],
			[GeoRegion_key],
			[GeoRegion_name],
			[Country_CommercialRegion],
			[RowModifiedOn],
			[RowModifiedBy],
			[ODSHash],
			[ODSStartDate],
			[ODSEndDate]
		)
		SELECT [ODSKey],
			[ODSVersion] + 1,
			CONVERT(BIT, 1),
			[Country_key],
			[Country_alpha2],
			[Country_alpha3],
			[Country_name],
			[GeoSubRegion_key],
			[GeoSubRegion_name],
			[GeoRegion_key],
			[GeoRegion_name],
			[Country_CommercialRegion],
			[RowModifiedOn],
			[RowModifiedBy],
			[ODSHash],
			GETUTCDATE() ,
			CONVERT(DATETIME, '31-12-9999', 103) 
		FROM [OSS_GenericData_MHQ_Warehouse].[REF_SHP].[GeoLoc_Country_STG]
		WHERE [ODSChanged] IN ('C', 'N');		


END