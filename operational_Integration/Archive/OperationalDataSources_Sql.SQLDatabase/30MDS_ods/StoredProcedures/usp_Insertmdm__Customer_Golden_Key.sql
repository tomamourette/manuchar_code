
/*
 ************************************************************************************************************
 *	Create Stored Procedure.																				*
 ************************************************************************************************************
*/

CREATE PROCEDURE [30MDS_ods].[usp_Insertmdm__Customer_Golden_Key]

AS

BEGIN

	/*
	 ********************************************************************************************************
	 *	Update the ODSHashValue Field in the Staging table with the Hash value of the record.				*
	 ********************************************************************************************************
	*/

	UPDATE A
	   SET [ODSHashValue] = CAST(HASHBYTES('MD5', CAST(ISNULL([ID], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([MUID], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([VersionName], 1, 255), '') + '|' + 							CAST(ISNULL([VersionNumber], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([Version_ID], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([VersionFlag], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([Name], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([Code], 1, 255), '') + '|' + 							CAST(ISNULL([ChangeTrackingMask], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([Legal_Number], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([Country_Code], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([Country_Name], 1, 255), '') + '|' + 							CAST(ISNULL([Country_ID], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([Address], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([ZIP_Code], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([City], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([Currency], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([Multinational_Customer_Code], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([Multinational_Customer_Name], 1, 255), '') + '|' + 							CAST(ISNULL([Multinational_Customer_ID], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([Affiliate_Code], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([Affiliate_Name], 1, 255), '') + '|' + 							CAST(ISNULL([Affiliate_ID], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([Industry_Type_Code], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([Industry_Type_Name], 1, 255), '') + '|' + 							CAST(ISNULL([Industry_Type_ID], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([MNC_Parent_Code], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([MNC_Parent_Name], 1, 255), '') + '|' + 							CAST(ISNULL([MNC_Parent_ID], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([Credendo_Debtor_Number], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([Latest_Annex_Number], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([CpRefNo], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([CpRefNo_Validation_Code], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([CpRefNo_Validation_Name], 1, 255), '') + '|' + 							CAST(ISNULL([CpRefNo_Validation_ID], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL(CAST([CpRefNo_Validation_Date] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL(CAST([EnterDateTime] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							ISNULL(SUBSTRING([EnterUserName], 1, 255), '') + '|' + 							CAST(ISNULL([EnterVersionNumber], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL(CAST([LastChgDateTime] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							ISNULL(SUBSTRING([LastChgUserName], 1, 255), '') + '|' + 							CAST(ISNULL([LastChgVersionNumber], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([ValidationStatus], 1, 255), '')) AS BINARY(16))
	  FROM [30MDS_stg].[mdm__Customer_Golden_Key] A; 

							 
	/*
	 ********************************************************************************************************
	 *	If the Destination table has no records update the Staging table Record Source with the value (N)ew.*
	 ********************************************************************************************************
	*/

	IF NOT EXISTS (SELECT count(*) FROM [30MDS_ods].[mdm__Customer_Golden_Key] HAVING count(*) > 0)
	BEGIN
	    UPDATE [30MDS_stg].[mdm__Customer_Golden_Key]
		   SET [ODSRecordStatus] = 'N'
		 WHERE [ODSRecordStatus] IS NULL
	END;

	/*
	 ********************************************************************************************************
	 *	If the Destination table is not empty Update the ODSRecordStatus with values (N), (C) or (S).		*
	 ********************************************************************************************************
	*/

	IF EXISTS (SELECT count(*) FROM [30MDS_ods].[mdm__Customer_Golden_Key] HAVING count(*) > 0)
	BEGIN

		UPDATE A
		   SET A.[ODSRecordStatus] = 'N'
		  FROM [30MDS_stg].[mdm__Customer_Golden_Key] A LEFT JOIN [30MDS_ods].[mdm__Customer_Golden_Key] B
		    ON A.[ID] = B.[ID]
		 WHERE B.[ID] IS NULL

		UPDATE A
		   SET A.[ODSRecordStatus] = 'C'
		  FROM [30MDS_stg].[mdm__Customer_Golden_Key] A INNER JOIN [30MDS_ods].[mdm__Customer_Golden_Key] B
		    ON A.[ID] = B.[ID]
		   AND A.[ODSHashValue] <> B.[ODSHashValue]

		UPDATE A
		   SET A.[ODSRecordStatus] = 'S'
		  FROM [30MDS_stg].[mdm__Customer_Golden_Key] A INNER JOIN [30MDS_ods].[mdm__Customer_Golden_Key] B
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
	  FROM [30MDS_ods].[mdm__Customer_Golden_Key] A INNER JOIN [30MDS_stg].[mdm__Customer_Golden_Key] B
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

	SET @CommitCount = (SELECT COUNT(*) FROM [30MDS_stg].[mdm__Customer_Golden_Key])

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
			INSERT INTO [30MDS_ods].[mdm__Customer_Golden_Key]					(					 [ID],					 [MUID],					 [VersionName],					 [VersionNumber],					 [Version_ID],					 [VersionFlag],					 [Name],					 [Code],					 [ChangeTrackingMask],					 [Legal_Number],					 [Country_Code],					 [Country_Name],					 [Country_ID],					 [Address],					 [ZIP_Code],					 [City],					 [Currency],					 [Multinational_Customer_Code],					 [Multinational_Customer_Name],					 [Multinational_Customer_ID],					 [Affiliate_Code],					 [Affiliate_Name],					 [Affiliate_ID],					 [Industry_Type_Code],					 [Industry_Type_Name],					 [Industry_Type_ID],					 [MNC_Parent_Code],					 [MNC_Parent_Name],					 [MNC_Parent_ID],					 [Credendo_Debtor_Number],					 [Latest_Annex_Number],					 [CpRefNo],					 [CpRefNo_Validation_Code],					 [CpRefNo_Validation_Name],					 [CpRefNo_Validation_ID],					 [CpRefNo_Validation_Date],					 [EnterDateTime],					 [EnterUserName],					 [EnterVersionNumber],					 [LastChgDateTime],					 [LastChgUserName],					 [LastChgVersionNumber],					 [ValidationStatus],					 [ODSStartDate],					 [ODSEndDate],					 [ODSActive],					 [ODSHashValue]					) 			  SELECT [ID],					 [MUID],					 [VersionName],					 [VersionNumber],					 [Version_ID],					 [VersionFlag],					 [Name],					 [Code],					 [ChangeTrackingMask],					 [Legal_Number],					 [Country_Code],					 [Country_Name],					 [Country_ID],					 [Address],					 [ZIP_Code],					 [City],					 [Currency],					 [Multinational_Customer_Code],					 [Multinational_Customer_Name],					 [Multinational_Customer_ID],					 [Affiliate_Code],					 [Affiliate_Name],					 [Affiliate_ID],					 [Industry_Type_Code],					 [Industry_Type_Name],					 [Industry_Type_ID],					 [MNC_Parent_Code],					 [MNC_Parent_Name],					 [MNC_Parent_ID],					 [Credendo_Debtor_Number],					 [Latest_Annex_Number],					 [CpRefNo],					 [CpRefNo_Validation_Code],					 [CpRefNo_Validation_Name],					 [CpRefNo_Validation_ID],					 [CpRefNo_Validation_Date],					 [EnterDateTime],					 [EnterUserName],					 [EnterVersionNumber],					 [LastChgDateTime],					 [LastChgUserName],					 [LastChgVersionNumber],					 [ValidationStatus],					 GETUTCDATE(),					 CONVERT(DATETIME, '31-12-9999', 103),					 CONVERT(BIT, 1),					 [ODSHashValue] 				FROM [30MDS_stg].[mdm__Customer_Golden_Key]			   WHERE [ODSRecordStatus] IN ('C', 'N');

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

