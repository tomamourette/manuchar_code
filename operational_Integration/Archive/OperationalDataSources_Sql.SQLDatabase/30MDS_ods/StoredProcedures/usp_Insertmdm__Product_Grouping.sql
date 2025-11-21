
/*
 ************************************************************************************************************
 *	Create Stored Procedure.																				*
 ************************************************************************************************************
*/

CREATE PROCEDURE [30MDS_ods].[usp_Insertmdm__Product_Grouping]

AS

BEGIN

	/*
	 ********************************************************************************************************
	 *	Update the ODSHashValue Field in the Staging table with the Hash value of the record.				*
	 ********************************************************************************************************
	*/

	UPDATE A
	   SET [ODSHashValue] = CAST(HASHBYTES('MD5', CAST(ISNULL([ID], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([MUID], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([Version_Name], 1, 255), '') + '|' + 							CAST(ISNULL([Version_Number], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([Version_ID], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([Version_Flag], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([Name], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([Code], 1, 255), '') + '|' + 							CAST(ISNULL([Change_Tracking_Mask], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([Product_Business_Unit_Code], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([Product_Business_Unit_Name], 1, 255), '') + '|' + 							CAST(ISNULL([Product_Business_Unit_ID], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([Product_Category], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([Product_Sub_Category], 1, 255), '') + '|' + 							CAST(ISNULL([Sort_Order], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL(CAST([Enter_DateTime] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							ISNULL(SUBSTRING([Enter_User_Name], 1, 255), '') + '|' + 							CAST(ISNULL([Enter_Version_Number], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL(CAST([Last_Change_DateTime] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							ISNULL(SUBSTRING([Last_Change_User_Name], 1, 255), '') + '|' + 							CAST(ISNULL([Last_Change_Version_Number], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([Validation_Status], 1, 255), '')) AS BINARY(16))
	  FROM [30MDS_stg].[mdm__Product_Grouping] A; 

							 
	/*
	 ********************************************************************************************************
	 *	If the Destination table has no records update the Staging table Record Source with the value (N)ew.*
	 ********************************************************************************************************
	*/

	IF NOT EXISTS (SELECT count(*) FROM [30MDS_ods].[mdm__Product_Grouping] HAVING count(*) > 0)
	BEGIN
	    UPDATE [30MDS_stg].[mdm__Product_Grouping]
		   SET [ODSRecordStatus] = 'N'
		 WHERE [ODSRecordStatus] IS NULL
	END;

	/*
	 ********************************************************************************************************
	 *	If the Destination table is not empty Update the ODSRecordStatus with values (N), (C) or (S).		*
	 ********************************************************************************************************
	*/

	IF EXISTS (SELECT count(*) FROM [30MDS_ods].[mdm__Product_Grouping] HAVING count(*) > 0)
	BEGIN

		UPDATE A
		   SET A.[ODSRecordStatus] = 'N'
		  FROM [30MDS_stg].[mdm__Product_Grouping] A LEFT JOIN [30MDS_ods].[mdm__Product_Grouping] B
		    ON A.[ID] = B.[ID]
		 WHERE B.[ID] IS NULL

		UPDATE A
		   SET A.[ODSRecordStatus] = 'C'
		  FROM [30MDS_stg].[mdm__Product_Grouping] A INNER JOIN [30MDS_ods].[mdm__Product_Grouping] B
		    ON A.[ID] = B.[ID]
		   AND A.[ODSHashValue] <> B.[ODSHashValue]

		UPDATE A
		   SET A.[ODSRecordStatus] = 'S'
		  FROM [30MDS_stg].[mdm__Product_Grouping] A INNER JOIN [30MDS_ods].[mdm__Product_Grouping] B
		    ON A.[ID] = B.[ID]
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
	  FROM [30MDS_ods].[mdm__Product_Grouping] A INNER JOIN [30MDS_stg].[mdm__Product_Grouping] B
	    ON A.[ID] = B.[ID]
	 WHERE B.[ODSRecordStatus] = 'C'
	   AND A.[ODSEndDate] = CONVERT(DATETIME, '31-12-9999', 103)
	   AND A.[ODSActive] = CONVERT(BIT, 1); 
	
	/*
	 ********************************************************************************************************
	 *	Set CommitSize variable to the number of records in the stage table.								*
	 ********************************************************************************************************
	*/

	
	DECLARE	@CommitCount	INTEGER

	SET @CommitCount = (SELECT COUNT(*) FROM [30MDS_stg].[mdm__Product_Grouping])

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
			INSERT INTO [30MDS_ods].[mdm__Product_Grouping]					(					 [ID],					 [MUID],					 [Version_Name],					 [Version_Number],					 [Version_ID],					 [Version_Flag],					 [Name],					 [Code],					 [Change_Tracking_Mask],					 [Product_Business_Unit_Code],					 [Product_Business_Unit_Name],					 [Product_Business_Unit_ID],					 [Product_Category],					 [Product_Sub_Category],					 [Sort_Order],					 [Enter_DateTime],					 [Enter_User_Name],					 [Enter_Version_Number],					 [Last_Change_DateTime],					 [Last_Change_User_Name],					 [Last_Change_Version_Number],					 [Validation_Status],					 [ODSStartDate],					 [ODSEndDate],					 [ODSActive],					 [ODSHashValue]					) 			  SELECT [ID],					 [MUID],					 [Version_Name],					 [Version_Number],					 [Version_ID],					 [Version_Flag],					 [Name],					 [Code],					 [Change_Tracking_Mask],					 [Product_Business_Unit_Code],					 [Product_Business_Unit_Name],					 [Product_Business_Unit_ID],					 [Product_Category],					 [Product_Sub_Category],					 [Sort_Order],					 [Enter_DateTime],					 [Enter_User_Name],					 [Enter_Version_Number],					 [Last_Change_DateTime],					 [Last_Change_User_Name],					 [Last_Change_Version_Number],					 [Validation_Status],					 GETUTCDATE(),					 CONVERT(DATETIME, '31-12-9999', 103),					 CONVERT(BIT, 1),					 [ODSHashValue] 				FROM [30MDS_stg].[mdm__Product_Grouping] WHERE [ODSRecordStatus] IN ('C', 'N');

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

