
/*
 ************************************************************************************************************
 *	Create Stored Procedure.																				*
 ************************************************************************************************************
*/

CREATE PROCEDURE [21D365_ods].[usp_Insertmainaccount]

AS

BEGIN

	/*
	 ********************************************************************************************************
	 *	Update the ODSHashValue Field in the Staging table with the Hash value of the record.				*
	 ********************************************************************************************************
	*/

	UPDATE A
	   SET [ODSHashValue] = CAST(HASHBYTES('MD5', ISNULL(SUBSTRING([Id], 1, 255), '') + '|' + 							CAST(ISNULL(CAST([SinkCreatedOn] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL(CAST([SinkModifiedOn] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL([adjustmentmethod_mx], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([closetype], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([closing], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([debitcreditbalancedemand], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([debitcreditcheck], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([debitcreditproposal], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([exchangeadjusted], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([financialreportingtranslationtype], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([inflationadjustment_mx], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([mandatorypaymentreference], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([monetary], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([postingtype], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([repomotype_mx], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([reportingaccounttype], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([type], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([validatecurrency], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([validateposting], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([validateuser], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([sysdatastatecode], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([accountcategoryref], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([consolidationmainaccount], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([currencycode], 1, 255), '') + '|' + 							CAST(ISNULL([exchangeadjustmentratetype], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([financialreportingexchangeratetype], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([ledgerchartofaccounts], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([mainaccountid], 1, 255), '') + '|' + 							CAST(ISNULL([mainaccounttemplate], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([name], 1, 255), '') + '|' + 							CAST(ISNULL([offsetledgerdimension], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([openingaccount], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([parentmainaccount], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([srucode], 1, 255), '') + '|' + 							CAST(ISNULL([transferyearendaccount_es], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([unitofmeasure], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([userinfoid], 1, 255), '') + '|' + 							CAST(ISNULL([parentmainaccount_br], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([reportingexchangeadjustmentratetype], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([standardmainaccount_w], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL(CAST([modifieddatetime] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							ISNULL(SUBSTRING([modifiedby], 1, 255), '') + '|' + 							CAST(ISNULL([modifiedtransactionid], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL(CAST([createddatetime] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							ISNULL(SUBSTRING([createdby], 1, 255), '') + '|' + 							CAST(ISNULL([createdtransactionid], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([dataareaid], 1, 255), '') + '|' + 							CAST(ISNULL([recversion], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([partition], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([sysrowversion], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([recid], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([tableid], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([versionnumber], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL(CAST([createdon] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL(CAST([modifiedon] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL([IsDelete], 0) AS NVARCHAR(50)) + '|' + 							ISNULL([PartitionId], '')) AS BINARY(16))
	  FROM [21D365_stg].[mainaccount] A; 

							 
	/*
	 ********************************************************************************************************
	 *	If the Destination table has no records update the Staging table Record Source with the value (N)ew.*
	 ********************************************************************************************************
	*/

	IF NOT EXISTS (SELECT count(*) FROM [21D365_ods].[mainaccount] HAVING count(*) > 0)
	BEGIN
	    UPDATE [21D365_stg].[mainaccount]
		   SET [ODSRecordStatus] = 'N'
		 WHERE [ODSRecordStatus] IS NULL
	END;

	/*
	 ********************************************************************************************************
	 *	If the Destination table is not empty Update the ODSRecordStatus with values (N), (C) or (S).		*
	 ********************************************************************************************************
	*/

	IF EXISTS (SELECT count(*) FROM [21D365_ods].[mainaccount] HAVING count(*) > 0)
	BEGIN

		UPDATE A
		   SET A.[ODSRecordStatus] = 'N'
		  FROM [21D365_stg].[mainaccount] A LEFT JOIN [21D365_ods].[mainaccount] B
		    ON A.[recid] = B.[recid]
		 WHERE B.[recid] IS NULL

		UPDATE A
		   SET A.[ODSRecordStatus] = 'C'
		  FROM [21D365_stg].[mainaccount] A INNER JOIN [21D365_ods].[mainaccount] B
		    ON A.[recid] = B.[recid]
		   AND A.[ODSHashValue] <> B.[ODSHashValue]

		UPDATE A
		   SET A.[ODSRecordStatus] = 'S'
		  FROM [21D365_stg].[mainaccount] A INNER JOIN [21D365_ods].[mainaccount] B
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
	  FROM [21D365_ods].[mainaccount] A INNER JOIN [21D365_stg].[mainaccount] B
	    ON A.[recid] = B.[recid]
	 WHERE B.[ODSRecordStatus] = 'C'
	   AND A.[ODSEndDate] = CONVERT(DATETIME, '31-12-9999', 103)
	   AND A.[ODSActive] = CONVERT(BIT, 1); 
	
	/*
	 ********************************************************************************************************
	 *	Insert New And Changed records in the ODS Table.													*
	 ********************************************************************************************************
	*/

	INSERT INTO [21D365_ods].[mainaccount]			(			 [Id],			 [SinkCreatedOn],			 [SinkModifiedOn],			 [adjustmentmethod_mx],			 [closetype],			 [closing],			 [debitcreditbalancedemand],			 [debitcreditcheck],			 [debitcreditproposal],			 [exchangeadjusted],			 [financialreportingtranslationtype],			 [inflationadjustment_mx],			 [mandatorypaymentreference],			 [monetary],			 [postingtype],			 [repomotype_mx],			 [reportingaccounttype],			 [type],			 [validatecurrency],			 [validateposting],			 [validateuser],			 [sysdatastatecode],			 [accountcategoryref],			 [consolidationmainaccount],			 [currencycode],			 [exchangeadjustmentratetype],			 [financialreportingexchangeratetype],			 [ledgerchartofaccounts],			 [mainaccountid],			 [mainaccounttemplate],			 [name],			 [offsetledgerdimension],			 [openingaccount],			 [parentmainaccount],			 [srucode],			 [transferyearendaccount_es],			 [unitofmeasure],			 [userinfoid],			 [parentmainaccount_br],			 [reportingexchangeadjustmentratetype],			 [standardmainaccount_w],			 [modifieddatetime],			 [modifiedby],			 [modifiedtransactionid],			 [createddatetime],			 [createdby],			 [createdtransactionid],			 [dataareaid],			 [recversion],			 [partition],			 [sysrowversion],			 [recid],			 [tableid],			 [versionnumber],			 [createdon],			 [modifiedon],			 [IsDelete],			 [PartitionId],			 [ODSStartDate],			 [ODSEndDate],			 [ODSActive],			 [ODSHashValue]			) 	  SELECT [Id],			 [SinkCreatedOn],			 [SinkModifiedOn],			 [adjustmentmethod_mx],			 [closetype],			 [closing],			 [debitcreditbalancedemand],			 [debitcreditcheck],			 [debitcreditproposal],			 [exchangeadjusted],			 [financialreportingtranslationtype],			 [inflationadjustment_mx],			 [mandatorypaymentreference],			 [monetary],			 [postingtype],			 [repomotype_mx],			 [reportingaccounttype],			 [type],			 [validatecurrency],			 [validateposting],			 [validateuser],			 [sysdatastatecode],			 [accountcategoryref],			 [consolidationmainaccount],			 [currencycode],			 [exchangeadjustmentratetype],			 [financialreportingexchangeratetype],			 [ledgerchartofaccounts],			 [mainaccountid],			 [mainaccounttemplate],			 [name],			 [offsetledgerdimension],			 [openingaccount],			 [parentmainaccount],			 [srucode],			 [transferyearendaccount_es],			 [unitofmeasure],			 [userinfoid],			 [parentmainaccount_br],			 [reportingexchangeadjustmentratetype],			 [standardmainaccount_w],			 [modifieddatetime],			 [modifiedby],			 [modifiedtransactionid],			 [createddatetime],			 [createdby],			 [createdtransactionid],			 [dataareaid],			 [recversion],			 [partition],			 [sysrowversion],			 [recid],			 [tableid],			 [versionnumber],			 [createdon],			 [modifiedon],			 [IsDelete],			 [PartitionId],			 GETUTCDATE(),			 CONVERT(DATETIME, '31-12-9999', 103),			 CONVERT(BIT, 1),			 [ODSHashValue] 		FROM [21D365_stg].[mainaccount] WHERE [ODSRecordStatus] IN ('C', 'N');					   
				
/*
 ************************************************************************************************************
 *	End of creating the stored procedure.																	*
 ************************************************************************************************************
*/

END

GO

