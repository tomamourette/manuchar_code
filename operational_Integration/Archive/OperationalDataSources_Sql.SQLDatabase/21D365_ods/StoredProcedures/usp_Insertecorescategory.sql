
/*
 ************************************************************************************************************
 *	Create Stored Procedure.																				*
 ************************************************************************************************************
*/

CREATE PROCEDURE [21D365_ods].[usp_Insertecorescategory]

AS

BEGIN

	/*
	 ********************************************************************************************************
	 *	Update the ODSHashValue Field in the Staging table with the Hash value of the record.				*
	 ********************************************************************************************************
	*/

	UPDATE A
	   SET [ODSHashValue] = CAST(HASHBYTES('MD5', ISNULL(SUBSTRING([Id], 1, 255), '') + '|' + 							CAST(ISNULL(CAST([SinkCreatedOn] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL(CAST([SinkModifiedOn] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL([changestatus], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([isactive], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([iscategoryattributesinherited], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([istangible], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([exempt_in], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([nongst_in], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([forcefulllookupsync], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([sysdatastatecode], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([categoryhierarchy], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([code], 1, 255), '') + '|' + 							CAST(ISNULL([defaultprojectglobalcategory], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([defaultthreshold_psn], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([instancerelationtype], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([level], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([name], 1, 255), '') + '|' + 							CAST(ISNULL([nestedsetleft], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([nestedsetright], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([parentcategory], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([pkwiucode], 1, 255), '') + '|' + 							CAST(ISNULL([hsncodetable_in], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([serviceaccountingcodetable_in], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([displayorder], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([externalid], 1, 255), '') + '|' + 							CAST(ISNULL(CAST([modifieddatetime] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							ISNULL(SUBSTRING([modifiedby], 1, 255), '') + '|' + 							CAST(ISNULL([modifiedtransactionid], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL(CAST([createddatetime] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							ISNULL(SUBSTRING([createdby], 1, 255), '') + '|' + 							CAST(ISNULL([createdtransactionid], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([dataareaid], 1, 255), '') + '|' + 							CAST(ISNULL([recversion], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([partition], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([sysrowversion], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([recid], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([tableid], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([versionnumber], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL(CAST([createdon] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL(CAST([modifiedon] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL([IsDelete], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([PartitionId], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([Ingestion_Timestamp], 1, 255), '')) AS BINARY(16))
	  FROM [21D365_stg].[ecorescategory] A; 

							 
	/*
	 ********************************************************************************************************
	 *	If the Destination table has no records update the Staging table Record Source with the value (N)ew.*
	 ********************************************************************************************************
	*/

	IF NOT EXISTS (SELECT count(*) FROM [21D365_ods].[ecorescategory] HAVING count(*) > 0)
	BEGIN
	    UPDATE [21D365_stg].[ecorescategory]
		   SET [ODSRecordStatus] = 'N'
		 WHERE [ODSRecordStatus] IS NULL
	END;

	/*
	 ********************************************************************************************************
	 *	If the Destination table is not empty Update the ODSRecordStatus with values (N), (C) or (S).		*
	 ********************************************************************************************************
	*/

	IF EXISTS (SELECT count(*) FROM [21D365_ods].[ecorescategory] HAVING count(*) > 0)
	BEGIN

		UPDATE A
		   SET A.[ODSRecordStatus] = 'N'
		  FROM [21D365_stg].[ecorescategory] A LEFT JOIN [21D365_ods].[ecorescategory] B
		    ON A.[recid] = B.[recid]
		 WHERE B.[recid] IS NULL

		UPDATE A
		   SET A.[ODSRecordStatus] = 'C'
		  FROM [21D365_stg].[ecorescategory] A INNER JOIN [21D365_ods].[ecorescategory] B
		    ON A.[recid] = B.[recid]
		   AND A.[ODSHashValue] <> B.[ODSHashValue]

		UPDATE A
		   SET A.[ODSRecordStatus] = 'S'
		  FROM [21D365_stg].[ecorescategory] A INNER JOIN [21D365_ods].[ecorescategory] B
		    ON A.[recid] = B.[recid]
		   AND A.[ODSHashValue] = B.[ODSHashValue]
	END;				
	/*
	 ********************************************************************************************************
	 *	Update ODS Fields if table Exists.																	*
	 ********************************************************************************************************
	*/

	UPDATE A
	   SET A.[ODSEndDate] = GETDATE(),
		   A.[ODSActive] = CONVERT(BIT, 0)
	  FROM [21D365_ods].[ecorescategory] A INNER JOIN [21D365_stg].[ecorescategory] B
	    ON A.[recid] = B.[recid]
	 WHERE B.[ODSRecordStatus] = 'C'
	   AND A.[ODSEndDate] = CONVERT(DATETIME, '31-12-9999', 103)
	   AND A.[ODSActive] = CONVERT(BIT, 1); 
	
	/*
	 ********************************************************************************************************
	 *	Insert New And Changed records in the ODS Table.													*
	 ********************************************************************************************************
	*/

	INSERT INTO [21D365_ods].[ecorescategory]			(			 [Id],			 [SinkCreatedOn],			 [SinkModifiedOn],			 [changestatus],			 [isactive],			 [iscategoryattributesinherited],			 [istangible],			 [exempt_in],			 [nongst_in],			 [forcefulllookupsync],			 [sysdatastatecode],			 [categoryhierarchy],			 [code],			 [defaultprojectglobalcategory],			 [defaultthreshold_psn],			 [instancerelationtype],			 [level],			 [name],			 [nestedsetleft],			 [nestedsetright],			 [parentcategory],			 [pkwiucode],			 [hsncodetable_in],			 [serviceaccountingcodetable_in],			 [displayorder],			 [externalid],			 [modifieddatetime],			 [modifiedby],			 [modifiedtransactionid],			 [createddatetime],			 [createdby],			 [createdtransactionid],			 [dataareaid],			 [recversion],			 [partition],			 [sysrowversion],			 [recid],			 [tableid],			 [versionnumber],			 [createdon],			 [modifiedon],			 [IsDelete],			 [PartitionId],			 [Ingestion_Timestamp],			 [ODSStartDate],			 [ODSEndDate],			 [ODSActive],			 [ODSHashValue]			) 	  SELECT [Id],			 [SinkCreatedOn],			 [SinkModifiedOn],			 [changestatus],			 [isactive],			 [iscategoryattributesinherited],			 [istangible],			 [exempt_in],			 [nongst_in],			 [forcefulllookupsync],			 [sysdatastatecode],			 [categoryhierarchy],			 [code],			 [defaultprojectglobalcategory],			 [defaultthreshold_psn],			 [instancerelationtype],			 [level],			 [name],			 [nestedsetleft],			 [nestedsetright],			 [parentcategory],			 [pkwiucode],			 [hsncodetable_in],			 [serviceaccountingcodetable_in],			 [displayorder],			 [externalid],			 [modifieddatetime],			 [modifiedby],			 [modifiedtransactionid],			 [createddatetime],			 [createdby],			 [createdtransactionid],			 [dataareaid],			 [recversion],			 [partition],			 [sysrowversion],			 [recid],			 [tableid],			 [versionnumber],			 [createdon],			 [modifiedon],			 [IsDelete],			 [PartitionId],			 [Ingestion_Timestamp],			 GETUTCDATE(),			 CONVERT(DATETIME, '31-12-9999', 103),			 CONVERT(BIT, 1),			 [ODSHashValue] 		FROM [21D365_stg].[ecorescategory] WHERE [ODSRecordStatus] IN ('C', 'N');					   
				
/*
 ************************************************************************************************************
 *	End of creating the stored procedure.																	*
 ************************************************************************************************************
*/

END

GO

