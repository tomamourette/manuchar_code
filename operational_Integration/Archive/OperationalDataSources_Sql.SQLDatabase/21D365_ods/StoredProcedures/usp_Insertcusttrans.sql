
/*
 ************************************************************************************************************
 *	Create Stored Procedure.																				*
 ************************************************************************************************************
*/

CREATE PROCEDURE [21D365_ods].[usp_Insertcusttrans]

AS

BEGIN

	/*
	 ********************************************************************************************************
	 *	Update the ODSHashValue Field in the Staging table with the Hash value of the record.				*
	 ********************************************************************************************************
	*/

	UPDATE A
	   SET [ODSHashValue] = CAST(HASHBYTES('MD5', ISNULL(SUBSTRING([Id], 1, 255), '') + '|' + 							CAST(ISNULL(CAST([SinkCreatedOn] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL(CAST([SinkModifiedOn] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL([approved], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([billofexchangestatus], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([cancelledpayment], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([cashpayment], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([collectionletter], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([collectionlettercode], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([correct], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([eurotriangulation], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([fixedexchrate], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([interest], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([invoiceproject], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([paymmethod], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([prepayment], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([retailcusttrans], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([settlement], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([transtype], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([custautomationexclude], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([custautomationpredunningsent], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([custautomationpredictionsent], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([invoicetype_it], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([credmanexcludefromcreditcontrol], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([rskfxhedged], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([ecsiscommissioninvoice], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([sysdatastatecode], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([postingprofileclose], 1, 255), '') + '|' + 							CAST(ISNULL([accountingevent], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([accountnum], 1, 255), '') + '|' + 							CAST(ISNULL([amountcur], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([amountmst], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([approver], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([bankcentralbankpurposecode], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([bankcentralbankpurposetext], 1, 255), '') + '|' + 							CAST(ISNULL([banklcexportline], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([bankremittancefileid], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([billofexchangeid], 1, 255), '') + '|' + 							CAST(ISNULL([billofexchangeseqnum], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([cashdisccode], 1, 255), '') + '|' + 							CAST(ISNULL(CAST([cashdiscbasedate] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL(CAST([closed] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							ISNULL(SUBSTRING([companybankaccountid], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([controlnum], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([currencycode], 1, 255), '') + '|' + 							CAST(ISNULL([custbillingclassification], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([custexchadjustmentrealized], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([custexchadjustmentunrealized], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([defaultdimension], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([deliverymode], 1, 255), '') + '|' + 							CAST(ISNULL([directdebitmandate], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL(CAST([documentdate] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							ISNULL(SUBSTRING([documentnum], 1, 255), '') + '|' + 							CAST(ISNULL(CAST([duedate] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL([exchadjustment], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([exchadjustmentreporting], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([exchrate], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([exchratesecond], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([invoice], 1, 255), '') + '|' + 							CAST(ISNULL(CAST([lastexchadj] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL([lastexchadjrate], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([lastexchadjratereporting], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([lastexchadjvoucher], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([lastsettleaccountnum], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([lastsettlecompany], 1, 255), '') + '|' + 							CAST(ISNULL(CAST([lastsettledate] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							ISNULL(SUBSTRING([lastsettlevoucher], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([mcrpaymorderid], 1, 255), '') + '|' + 							CAST(ISNULL([offsetrecid], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([orderaccount], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([paymid], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([paymmode], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([paymreference], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([paymspec], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([postingprofile], 1, 255), '') + '|' + 							CAST(ISNULL([reasonrefrecid], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([reportingcurrencyamount], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([reportingcurrencyexchrate], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([reportingcurrencyexchratesecondary], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([reportingcurrencycrossrate], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([reportingexchadjustmentrealized], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([reportingexchadjustmentunrealized], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([retailstoreid], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([retailterminalid], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([retailtransactionid], 1, 255), '') + '|' + 							CAST(ISNULL([settleamountcur], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([settleamountmst], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([settleamountreporting], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([taxinvoicesalesid], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([thirdpartybankaccountid], 1, 255), '') + '|' + 							CAST(ISNULL(CAST([transdate] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							ISNULL(SUBSTRING([txt], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([voucher], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([paymschedid], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([paymtermid], 1, 255), '') + '|' + 							CAST(ISNULL([settleamount_mx], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([ecsapplicationreference], 1, 255), '') + '|' + 							CAST(ISNULL(CAST([modifieddatetime] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							ISNULL(SUBSTRING([modifiedby], 1, 255), '') + '|' + 							CAST(ISNULL([modifiedtransactionid], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL(CAST([createddatetime] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							ISNULL(SUBSTRING([createdby], 1, 255), '') + '|' + 							CAST(ISNULL([createdtransactionid], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([dataareaid], 1, 255), '') + '|' + 							CAST(ISNULL([recversion], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([partition], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([sysrowversion], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([recid], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([tableid], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([versionnumber], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL(CAST([createdon] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL(CAST([modifiedon] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL([IsDelete], 0) AS NVARCHAR(50)) + '|' + 							ISNULL([PartitionId], '')) AS BINARY(16))
	  FROM [21D365_stg].[custtrans] A; 

							 
	/*
	 ********************************************************************************************************
	 *	If the Destination table has no records update the Staging table Record Source with the value (N)ew.*
	 ********************************************************************************************************
	*/

	IF NOT EXISTS (SELECT count(*) FROM [21D365_ods].[custtrans] HAVING count(*) > 0)
	BEGIN
	    UPDATE [21D365_stg].[custtrans]
		   SET [ODSRecordStatus] = 'N'
		 WHERE [ODSRecordStatus] IS NULL
	END;

	/*
	 ********************************************************************************************************
	 *	If the Destination table is not empty Update the ODSRecordStatus with values (N), (C) or (S).		*
	 ********************************************************************************************************
	*/

	IF EXISTS (SELECT count(*) FROM [21D365_ods].[custtrans] HAVING count(*) > 0)
	BEGIN

		UPDATE A
		   SET A.[ODSRecordStatus] = 'N'
		  FROM [21D365_stg].[custtrans] A LEFT JOIN [21D365_ods].[custtrans] B
		    ON A.[recid] = B.[recid]
		 WHERE B.[recid] IS NULL

		UPDATE A
		   SET A.[ODSRecordStatus] = 'C'
		  FROM [21D365_stg].[custtrans] A INNER JOIN [21D365_ods].[custtrans] B
		    ON A.[recid] = B.[recid]
		   AND A.[ODSHashValue] <> B.[ODSHashValue]

		UPDATE A
		   SET A.[ODSRecordStatus] = 'S'
		  FROM [21D365_stg].[custtrans] A INNER JOIN [21D365_ods].[custtrans] B
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
	  FROM [21D365_ods].[custtrans] A INNER JOIN [21D365_stg].[custtrans] B
	    ON A.[recid] = B.[recid]
	 WHERE B.[ODSRecordStatus] = 'C'
	   AND A.[ODSEndDate] = CONVERT(DATETIME, '31-12-9999', 103)
	   AND A.[ODSActive] = CONVERT(BIT, 1); 
	
	/*
	 ********************************************************************************************************
	 *	Insert New And Changed records in the ODS Table.													*
	 ********************************************************************************************************
	*/

	INSERT INTO [21D365_ods].[custtrans]			(			 [Id],			 [SinkCreatedOn],			 [SinkModifiedOn],			 [approved],			 [billofexchangestatus],			 [cancelledpayment],			 [cashpayment],			 [collectionletter],			 [collectionlettercode],			 [correct],			 [eurotriangulation],			 [fixedexchrate],			 [interest],			 [invoiceproject],			 [paymmethod],			 [prepayment],			 [retailcusttrans],			 [settlement],			 [transtype],			 [custautomationexclude],			 [custautomationpredunningsent],			 [custautomationpredictionsent],			 [invoicetype_it],			 [credmanexcludefromcreditcontrol],			 [rskfxhedged],			 [ecsiscommissioninvoice],			 [sysdatastatecode],			 [postingprofileclose],			 [accountingevent],			 [accountnum],			 [amountcur],			 [amountmst],			 [approver],			 [bankcentralbankpurposecode],			 [bankcentralbankpurposetext],			 [banklcexportline],			 [bankremittancefileid],			 [billofexchangeid],			 [billofexchangeseqnum],			 [cashdisccode],			 [cashdiscbasedate],			 [closed],			 [companybankaccountid],			 [controlnum],			 [currencycode],			 [custbillingclassification],			 [custexchadjustmentrealized],			 [custexchadjustmentunrealized],			 [defaultdimension],			 [deliverymode],			 [directdebitmandate],			 [documentdate],			 [documentnum],			 [duedate],			 [exchadjustment],			 [exchadjustmentreporting],			 [exchrate],			 [exchratesecond],			 [invoice],			 [lastexchadj],			 [lastexchadjrate],			 [lastexchadjratereporting],			 [lastexchadjvoucher],			 [lastsettleaccountnum],			 [lastsettlecompany],			 [lastsettledate],			 [lastsettlevoucher],			 [mcrpaymorderid],			 [offsetrecid],			 [orderaccount],			 [paymid],			 [paymmode],			 [paymreference],			 [paymspec],			 [postingprofile],			 [reasonrefrecid],			 [reportingcurrencyamount],			 [reportingcurrencyexchrate],			 [reportingcurrencyexchratesecondary],			 [reportingcurrencycrossrate],			 [reportingexchadjustmentrealized],			 [reportingexchadjustmentunrealized],			 [retailstoreid],			 [retailterminalid],			 [retailtransactionid],			 [settleamountcur],			 [settleamountmst],			 [settleamountreporting],			 [taxinvoicesalesid],			 [thirdpartybankaccountid],			 [transdate],			 [txt],			 [voucher],			 [paymschedid],			 [paymtermid],			 [settleamount_mx],			 [ecsapplicationreference],			 [modifieddatetime],			 [modifiedby],			 [modifiedtransactionid],			 [createddatetime],			 [createdby],			 [createdtransactionid],			 [dataareaid],			 [recversion],			 [partition],			 [sysrowversion],			 [recid],			 [tableid],			 [versionnumber],			 [createdon],			 [modifiedon],			 [IsDelete],			 [PartitionId],			 [ODSStartDate],			 [ODSEndDate],			 [ODSActive],			 [ODSHashValue]			) 	  SELECT [Id],			 [SinkCreatedOn],			 [SinkModifiedOn],			 [approved],			 [billofexchangestatus],			 [cancelledpayment],			 [cashpayment],			 [collectionletter],			 [collectionlettercode],			 [correct],			 [eurotriangulation],			 [fixedexchrate],			 [interest],			 [invoiceproject],			 [paymmethod],			 [prepayment],			 [retailcusttrans],			 [settlement],			 [transtype],			 [custautomationexclude],			 [custautomationpredunningsent],			 [custautomationpredictionsent],			 [invoicetype_it],			 [credmanexcludefromcreditcontrol],			 [rskfxhedged],			 [ecsiscommissioninvoice],			 [sysdatastatecode],			 [postingprofileclose],			 [accountingevent],			 [accountnum],			 [amountcur],			 [amountmst],			 [approver],			 [bankcentralbankpurposecode],			 [bankcentralbankpurposetext],			 [banklcexportline],			 [bankremittancefileid],			 [billofexchangeid],			 [billofexchangeseqnum],			 [cashdisccode],			 [cashdiscbasedate],			 [closed],			 [companybankaccountid],			 [controlnum],			 [currencycode],			 [custbillingclassification],			 [custexchadjustmentrealized],			 [custexchadjustmentunrealized],			 [defaultdimension],			 [deliverymode],			 [directdebitmandate],			 [documentdate],			 [documentnum],			 [duedate],			 [exchadjustment],			 [exchadjustmentreporting],			 [exchrate],			 [exchratesecond],			 [invoice],			 [lastexchadj],			 [lastexchadjrate],			 [lastexchadjratereporting],			 [lastexchadjvoucher],			 [lastsettleaccountnum],			 [lastsettlecompany],			 [lastsettledate],			 [lastsettlevoucher],			 [mcrpaymorderid],			 [offsetrecid],			 [orderaccount],			 [paymid],			 [paymmode],			 [paymreference],			 [paymspec],			 [postingprofile],			 [reasonrefrecid],			 [reportingcurrencyamount],			 [reportingcurrencyexchrate],			 [reportingcurrencyexchratesecondary],			 [reportingcurrencycrossrate],			 [reportingexchadjustmentrealized],			 [reportingexchadjustmentunrealized],			 [retailstoreid],			 [retailterminalid],			 [retailtransactionid],			 [settleamountcur],			 [settleamountmst],			 [settleamountreporting],			 [taxinvoicesalesid],			 [thirdpartybankaccountid],			 [transdate],			 [txt],			 [voucher],			 [paymschedid],			 [paymtermid],			 [settleamount_mx],			 [ecsapplicationreference],			 [modifieddatetime],			 [modifiedby],			 [modifiedtransactionid],			 [createddatetime],			 [createdby],			 [createdtransactionid],			 [dataareaid],			 [recversion],			 [partition],			 [sysrowversion],			 [recid],			 [tableid],			 [versionnumber],			 [createdon],			 [modifiedon],			 [IsDelete],			 [PartitionId],			 GETUTCDATE(),			 CONVERT(DATETIME, '31-12-9999', 103),			 CONVERT(BIT, 1),			 [ODSHashValue] 		FROM [21D365_stg].[custtrans] WHERE [ODSRecordStatus] IN ('C', 'N');					   
				
/*
 ************************************************************************************************************
 *	End of creating the stored procedure.																	*
 ************************************************************************************************************
*/

END

GO

