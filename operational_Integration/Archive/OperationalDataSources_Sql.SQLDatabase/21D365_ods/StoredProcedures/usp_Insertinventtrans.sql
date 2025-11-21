
/*
 ************************************************************************************************************
 *	Create Stored Procedure.																				*
 ************************************************************************************************************
*/

CREATE PROCEDURE [21D365_ods].[usp_Insertinventtrans]

AS

BEGIN

	/*
	 ********************************************************************************************************
	 *	Update the ODSHashValue Field in the Staging table with the Hash value of the record.				*
	 ********************************************************************************************************
	*/

	UPDATE A
	   SET [ODSHashValue] = CAST(HASHBYTES('MD5', ISNULL(SUBSTRING([Id], 1, 255), '') + '|' + 							CAST(ISNULL(CAST([SinkCreatedOn] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL(CAST([SinkModifiedOn] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL([groupreftype_ru], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([intercompanyinventdimtransferred], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([invoicereturned], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([packingslipreturned], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([statusissue], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([statusreceipt], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([storno_ru], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([stornophysical_ru], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([transchildtype], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([valueopen], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([valueopenseccur_ru], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([itmskipvarianceupdate], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([itmmustskipadjustment], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([sysdatastatecode], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([activitynumber], 1, 255), '') + '|' + 							CAST(ISNULL([costamountadjustment], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([costamountoperations], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([costamountphysical], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([costamountposted], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([costamountseccuradjustment_ru], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([costamountseccurphysical_ru], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([costamountseccurposted_ru], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([costamountsettled], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([costamountsettledseccur_ru], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([costamountstd], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([costamountstdseccur_ru], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([currencycode], 1, 255), '') + '|' + 							CAST(ISNULL(CAST([dateclosed] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL(CAST([dateclosedseccur_ru] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL(CAST([dateexpected] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL(CAST([datefinancial] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL(CAST([dateinvent] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL(CAST([datephysical] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL(CAST([datestatus] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							ISNULL(SUBSTRING([grouprefid_ru], 1, 255), '') + '|' + 							CAST(ISNULL([inventdimfixed], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([inventdimid], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([inventdimidsales_ru], 1, 255), '') + '|' + 							CAST(ISNULL([inventtransorigin], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([inventtransorigindelivery_ru], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([inventtransoriginsales_ru], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([inventtransorigintransit_ru], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([invoiceid], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([itemid], 1, 255), '') + '|' + 							CAST(ISNULL([markingrefinventtransorigin], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([packingslipid], 1, 255), '') + '|' + 							CAST(ISNULL([pdscwqty], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([pdscwsettled], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([pickingrouteid], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([projadjustrefid], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([projcategoryid], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([projid], 1, 255), '') + '|' + 							CAST(ISNULL([qty], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([qtysettled], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([qtysettledseccur_ru], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([returninventtransorigin], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([revenueamountphysical], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL(CAST([shippingdateconfirmed] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL(CAST([shippingdaterequested] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL([taxamountphysical], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([timeexpected], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([transchildrefid], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([voucher], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([voucherphysical], 1, 255), '') + '|' + 							CAST(ISNULL([nonfinancialtransferinventclosing], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([loadid], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([receiptid], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([itmcosttypeid], 1, 255), '') + '|' + 							CAST(ISNULL([itmcosttransrecid], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([ecsreturninvoiceid], 1, 255), '') + '|' + 							CAST(ISNULL(CAST([modifieddatetime] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							ISNULL(SUBSTRING([modifiedby], 1, 255), '') + '|' + 							CAST(ISNULL([modifiedtransactionid], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL(CAST([createddatetime] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							ISNULL(SUBSTRING([createdby], 1, 255), '') + '|' + 							CAST(ISNULL([createdtransactionid], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([dataareaid], 1, 255), '') + '|' + 							CAST(ISNULL([recversion], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([partition], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([sysrowversion], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([recid], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([tableid], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([versionnumber], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL(CAST([createdon] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL(CAST([modifiedon] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL([IsDelete], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([PartitionId], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([Ingestion_Timestamp], 1, 255), '')) AS BINARY(16))
	  FROM [21D365_stg].[inventtrans] A; 

							 
	/*
	 ********************************************************************************************************
	 *	If the Destination table has no records update the Staging table Record Source with the value (N)ew.*
	 ********************************************************************************************************
	*/

	IF NOT EXISTS (SELECT count(*) FROM [21D365_ods].[inventtrans] HAVING count(*) > 0)
	BEGIN
	    UPDATE [21D365_stg].[inventtrans]
		   SET [ODSRecordStatus] = 'N'
		 WHERE [ODSRecordStatus] IS NULL
	END;

	/*
	 ********************************************************************************************************
	 *	If the Destination table is not empty Update the ODSRecordStatus with values (N), (C) or (S).		*
	 ********************************************************************************************************
	*/

	IF EXISTS (SELECT count(*) FROM [21D365_ods].[inventtrans] HAVING count(*) > 0)
	BEGIN

		UPDATE A
		   SET A.[ODSRecordStatus] = 'N'
		  FROM [21D365_stg].[inventtrans] A LEFT JOIN [21D365_ods].[inventtrans] B
		    ON A.[recid] = B.[recid]
		 WHERE B.[recid] IS NULL

		UPDATE A
		   SET A.[ODSRecordStatus] = 'C'
		  FROM [21D365_stg].[inventtrans] A INNER JOIN [21D365_ods].[inventtrans] B
		    ON A.[recid] = B.[recid]
		   AND A.[ODSHashValue] <> B.[ODSHashValue]

		UPDATE A
		   SET A.[ODSRecordStatus] = 'S'
		  FROM [21D365_stg].[inventtrans] A INNER JOIN [21D365_ods].[inventtrans] B
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
	  FROM [21D365_ods].[inventtrans] A INNER JOIN [21D365_stg].[inventtrans] B
	    ON A.[recid] = B.[recid]
	 WHERE B.[ODSRecordStatus] = 'C'
	   AND A.[ODSEndDate] = CONVERT(DATETIME, '31-12-9999', 103)
	   AND A.[ODSActive] = CONVERT(BIT, 1); 
	
	/*
	 ********************************************************************************************************
	 *	Insert New And Changed records in the ODS Table.													*
	 ********************************************************************************************************
	*/

	INSERT INTO [21D365_ods].[inventtrans]			(			 [Id],			 [SinkCreatedOn],			 [SinkModifiedOn],			 [groupreftype_ru],			 [intercompanyinventdimtransferred],			 [invoicereturned],			 [packingslipreturned],			 [statusissue],			 [statusreceipt],			 [storno_ru],			 [stornophysical_ru],			 [transchildtype],			 [valueopen],			 [valueopenseccur_ru],			 [itmskipvarianceupdate],			 [itmmustskipadjustment],			 [sysdatastatecode],			 [activitynumber],			 [costamountadjustment],			 [costamountoperations],			 [costamountphysical],			 [costamountposted],			 [costamountseccuradjustment_ru],			 [costamountseccurphysical_ru],			 [costamountseccurposted_ru],			 [costamountsettled],			 [costamountsettledseccur_ru],			 [costamountstd],			 [costamountstdseccur_ru],			 [currencycode],			 [dateclosed],			 [dateclosedseccur_ru],			 [dateexpected],			 [datefinancial],			 [dateinvent],			 [datephysical],			 [datestatus],			 [grouprefid_ru],			 [inventdimfixed],			 [inventdimid],			 [inventdimidsales_ru],			 [inventtransorigin],			 [inventtransorigindelivery_ru],			 [inventtransoriginsales_ru],			 [inventtransorigintransit_ru],			 [invoiceid],			 [itemid],			 [markingrefinventtransorigin],			 [packingslipid],			 [pdscwqty],			 [pdscwsettled],			 [pickingrouteid],			 [projadjustrefid],			 [projcategoryid],			 [projid],			 [qty],			 [qtysettled],			 [qtysettledseccur_ru],			 [returninventtransorigin],			 [revenueamountphysical],			 [shippingdateconfirmed],			 [shippingdaterequested],			 [taxamountphysical],			 [timeexpected],			 [transchildrefid],			 [voucher],			 [voucherphysical],			 [nonfinancialtransferinventclosing],			 [loadid],			 [receiptid],			 [itmcosttypeid],			 [itmcosttransrecid],			 [ecsreturninvoiceid],			 [modifieddatetime],			 [modifiedby],			 [modifiedtransactionid],			 [createddatetime],			 [createdby],			 [createdtransactionid],			 [dataareaid],			 [recversion],			 [partition],			 [sysrowversion],			 [recid],			 [tableid],			 [versionnumber],			 [createdon],			 [modifiedon],			 [IsDelete],			 [PartitionId],			 [Ingestion_Timestamp],			 [ODSStartDate],			 [ODSEndDate],			 [ODSActive],			 [ODSHashValue]			) 	  SELECT [Id],			 [SinkCreatedOn],			 [SinkModifiedOn],			 [groupreftype_ru],			 [intercompanyinventdimtransferred],			 [invoicereturned],			 [packingslipreturned],			 [statusissue],			 [statusreceipt],			 [storno_ru],			 [stornophysical_ru],			 [transchildtype],			 [valueopen],			 [valueopenseccur_ru],			 [itmskipvarianceupdate],			 [itmmustskipadjustment],			 [sysdatastatecode],			 [activitynumber],			 [costamountadjustment],			 [costamountoperations],			 [costamountphysical],			 [costamountposted],			 [costamountseccuradjustment_ru],			 [costamountseccurphysical_ru],			 [costamountseccurposted_ru],			 [costamountsettled],			 [costamountsettledseccur_ru],			 [costamountstd],			 [costamountstdseccur_ru],			 [currencycode],			 [dateclosed],			 [dateclosedseccur_ru],			 [dateexpected],			 [datefinancial],			 [dateinvent],			 [datephysical],			 [datestatus],			 [grouprefid_ru],			 [inventdimfixed],			 [inventdimid],			 [inventdimidsales_ru],			 [inventtransorigin],			 [inventtransorigindelivery_ru],			 [inventtransoriginsales_ru],			 [inventtransorigintransit_ru],			 [invoiceid],			 [itemid],			 [markingrefinventtransorigin],			 [packingslipid],			 [pdscwqty],			 [pdscwsettled],			 [pickingrouteid],			 [projadjustrefid],			 [projcategoryid],			 [projid],			 [qty],			 [qtysettled],			 [qtysettledseccur_ru],			 [returninventtransorigin],			 [revenueamountphysical],			 [shippingdateconfirmed],			 [shippingdaterequested],			 [taxamountphysical],			 [timeexpected],			 [transchildrefid],			 [voucher],			 [voucherphysical],			 [nonfinancialtransferinventclosing],			 [loadid],			 [receiptid],			 [itmcosttypeid],			 [itmcosttransrecid],			 [ecsreturninvoiceid],			 [modifieddatetime],			 [modifiedby],			 [modifiedtransactionid],			 [createddatetime],			 [createdby],			 [createdtransactionid],			 [dataareaid],			 [recversion],			 [partition],			 [sysrowversion],			 [recid],			 [tableid],			 [versionnumber],			 [createdon],			 [modifiedon],			 [IsDelete],			 [PartitionId],			 [Ingestion_Timestamp],			 GETUTCDATE(),			 CONVERT(DATETIME, '31-12-9999', 103),			 CONVERT(BIT, 1),			 [ODSHashValue] 		FROM [21D365_stg].[inventtrans] WHERE [ODSRecordStatus] IN ('C', 'N');					   
				
/*
 ************************************************************************************************************
 *	End of creating the stored procedure.																	*
 ************************************************************************************************************
*/

END

GO

