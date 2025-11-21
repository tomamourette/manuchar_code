
/*
 ************************************************************************************************************
 *	Create Stored Procedure.																				*
 ************************************************************************************************************
*/

CREATE PROCEDURE [30MDS_ods].[usp_Insertmdm__Product]

AS

BEGIN

	/*
	 ********************************************************************************************************
	 *	Update the ODSHashValue Field in the Staging table with the Hash value of the record.				*
	 ********************************************************************************************************
	*/

	UPDATE A
	   SET [ODSHashValue] = CAST(HASHBYTES('MD5', CAST(ISNULL([ID], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([MUID], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([VersionName], 1, 255), '') + '|' + 							CAST(ISNULL([VersionNumber], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([Version_ID], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([VersionFlag], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([Name], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([Code], 1, 255), '') + '|' + 							CAST(ISNULL([ChangeTrackingMask], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([HS_Code], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([Services_Code], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([Services_Name], 1, 255), '') + '|' + 							CAST(ISNULL([Services_ID], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([Product_ID], 1, 255), '') + '|' + 							CAST(ISNULL(CAST([EnterDateTime] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							ISNULL(SUBSTRING([EnterUserName], 1, 255), '') + '|' + 							CAST(ISNULL([EnterVersionNumber], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL(CAST([LastChgDateTime] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							ISNULL(SUBSTRING([LastChgUserName], 1, 255), '') + '|' + 							CAST(ISNULL([LastChgVersionNumber], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([ValidationStatus], 1, 255), '')) AS BINARY(16))
	  FROM [30MDS_stg].[mdm__Product] A; 

							 
	/*
	 ********************************************************************************************************
	 *	If the Destination table has no records update the Staging table Record Source with the value (N)ew.*
	 ********************************************************************************************************
	*/

	IF NOT EXISTS (SELECT count(*) FROM [30MDS_ods].[mdm__Product] HAVING count(*) > 0)
	BEGIN
	    UPDATE [30MDS_stg].[mdm__Product]
		   SET [ODSRecordStatus] = 'N'
		 WHERE [ODSRecordStatus] IS NULL
	END;

	/*
	 ********************************************************************************************************
	 *	If the Destination table is not empty Update the ODSRecordStatus with values (N), (C) or (S).		*
	 ********************************************************************************************************
	*/

	IF EXISTS (SELECT count(*) FROM [30MDS_ods].[mdm__Product] HAVING count(*) > 0)
	BEGIN

		UPDATE A
		   SET A.[ODSRecordStatus] = 'N'
		  FROM [30MDS_stg].[mdm__Product] A LEFT JOIN [30MDS_ods].[mdm__Product] B
		    ON A.[ID] = B.[ID]
		 WHERE B.[ID] IS NULL

		UPDATE A
		   SET A.[ODSRecordStatus] = 'C'
		  FROM [30MDS_stg].[mdm__Product] A INNER JOIN [30MDS_ods].[mdm__Product] B
		    ON A.[ID] = B.[ID]
		   AND A.[ODSHashValue] <> B.[ODSHashValue]

		UPDATE A
		   SET A.[ODSRecordStatus] = 'S'
		  FROM [30MDS_stg].[mdm__Product] A INNER JOIN [30MDS_ods].[mdm__Product] B
		    ON A.[ID] = B.[ID]
		   AND A.[ODSHashValue] = B.[ODSHashValue]

	END;				
	/*
	 ********************************************************************************************************
	 *	Update ODS Fields if table Exists.																	*
	 ********************************************************************************************************
	*/

	UPDATE A
	   SET A.[ODSEndDate] = GETUTCDATE(),
		   A.[ODSActive] = CONVERT(BIT, 0)
	  FROM [30MDS_ods].[mdm__Product] A INNER JOIN [30MDS_stg].[mdm__Product] B
	    ON A.[ID] = B.[ID]
	 WHERE B.[ODSRecordStatus] = 'C'
	   AND A.[ODSEndDate] = CONVERT(DATETIME, '31-12-9999', 103)
	   AND A.[ODSActive] = CONVERT(BIT, 1); 
	
	/*
	 ********************************************************************************************************
	 *	Set CommitCount variable to the number of records in the stage table.								*
	 ********************************************************************************************************
	*/
		
	DECLARE	@CommitCount	INTEGER

	SET @CommitCount = (SELECT COUNT(*) FROM [30MDS_stg].[mdm__Product])

	/*
	 ********************************************************************************************************
	 *	Insert New And Changed records in the ODS Table.													*
	 ********************************************************************************************************
	*/

	DECLARE @Committed	INTEGER,
			@CommitSize	INTEGER

		SET @Committed = 0
		SET @CommitSize = 100000

	WHILE @Committed < @CommitCount
	BEGIN
		BEGIN TRANSACTION
			INSERT INTO [30MDS_ods].[mdm__Product]					(					 [ID],					 [MUID],					 [VersionName],					 [VersionNumber],					 [Version_ID],					 [VersionFlag],					 [Name],					 [Code],					 [ChangeTrackingMask],					 [HS_Code],					 [Services_Code],					 [Services_Name],					 [Services_ID],					 [Product_ID],					 [EnterDateTime],					 [EnterUserName],					 [EnterVersionNumber],					 [LastChgDateTime],					 [LastChgUserName],					 [LastChgVersionNumber],					 [ValidationStatus],					 [ODSStartDate],					 [ODSEndDate],					 [ODSActive],					 [ODSHashValue]					) 			  SELECT [ID],					 [MUID],					 [VersionName],					 [VersionNumber],					 [Version_ID],					 [VersionFlag],					 [Name],					 [Code],					 [ChangeTrackingMask],					 [HS_Code],					 [Services_Code],					 [Services_Name],					 [Services_ID],					 [Product_ID],					 [EnterDateTime],					 [EnterUserName],					 [EnterVersionNumber],					 [LastChgDateTime],					 [LastChgUserName],					 [LastChgVersionNumber],					 [ValidationStatus],					 GETUTCDATE(),					 CONVERT(DATETIME, '31-12-9999', 103),					 CONVERT(BIT, 1),					 [ODSHashValue] 				FROM [30MDS_stg].[mdm__Product]			   WHERE [ODSRecordStatus] IN ('C', 'N');

		SET @Committed = @Committed + @CommitSize

		COMMIT TRANSACTION
	END
	
/*
 ************************************************************************************************************
 *	End of creating the stored procedure.																	*
 ************************************************************************************************************
*/

END

GO

