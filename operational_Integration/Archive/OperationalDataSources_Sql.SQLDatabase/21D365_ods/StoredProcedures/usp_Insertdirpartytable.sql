
/*
 ************************************************************************************************************
 *	Create Stored Procedure.																				*
 ************************************************************************************************************
*/

CREATE PROCEDURE [21D365_ods].[usp_Insertdirpartytable]

AS

BEGIN

	/*
	 ********************************************************************************************************
	 *	Update the ODSHashValue Field in the Staging table with the Hash value of the record.				*
	 ********************************************************************************************************
	*/

	UPDATE A
	   SET [ODSHashValue] = CAST(HASHBYTES('MD5', ISNULL(SUBSTRING([Id], 1, 255), '') + '|' + 							CAST(ISNULL(CAST([SinkCreatedOn] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL(CAST([SinkModifiedOn] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL([sysdatastatecode], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([instancerelationtype], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([knownas], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([languageid], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([name], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([namealias], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([partynumber], 1, 255), '') + '|' + 							CAST(ISNULL([primaryaddresslocation], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([primarycontactemail], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([primarycontactfax], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([primarycontactphone], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([primarycontacttelex], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([primarycontacturl], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([primarycontactfacebook], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([primarycontacttwitter], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([primarycontactlinkedin], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([addressbooknames], 1, 255), '') + '|' + 							CAST(ISNULL([legacyinstancerelationtype], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([mannationalidnumber_custom], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([manroles_custom], 1, 255), '') + '|' + 							CAST(ISNULL(CAST([modifieddatetime] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							ISNULL(SUBSTRING([modifiedby], 1, 255), '') + '|' + 							CAST(ISNULL([modifiedtransactionid], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL(CAST([createddatetime] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							ISNULL(SUBSTRING([createdby], 1, 255), '') + '|' + 							CAST(ISNULL([createdtransactionid], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([dataareaid], 1, 255), '') + '|' + 							CAST(ISNULL([recversion], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([partition], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([sysrowversion], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([recid], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([tableid], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([versionnumber], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL(CAST([createdon] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL(CAST([modifiedon] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL([IsDelete], 0) AS NVARCHAR(50)) + '|' + 							ISNULL([PartitionId], '') + '|' + 							ISNULL(SUBSTRING([sbontst_custom], 1, 255), '')) AS BINARY(16))
	  FROM [21D365_stg].[dirpartytable] A; 

							 
	/*
	 ********************************************************************************************************
	 *	If the Destination table has no records update the Staging table Record Source with the value (N)ew.*
	 ********************************************************************************************************
	*/

	IF NOT EXISTS (SELECT count(*) FROM [21D365_ods].[dirpartytable] HAVING count(*) > 0)
	BEGIN
	    UPDATE [21D365_stg].[dirpartytable]
		   SET [ODSRecordStatus] = 'N'
		 WHERE [ODSRecordStatus] IS NULL
	END;

	/*
	 ********************************************************************************************************
	 *	If the Destination table is not empty Update the ODSRecordStatus with values (N), (C) or (S).		*
	 ********************************************************************************************************
	*/

	IF EXISTS (SELECT count(*) FROM [21D365_ods].[dirpartytable] HAVING count(*) > 0)
	BEGIN

		UPDATE A
		   SET A.[ODSRecordStatus] = 'N'
		  FROM [21D365_stg].[dirpartytable] A LEFT JOIN [21D365_ods].[dirpartytable] B
		    ON A.[recid] = B.[recid]
		 WHERE B.[recid] IS NULL

		UPDATE A
		   SET A.[ODSRecordStatus] = 'C'
		  FROM [21D365_stg].[dirpartytable] A INNER JOIN [21D365_ods].[dirpartytable] B
		    ON A.[recid] = B.[recid]
		   AND A.[ODSHashValue] <> B.[ODSHashValue]

		UPDATE A
		   SET A.[ODSRecordStatus] = 'S'
		  FROM [21D365_stg].[dirpartytable] A INNER JOIN [21D365_ods].[dirpartytable] B
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
	  FROM [21D365_ods].[dirpartytable] A INNER JOIN [21D365_stg].[dirpartytable] B
	    ON A.[recid] = B.[recid]
	 WHERE B.[ODSRecordStatus] = 'C'
	   AND A.[ODSEndDate] = CONVERT(DATETIME, '31-12-9999', 103)
	   AND A.[ODSActive] = CONVERT(BIT, 1); 
	
	/*
	 ********************************************************************************************************
	 *	Insert New And Changed records in the ODS Table.													*
	 ********************************************************************************************************
	*/

	INSERT INTO [21D365_ods].[dirpartytable]			(			 [Id],			 [SinkCreatedOn],			 [SinkModifiedOn],			 [sysdatastatecode],			 [instancerelationtype],			 [knownas],			 [languageid],			 [name],			 [namealias],			 [partynumber],			 [primaryaddresslocation],			 [primarycontactemail],			 [primarycontactfax],			 [primarycontactphone],			 [primarycontacttelex],			 [primarycontacturl],			 [primarycontactfacebook],			 [primarycontacttwitter],			 [primarycontactlinkedin],			 [addressbooknames],			 [legacyinstancerelationtype],			 [mannationalidnumber_custom],			 [manroles_custom],			 [modifieddatetime],			 [modifiedby],			 [modifiedtransactionid],			 [createddatetime],			 [createdby],			 [createdtransactionid],			 [dataareaid],			 [recversion],			 [partition],			 [sysrowversion],			 [recid],			 [tableid],			 [versionnumber],			 [createdon],			 [modifiedon],			 [IsDelete],			 [PartitionId],			 [sbontst_custom],			 [ODSStartDate],			 [ODSEndDate],			 [ODSActive],			 [ODSHashValue]			) 	  SELECT [Id],			 [SinkCreatedOn],			 [SinkModifiedOn],			 [sysdatastatecode],			 [instancerelationtype],			 [knownas],			 [languageid],			 [name],			 [namealias],			 [partynumber],			 [primaryaddresslocation],			 [primarycontactemail],			 [primarycontactfax],			 [primarycontactphone],			 [primarycontacttelex],			 [primarycontacturl],			 [primarycontactfacebook],			 [primarycontacttwitter],			 [primarycontactlinkedin],			 [addressbooknames],			 [legacyinstancerelationtype],			 [mannationalidnumber_custom],			 [manroles_custom],			 [modifieddatetime],			 [modifiedby],			 [modifiedtransactionid],			 [createddatetime],			 [createdby],			 [createdtransactionid],			 [dataareaid],			 [recversion],			 [partition],			 [sysrowversion],			 [recid],			 [tableid],			 [versionnumber],			 [createdon],			 [modifiedon],			 [IsDelete],			 [PartitionId],			 [sbontst_custom],			 GETUTCDATE(),			 CONVERT(DATETIME, '31-12-9999', 103),			 CONVERT(BIT, 1),			 [ODSHashValue] 		FROM [21D365_stg].[dirpartytable] WHERE [ODSRecordStatus] IN ('C', 'N');					   
				
/*
 ************************************************************************************************************
 *	End of creating the stored procedure.																	*
 ************************************************************************************************************
*/

END

GO

