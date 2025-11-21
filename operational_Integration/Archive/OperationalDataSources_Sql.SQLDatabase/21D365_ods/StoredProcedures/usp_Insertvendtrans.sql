
/*
 ************************************************************************************************************
 *	Create Stored Procedure.																				*
 ************************************************************************************************************
*/

CREATE PROCEDURE [21D365_ods].[usp_Insertvendtrans]

AS

BEGIN

	/*
	 ********************************************************************************************************
	 *	Update the ODSHashValue Field in the Staging table with the Hash value of the record.				*
	 ********************************************************************************************************
	*/

	UPDATE A
	   SET [ODSHashValue] = CAST(HASHBYTES('MD5', ISNULL(SUBSTRING([Id], 1, 255), '') + '|' + 							CAST(ISNULL(CAST([SinkCreatedOn] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL(CAST([SinkModifiedOn] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL([approved], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([arrival], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([cancel], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([correct], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([eurotriangulation], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([fixedexchrate], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([invoiceproject], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([prepayment], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([promissorynotestatus], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([rbovendtrans], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([settlement], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([transtype], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([psnpurchasingcardtype], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([rskfxhedged], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([sysdatastatecode], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([postingprofile], 1, 255), '') + '|' + 							CAST(ISNULL([accountingevent], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([accountnum], 1, 255), '') + '|' + 							CAST(ISNULL([amountcur], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([amountmst], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL(CAST([approveddate] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL([approver], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([bankcentralbankpurposecode], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([bankcentralbankpurposetext], 1, 255), '') + '|' + 							CAST(ISNULL([banklcimportline], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([bankremittancefileid], 1, 255), '') + '|' + 							CAST(ISNULL(CAST([cashdiscbasedate] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							ISNULL(SUBSTRING([cashdisccode], 1, 255), '') + '|' + 							CAST(ISNULL(CAST([closed] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							ISNULL(SUBSTRING([companybankaccountid], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([currencycode], 1, 255), '') + '|' + 							CAST(ISNULL([defaultdimension], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL(CAST([documentdate] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							ISNULL(SUBSTRING([documentnum], 1, 255), '') + '|' + 							CAST(ISNULL(CAST([duedate] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL([exchadjustment], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([exchadjustmentreporting], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([exchrate], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([exchratesecond], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([invoice], 1, 255), '') + '|' + 							CAST(ISNULL(CAST([invoicereleasedate] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							ISNULL(SUBSTRING([journalnum], 1, 255), '') + '|' + 							CAST(ISNULL(CAST([lastexchadj] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL([lastexchadjrate], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([lastexchadjratereporting], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([lastexchadjvoucher], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([lastsettleaccountnum], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([lastsettlecompany], 1, 255), '') + '|' + 							CAST(ISNULL(CAST([lastsettledate] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							ISNULL(SUBSTRING([lastsettlevoucher], 1, 255), '') + '|' + 							CAST(ISNULL([offsetrecid], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([paymid], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([paymmode], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([paymreference], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([paymspec], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([paymtermid], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([postingchangevoucher], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([postingprofileapprove], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([postingprofilecancel], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([postingprofileclose], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([postingprofilereopen], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([promissorynoteid], 1, 255), '') + '|' + 							CAST(ISNULL([promissorynoteseqnum], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([reasonrefrecid], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([releasedatecomment], 1, 255), '') + '|' + 							CAST(ISNULL([remittanceaddress], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([remittancelocation], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([reportingcurrencyamount], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([reportingcurrencycrossrate], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([reportingexchadjustmentrealized], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([reportingexchadjustmentunrealized], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([settleamountcur], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([settleamountmst], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([settleamountreporting], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([settletax1099amount], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([settletax1099stateamount], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([tax1099amount], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL(CAST([tax1099date] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL([tax1099fields], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([tax1099num], 1, 255), '') + '|' + 							CAST(ISNULL([tax1099recid], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([tax1099state], 1, 255), '') + '|' + 							CAST(ISNULL([tax1099stateamount], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([taxinvoicepurchid], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([thirdpartybankaccountid], 1, 255), '') + '|' + 							CAST(ISNULL(CAST([transdate] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							ISNULL(SUBSTRING([txt], 1, 255), '') + '|' + 							CAST(ISNULL([vendexchadjustmentrealized], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([vendexchadjustmentunrealized], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([vendpaymentgroup], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([voucher], 1, 255), '') + '|' + 							CAST(ISNULL([reportingcurrencyexchrate], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([reportingcurrencyexchratesecondary], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([arrivalaccountid], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([summaryaccountid], 1, 255), '') + '|' + 							CAST(ISNULL(CAST([vendorvatdate] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL([psnjournalizingdefinition], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([ecsapplicationreference], 1, 255), '') + '|' + 							CAST(ISNULL(CAST([modifieddatetime] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							ISNULL(SUBSTRING([modifiedby], 1, 255), '') + '|' + 							CAST(ISNULL([modifiedtransactionid], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL(CAST([createddatetime] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							ISNULL(SUBSTRING([createdby], 1, 255), '') + '|' + 							CAST(ISNULL([createdtransactionid], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([dataareaid], 1, 255), '') + '|' + 							CAST(ISNULL([recversion], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([partition], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([sysrowversion], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([recid], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([tableid], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([versionnumber], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL(CAST([createdon] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL(CAST([modifiedon] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL([IsDelete], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([PartitionId], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([Ingestion_Timestamp], 1, 255), '')) AS BINARY(16))
	  FROM [21D365_stg].[vendtrans] A; 

							 
	/*
	 ********************************************************************************************************
	 *	If the Destination table has no records update the Staging table Record Source with the value (N)ew.*
	 ********************************************************************************************************
	*/

	IF NOT EXISTS (SELECT count(*) FROM [21D365_ods].[vendtrans] HAVING count(*) > 0)
	BEGIN
	    UPDATE [21D365_stg].[vendtrans]
		   SET [ODSRecordStatus] = 'N'
		 WHERE [ODSRecordStatus] IS NULL
	END;

	/*
	 ********************************************************************************************************
	 *	If the Destination table is not empty Update the ODSRecordStatus with values (N), (C) or (S).		*
	 ********************************************************************************************************
	*/

	IF EXISTS (SELECT count(*) FROM [21D365_ods].[vendtrans] HAVING count(*) > 0)
	BEGIN

		UPDATE A
		   SET A.[ODSRecordStatus] = 'N'
		  FROM [21D365_stg].[vendtrans] A LEFT JOIN [21D365_ods].[vendtrans] B
		    ON A.[recid] = B.[recid]
		 WHERE B.[recid] IS NULL

		UPDATE A
		   SET A.[ODSRecordStatus] = 'C'
		  FROM [21D365_stg].[vendtrans] A INNER JOIN [21D365_ods].[vendtrans] B
		    ON A.[recid] = B.[recid]
		   AND A.[ODSHashValue] <> B.[ODSHashValue]

		UPDATE A
		   SET A.[ODSRecordStatus] = 'S'
		  FROM [21D365_stg].[vendtrans] A INNER JOIN [21D365_ods].[vendtrans] B
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
	  FROM [21D365_ods].[vendtrans] A INNER JOIN [21D365_stg].[vendtrans] B
	    ON A.[recid] = B.[recid]
	 WHERE B.[ODSRecordStatus] = 'C'
	   AND A.[ODSEndDate] = CONVERT(DATETIME, '31-12-9999', 103)
	   AND A.[ODSActive] = CONVERT(BIT, 1); 
	
	/*
	 ********************************************************************************************************
	 *	Insert New And Changed records in the ODS Table.													*
	 ********************************************************************************************************
	*/

	INSERT INTO [21D365_ods].[vendtrans]			(			 [Id],			 [SinkCreatedOn],			 [SinkModifiedOn],			 [approved],			 [arrival],			 [cancel],			 [correct],			 [eurotriangulation],			 [fixedexchrate],			 [invoiceproject],			 [prepayment],			 [promissorynotestatus],			 [rbovendtrans],			 [settlement],			 [transtype],			 [psnpurchasingcardtype],			 [rskfxhedged],			 [sysdatastatecode],			 [postingprofile],			 [accountingevent],			 [accountnum],			 [amountcur],			 [amountmst],			 [approveddate],			 [approver],			 [bankcentralbankpurposecode],			 [bankcentralbankpurposetext],			 [banklcimportline],			 [bankremittancefileid],			 [cashdiscbasedate],			 [cashdisccode],			 [closed],			 [companybankaccountid],			 [currencycode],			 [defaultdimension],			 [documentdate],			 [documentnum],			 [duedate],			 [exchadjustment],			 [exchadjustmentreporting],			 [exchrate],			 [exchratesecond],			 [invoice],			 [invoicereleasedate],			 [journalnum],			 [lastexchadj],			 [lastexchadjrate],			 [lastexchadjratereporting],			 [lastexchadjvoucher],			 [lastsettleaccountnum],			 [lastsettlecompany],			 [lastsettledate],			 [lastsettlevoucher],			 [offsetrecid],			 [paymid],			 [paymmode],			 [paymreference],			 [paymspec],			 [paymtermid],			 [postingchangevoucher],			 [postingprofileapprove],			 [postingprofilecancel],			 [postingprofileclose],			 [postingprofilereopen],			 [promissorynoteid],			 [promissorynoteseqnum],			 [reasonrefrecid],			 [releasedatecomment],			 [remittanceaddress],			 [remittancelocation],			 [reportingcurrencyamount],			 [reportingcurrencycrossrate],			 [reportingexchadjustmentrealized],			 [reportingexchadjustmentunrealized],			 [settleamountcur],			 [settleamountmst],			 [settleamountreporting],			 [settletax1099amount],			 [settletax1099stateamount],			 [tax1099amount],			 [tax1099date],			 [tax1099fields],			 [tax1099num],			 [tax1099recid],			 [tax1099state],			 [tax1099stateamount],			 [taxinvoicepurchid],			 [thirdpartybankaccountid],			 [transdate],			 [txt],			 [vendexchadjustmentrealized],			 [vendexchadjustmentunrealized],			 [vendpaymentgroup],			 [voucher],			 [reportingcurrencyexchrate],			 [reportingcurrencyexchratesecondary],			 [arrivalaccountid],			 [summaryaccountid],			 [vendorvatdate],			 [psnjournalizingdefinition],			 [ecsapplicationreference],			 [modifieddatetime],			 [modifiedby],			 [modifiedtransactionid],			 [createddatetime],			 [createdby],			 [createdtransactionid],			 [dataareaid],			 [recversion],			 [partition],			 [sysrowversion],			 [recid],			 [tableid],			 [versionnumber],			 [createdon],			 [modifiedon],			 [IsDelete],			 [PartitionId],			 [Ingestion_Timestamp],			 [ODSStartDate],			 [ODSEndDate],			 [ODSActive],			 [ODSHashValue]			) 	  SELECT [Id],			 [SinkCreatedOn],			 [SinkModifiedOn],			 [approved],			 [arrival],			 [cancel],			 [correct],			 [eurotriangulation],			 [fixedexchrate],			 [invoiceproject],			 [prepayment],			 [promissorynotestatus],			 [rbovendtrans],			 [settlement],			 [transtype],			 [psnpurchasingcardtype],			 [rskfxhedged],			 [sysdatastatecode],			 [postingprofile],			 [accountingevent],			 [accountnum],			 [amountcur],			 [amountmst],			 [approveddate],			 [approver],			 [bankcentralbankpurposecode],			 [bankcentralbankpurposetext],			 [banklcimportline],			 [bankremittancefileid],			 [cashdiscbasedate],			 [cashdisccode],			 [closed],			 [companybankaccountid],			 [currencycode],			 [defaultdimension],			 [documentdate],			 [documentnum],			 [duedate],			 [exchadjustment],			 [exchadjustmentreporting],			 [exchrate],			 [exchratesecond],			 [invoice],			 [invoicereleasedate],			 [journalnum],			 [lastexchadj],			 [lastexchadjrate],			 [lastexchadjratereporting],			 [lastexchadjvoucher],			 [lastsettleaccountnum],			 [lastsettlecompany],			 [lastsettledate],			 [lastsettlevoucher],			 [offsetrecid],			 [paymid],			 [paymmode],			 [paymreference],			 [paymspec],			 [paymtermid],			 [postingchangevoucher],			 [postingprofileapprove],			 [postingprofilecancel],			 [postingprofileclose],			 [postingprofilereopen],			 [promissorynoteid],			 [promissorynoteseqnum],			 [reasonrefrecid],			 [releasedatecomment],			 [remittanceaddress],			 [remittancelocation],			 [reportingcurrencyamount],			 [reportingcurrencycrossrate],			 [reportingexchadjustmentrealized],			 [reportingexchadjustmentunrealized],			 [settleamountcur],			 [settleamountmst],			 [settleamountreporting],			 [settletax1099amount],			 [settletax1099stateamount],			 [tax1099amount],			 [tax1099date],			 [tax1099fields],			 [tax1099num],			 [tax1099recid],			 [tax1099state],			 [tax1099stateamount],			 [taxinvoicepurchid],			 [thirdpartybankaccountid],			 [transdate],			 [txt],			 [vendexchadjustmentrealized],			 [vendexchadjustmentunrealized],			 [vendpaymentgroup],			 [voucher],			 [reportingcurrencyexchrate],			 [reportingcurrencyexchratesecondary],			 [arrivalaccountid],			 [summaryaccountid],			 [vendorvatdate],			 [psnjournalizingdefinition],			 [ecsapplicationreference],			 [modifieddatetime],			 [modifiedby],			 [modifiedtransactionid],			 [createddatetime],			 [createdby],			 [createdtransactionid],			 [dataareaid],			 [recversion],			 [partition],			 [sysrowversion],			 [recid],			 [tableid],			 [versionnumber],			 [createdon],			 [modifiedon],			 [IsDelete],			 [PartitionId],			 [Ingestion_Timestamp],			 GETUTCDATE(),			 CONVERT(DATETIME, '31-12-9999', 103),			 CONVERT(BIT, 1),			 [ODSHashValue] 		FROM [21D365_stg].[vendtrans] WHERE [ODSRecordStatus] IN ('C', 'N');					   
				
/*
 ************************************************************************************************************
 *	End of creating the stored procedure.																	*
 ************************************************************************************************************
*/

END

GO

