
/*
 ************************************************************************************************************
 *	Create Stored Procedure.																				*
 ************************************************************************************************************
*/

CREATE PROCEDURE [21D365_ods].[usp_Insertgeneraljournalaccountentry]

AS

BEGIN

	/*
	 ********************************************************************************************************
	 *	Update the ODSHashValue Field in the Staging table with the Hash value of the record.				*
	 ********************************************************************************************************
	*/

	UPDATE A
	   SET [ODSHashValue] = CAST(HASHBYTES('MD5', ISNULL(SUBSTRING([Id], 1, 255), '') + '|' + 							CAST(ISNULL(CAST([SinkCreatedOn] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL(CAST([SinkModifiedOn] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL([iscorrection], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([iscredit], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([postingtype], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([skipcreditcalculation], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([assetleasepostingtypes], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([assetleasetransactiontype], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([sysdatastatecode], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([accountingcurrencyamount], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([allocationlevel], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([generaljournalentry], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL(CAST([historicalexchangeratedate] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							ISNULL(SUBSTRING([ledgeraccount], 1, 255), '') + '|' + 							CAST(ISNULL([ledgerdimension], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([quantity], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([reportingcurrencyamount], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([subledgerjournalentry], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([text], 1, 255), '') + '|' + 							CAST(ISNULL([transactioncurrencyamount], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([transactioncurrencycode], 1, 255), '') + '|' + 							CAST(ISNULL([mainaccount], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([fintag], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([projid_sa], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([projtabledataareaid], 1, 255), '') + '|' + 							CAST(ISNULL([reasonref], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([paymentreference], 1, 255), '') + '|' + 							CAST(ISNULL([originalaccountentry], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL(CAST([modifieddatetime] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							ISNULL(SUBSTRING([modifiedby], 1, 255), '') + '|' + 							CAST(ISNULL([modifiedtransactionid], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL(CAST([createddatetime] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							ISNULL(SUBSTRING([createdby], 1, 255), '') + '|' + 							CAST(ISNULL([createdtransactionid], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([dataareaid], 1, 255), '') + '|' + 							CAST(ISNULL([recversion], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([partition], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([sysrowversion], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([recid], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([tableid], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([versionnumber], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL(CAST([createdon] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL(CAST([modifiedon] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL([IsDelete], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([PartitionId], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([Ingestion_Timestamp], 1, 255), '')) AS BINARY(16))
	  FROM [21D365_stg].[generaljournalaccountentry] A; 

							 
	/*
	 ********************************************************************************************************
	 *	If the Destination table has no records update the Staging table Record Source with the value (N)ew.*
	 ********************************************************************************************************
	*/

	IF NOT EXISTS (SELECT count(*) FROM [21D365_ods].[generaljournalaccountentry] HAVING count(*) > 0)
	BEGIN
	    UPDATE [21D365_stg].[generaljournalaccountentry]
		   SET [ODSRecordStatus] = 'N'
		 WHERE [ODSRecordStatus] IS NULL
	END;

	/*
	 ********************************************************************************************************
	 *	If the Destination table is not empty Update the ODSRecordStatus with values (N), (C) or (S).		*
	 ********************************************************************************************************
	*/

	IF EXISTS (SELECT count(*) FROM [21D365_ods].[generaljournalaccountentry] HAVING count(*) > 0)
	BEGIN

		UPDATE A
		   SET A.[ODSRecordStatus] = 'N'
		  FROM [21D365_stg].[generaljournalaccountentry] A LEFT JOIN [21D365_ods].[generaljournalaccountentry] B
		    ON A.[recid] = B.[recid]
		 WHERE B.[recid] IS NULL

		UPDATE A
		   SET A.[ODSRecordStatus] = 'C'
		  FROM [21D365_stg].[generaljournalaccountentry] A INNER JOIN [21D365_ods].[generaljournalaccountentry] B
		    ON A.[recid] = B.[recid]
		   AND A.[ODSHashValue] <> B.[ODSHashValue]

		UPDATE A
		   SET A.[ODSRecordStatus] = 'S'
		  FROM [21D365_stg].[generaljournalaccountentry] A INNER JOIN [21D365_ods].[generaljournalaccountentry] B
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
	  FROM [21D365_ods].[generaljournalaccountentry] A INNER JOIN [21D365_stg].[generaljournalaccountentry] B
	    ON A.[recid] = B.[recid]
	 WHERE B.[ODSRecordStatus] = 'C'
	   AND A.[ODSEndDate] = CONVERT(DATETIME, '31-12-9999', 103)
	   AND A.[ODSActive] = CONVERT(BIT, 1); 
	
	/*
	 ********************************************************************************************************
	 *	Set CommitSize variable to the number of records in the stage table.								*
	 ********************************************************************************************************
	*/

	
	DECLARE	@CommitCount	INTEGER

	SET @CommitCount = (SELECT COUNT(*) FROM [21D365_stg].[generaljournalaccountentry])

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
			INSERT INTO [21D365_ods].[generaljournalaccountentry]					(					 [Id],					 [SinkCreatedOn],					 [SinkModifiedOn],					 [iscorrection],					 [iscredit],					 [postingtype],					 [skipcreditcalculation],					 [assetleasepostingtypes],					 [assetleasetransactiontype],					 [sysdatastatecode],					 [accountingcurrencyamount],					 [allocationlevel],					 [generaljournalentry],					 [historicalexchangeratedate],					 [ledgeraccount],					 [ledgerdimension],					 [quantity],					 [reportingcurrencyamount],					 [subledgerjournalentry],					 [text],					 [transactioncurrencyamount],					 [transactioncurrencycode],					 [mainaccount],					 [fintag],					 [projid_sa],					 [projtabledataareaid],					 [reasonref],					 [paymentreference],					 [originalaccountentry],					 [modifieddatetime],					 [modifiedby],					 [modifiedtransactionid],					 [createddatetime],					 [createdby],					 [createdtransactionid],					 [dataareaid],					 [recversion],					 [partition],					 [sysrowversion],					 [recid],					 [tableid],					 [versionnumber],					 [createdon],					 [modifiedon],					 [IsDelete],					 [PartitionId],					 [Ingestion_Timestamp],					 [ODSStartDate],					 [ODSEndDate],					 [ODSActive],					 [ODSHashValue]					) 			  SELECT [Id],					 [SinkCreatedOn],					 [SinkModifiedOn],					 [iscorrection],					 [iscredit],					 [postingtype],					 [skipcreditcalculation],					 [assetleasepostingtypes],					 [assetleasetransactiontype],					 [sysdatastatecode],					 [accountingcurrencyamount],					 [allocationlevel],					 [generaljournalentry],					 [historicalexchangeratedate],					 [ledgeraccount],					 [ledgerdimension],					 [quantity],					 [reportingcurrencyamount],					 [subledgerjournalentry],					 [text],					 [transactioncurrencyamount],					 [transactioncurrencycode],					 [mainaccount],					 [fintag],					 [projid_sa],					 [projtabledataareaid],					 [reasonref],					 [paymentreference],					 [originalaccountentry],					 [modifieddatetime],					 [modifiedby],					 [modifiedtransactionid],					 [createddatetime],					 [createdby],					 [createdtransactionid],					 [dataareaid],					 [recversion],					 [partition],					 [sysrowversion],					 [recid],					 [tableid],					 [versionnumber],					 [createdon],					 [modifiedon],					 [IsDelete],					 [PartitionId],					 [Ingestion_Timestamp],					 GETUTCDATE(),					 CONVERT(DATETIME, '31-12-9999', 103),					 CONVERT(BIT, 1),					 [ODSHashValue] 				FROM [21D365_stg].[generaljournalaccountentry]			   WHERE [ODSRecordStatus] IN ('C', 'N');

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

