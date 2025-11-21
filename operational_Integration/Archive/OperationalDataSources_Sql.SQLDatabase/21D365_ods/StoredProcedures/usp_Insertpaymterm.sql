
/*
 ************************************************************************************************************
 *	Create Stored Procedure.																				*
 ************************************************************************************************************
*/

CREATE PROCEDURE [21D365_ods].[usp_Insertpaymterm]

AS

BEGIN

	/*
	 ********************************************************************************************************
	 *	Update the ODSHashValue Field in the Staging table with the Hash value of the record.				*
	 ********************************************************************************************************
	*/

	UPDATE A
	   SET [ODSHashValue] = CAST(HASHBYTES('MD5', ISNULL(SUBSTRING([Id], 1, 255), '') + '|' + 							CAST(ISNULL(CAST([SinkCreatedOn] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL(CAST([SinkModifiedOn] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL([cash], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([creditcardcreditcheck], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([creditcardpaymenttype], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([customerupdateduedate], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([defaultpaymterm_psn], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([paymmethod], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([postoffsettingar], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([shipcarrierancillarycharge], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([shipcarriercertifiedcheck], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([usedeliverydateforduedate_es], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([useemplaccount_ru], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([vendorupdateduedate], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([ecscanaddremark], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([mnrbasedontitletransferdate], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([mnrexcludecreditlimitcheck], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([sysdatastatecode], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([additionalmonths], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([cashledgerdimension], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([cutoffday], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([description], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([duedatelimitgroupid_es], 1, 255), '') + '|' + 							CAST(ISNULL([numofdays], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([numofmonths], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([paymdayid], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([paymsched], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([paymtermid], 1, 255), '') + '|' + 							CAST(ISNULL([cfmpaymentrequesttypepayment], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([cfmpaymentrequesttypeprepayment], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL(CAST([modifieddatetime] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							ISNULL(SUBSTRING([modifiedby], 1, 255), '') + '|' + 							CAST(ISNULL([modifiedtransactionid], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL(CAST([createddatetime] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							ISNULL(SUBSTRING([createdby], 1, 255), '') + '|' + 							CAST(ISNULL([createdtransactionid], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([dataareaid], 1, 255), '') + '|' + 							CAST(ISNULL([recversion], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([partition], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([sysrowversion], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([recid], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([tableid], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([versionnumber], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL(CAST([createdon] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL(CAST([modifiedon] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL([IsDelete], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([PartitionId], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([Ingestion_Timestamp], 1, 255), '')) AS BINARY(16))
	  FROM [21D365_stg].[paymterm] A; 

							 
	/*
	 ********************************************************************************************************
	 *	If the Destination table has no records update the Staging table Record Source with the value (N)ew.*
	 ********************************************************************************************************
	*/

	IF NOT EXISTS (SELECT count(*) FROM [21D365_ods].[paymterm] HAVING count(*) > 0)
	BEGIN
	    UPDATE [21D365_stg].[paymterm]
		   SET [ODSRecordStatus] = 'N'
		 WHERE [ODSRecordStatus] IS NULL
	END;

	/*
	 ********************************************************************************************************
	 *	If the Destination table is not empty Update the ODSRecordStatus with values (N), (C) or (S).		*
	 ********************************************************************************************************
	*/

	IF EXISTS (SELECT count(*) FROM [21D365_ods].[paymterm] HAVING count(*) > 0)
	BEGIN

		UPDATE A
		   SET A.[ODSRecordStatus] = 'N'
		  FROM [21D365_stg].[paymterm] A LEFT JOIN [21D365_ods].[paymterm] B
		    ON A.[recid] = B.[recid]
		 WHERE B.[recid] IS NULL

		UPDATE A
		   SET A.[ODSRecordStatus] = 'C'
		  FROM [21D365_stg].[paymterm] A INNER JOIN [21D365_ods].[paymterm] B
		    ON A.[recid] = B.[recid]
		   AND A.[ODSHashValue] <> B.[ODSHashValue]

		UPDATE A
		   SET A.[ODSRecordStatus] = 'S'
		  FROM [21D365_stg].[paymterm] A INNER JOIN [21D365_ods].[paymterm] B
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
	  FROM [21D365_ods].[paymterm] A INNER JOIN [21D365_stg].[paymterm] B
	    ON A.[recid] = B.[recid]
	 WHERE B.[ODSRecordStatus] = 'C'
	   AND A.[ODSEndDate] = CONVERT(DATETIME, '31-12-9999', 103)
	   AND A.[ODSActive] = CONVERT(BIT, 1); 
	
	/*
	 ********************************************************************************************************
	 *	Insert New And Changed records in the ODS Table.													*
	 ********************************************************************************************************
	*/

	INSERT INTO [21D365_ods].[paymterm]			(			 [Id],			 [SinkCreatedOn],			 [SinkModifiedOn],			 [cash],			 [creditcardcreditcheck],			 [creditcardpaymenttype],			 [customerupdateduedate],			 [defaultpaymterm_psn],			 [paymmethod],			 [postoffsettingar],			 [shipcarrierancillarycharge],			 [shipcarriercertifiedcheck],			 [usedeliverydateforduedate_es],			 [useemplaccount_ru],			 [vendorupdateduedate],			 [ecscanaddremark],			 [mnrbasedontitletransferdate],			 [mnrexcludecreditlimitcheck],			 [sysdatastatecode],			 [additionalmonths],			 [cashledgerdimension],			 [cutoffday],			 [description],			 [duedatelimitgroupid_es],			 [numofdays],			 [numofmonths],			 [paymdayid],			 [paymsched],			 [paymtermid],			 [cfmpaymentrequesttypepayment],			 [cfmpaymentrequesttypeprepayment],			 [modifieddatetime],			 [modifiedby],			 [modifiedtransactionid],			 [createddatetime],			 [createdby],			 [createdtransactionid],			 [dataareaid],			 [recversion],			 [partition],			 [sysrowversion],			 [recid],			 [tableid],			 [versionnumber],			 [createdon],			 [modifiedon],			 [IsDelete],			 [PartitionId],			 [Ingestion_Timestamp],			 [ODSStartDate],			 [ODSEndDate],			 [ODSActive],			 [ODSHashValue]			) 	  SELECT [Id],			 [SinkCreatedOn],			 [SinkModifiedOn],			 [cash],			 [creditcardcreditcheck],			 [creditcardpaymenttype],			 [customerupdateduedate],			 [defaultpaymterm_psn],			 [paymmethod],			 [postoffsettingar],			 [shipcarrierancillarycharge],			 [shipcarriercertifiedcheck],			 [usedeliverydateforduedate_es],			 [useemplaccount_ru],			 [vendorupdateduedate],			 [ecscanaddremark],			 [mnrbasedontitletransferdate],			 [mnrexcludecreditlimitcheck],			 [sysdatastatecode],			 [additionalmonths],			 [cashledgerdimension],			 [cutoffday],			 [description],			 [duedatelimitgroupid_es],			 [numofdays],			 [numofmonths],			 [paymdayid],			 [paymsched],			 [paymtermid],			 [cfmpaymentrequesttypepayment],			 [cfmpaymentrequesttypeprepayment],			 [modifieddatetime],			 [modifiedby],			 [modifiedtransactionid],			 [createddatetime],			 [createdby],			 [createdtransactionid],			 [dataareaid],			 [recversion],			 [partition],			 [sysrowversion],			 [recid],			 [tableid],			 [versionnumber],			 [createdon],			 [modifiedon],			 [IsDelete],			 [PartitionId],			 [Ingestion_Timestamp],			 GETUTCDATE(),			 CONVERT(DATETIME, '31-12-9999', 103),			 CONVERT(BIT, 1),			 [ODSHashValue] 		FROM [21D365_stg].[paymterm] WHERE [ODSRecordStatus] IN ('C', 'N');					   
				
/*
 ************************************************************************************************************
 *	End of creating the stored procedure.																	*
 ************************************************************************************************************
*/

END

GO

