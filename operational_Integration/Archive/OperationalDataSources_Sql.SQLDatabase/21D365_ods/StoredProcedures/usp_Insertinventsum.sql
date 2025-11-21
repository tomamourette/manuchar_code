
/*
 ************************************************************************************************************
 *	Create Stored Procedure.																				*
 ************************************************************************************************************
*/

CREATE PROCEDURE [21D365_ods].[usp_Insertinventsum]

AS

BEGIN

	/*
	 ********************************************************************************************************
	 *	Update the ODSHashValue Field in the Staging table with the Hash value of the record.				*
	 ********************************************************************************************************
	*/

	UPDATE A
	   SET [ODSHashValue] = CAST(HASHBYTES('MD5', ISNULL(SUBSTRING([Id], 1, 255), '') + '|' + 							CAST(ISNULL(CAST([SinkCreatedOn] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL(CAST([SinkModifiedOn] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL([closed], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([closedqty], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([isexcludedfrominventoryvalue], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([sysdatastatecode], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([arrived], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([availordered], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([availphysical], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([deducted], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([inventdimid], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([itemid], 1, 255), '') + '|' + 							CAST(ISNULL(CAST([lastupddateexpected] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL(CAST([lastupddatephysical] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL([onorder], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([ordered], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([pdscwarrived], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([pdscwavailordered], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([pdscwavailphysical], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([pdscwdeducted], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([pdscwonorder], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([pdscwordered], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([pdscwphysicalinvent], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([pdscwpicked], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([pdscwpostedqty], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([pdscwquotationissue], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([pdscwquotationreceipt], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([pdscwreceived], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([pdscwregistered], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([pdscwreservordered], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([pdscwreservphysical], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([physicalinvent], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([physicalvalue], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([physicalvalueseccur_ru], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([picked], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([postedqty], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([postedvalue], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([postedvalueseccur_ru], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([quotationissue], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([quotationreceipt], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([received], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([registered], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([reservordered], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([reservphysical], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([configid], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([inventbatchid], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([inventcolorid], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([inventgtdid_ru], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([inventlocationid], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([inventownerid_ru], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([inventprofileid_ru], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([inventserialid], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([inventsiteid], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([inventsizeid], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([inventstatusid], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([inventstyleid], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([inventversionid], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([licenseplateid], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([wmslocationid], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([wmspalletid], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([inventdimension1], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([inventdimension2], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([inventdimension3], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([inventdimension4], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([inventdimension5], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([inventdimension6], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([inventdimension7], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([inventdimension8], 1, 255), '') + '|' + 							CAST(ISNULL(CAST([inventdimension9] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL([inventdimension10], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([inventdimension11], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([inventdimension12], 1, 255), '') + '|' + 							CAST(ISNULL(CAST([modifieddatetime] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							ISNULL(SUBSTRING([modifiedby], 1, 255), '') + '|' + 							CAST(ISNULL([modifiedtransactionid], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL(CAST([createddatetime] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							ISNULL(SUBSTRING([createdby], 1, 255), '') + '|' + 							CAST(ISNULL([createdtransactionid], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([dataareaid], 1, 255), '') + '|' + 							CAST(ISNULL([recversion], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([partition], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([sysrowversion], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([recid], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([tableid], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([versionnumber], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL(CAST([createdon] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL(CAST([modifiedon] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL([IsDelete], 0) AS NVARCHAR(50)) + '|' + 							ISNULL([PartitionId], '')) AS BINARY(16))
	  FROM [21D365_stg].[inventsum] A; 

							 
	/*
	 ********************************************************************************************************
	 *	If the Destination table has no records update the Staging table Record Source with the value (N)ew.*
	 ********************************************************************************************************
	*/

	IF NOT EXISTS (SELECT count(*) FROM [21D365_ods].[inventsum] HAVING count(*) > 0)
	BEGIN
	    UPDATE [21D365_stg].[inventsum]
		   SET [ODSRecordStatus] = 'N'
		 WHERE [ODSRecordStatus] IS NULL
	END;

	/*
	 ********************************************************************************************************
	 *	If the Destination table is not empty Update the ODSRecordStatus with values (N), (C) or (S).		*
	 ********************************************************************************************************
	*/

	IF EXISTS (SELECT count(*) FROM [21D365_ods].[inventsum] HAVING count(*) > 0)
	BEGIN

		UPDATE A
		   SET A.[ODSRecordStatus] = 'N'
		  FROM [21D365_stg].[inventsum] A LEFT JOIN [21D365_ods].[inventsum] B
		    ON A.[recid] = B.[recid]
		 WHERE B.[recid] IS NULL

		UPDATE A
		   SET A.[ODSRecordStatus] = 'C'
		  FROM [21D365_stg].[inventsum] A INNER JOIN [21D365_ods].[inventsum] B
		    ON A.[recid] = B.[recid]
		   AND A.[ODSHashValue] <> B.[ODSHashValue]

		UPDATE A
		   SET A.[ODSRecordStatus] = 'S'
		  FROM [21D365_stg].[inventsum] A INNER JOIN [21D365_ods].[inventsum] B
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
	  FROM [21D365_ods].[inventsum] A INNER JOIN [21D365_stg].[inventsum] B
	    ON A.[recid] = B.[recid]
	 WHERE B.[ODSRecordStatus] = 'C'
	   AND A.[ODSEndDate] = CONVERT(DATETIME, '31-12-9999', 103)
	   AND A.[ODSActive] = CONVERT(BIT, 1); 
	
	/*
	 ********************************************************************************************************
	 *	Insert New And Changed records in the ODS Table.													*
	 ********************************************************************************************************
	*/

	INSERT INTO [21D365_ods].[inventsum]			(			 [Id],			 [SinkCreatedOn],			 [SinkModifiedOn],			 [closed],			 [closedqty],			 [isexcludedfrominventoryvalue],			 [sysdatastatecode],			 [arrived],			 [availordered],			 [availphysical],			 [deducted],			 [inventdimid],			 [itemid],			 [lastupddateexpected],			 [lastupddatephysical],			 [onorder],			 [ordered],			 [pdscwarrived],			 [pdscwavailordered],			 [pdscwavailphysical],			 [pdscwdeducted],			 [pdscwonorder],			 [pdscwordered],			 [pdscwphysicalinvent],			 [pdscwpicked],			 [pdscwpostedqty],			 [pdscwquotationissue],			 [pdscwquotationreceipt],			 [pdscwreceived],			 [pdscwregistered],			 [pdscwreservordered],			 [pdscwreservphysical],			 [physicalinvent],			 [physicalvalue],			 [physicalvalueseccur_ru],			 [picked],			 [postedqty],			 [postedvalue],			 [postedvalueseccur_ru],			 [quotationissue],			 [quotationreceipt],			 [received],			 [registered],			 [reservordered],			 [reservphysical],			 [configid],			 [inventbatchid],			 [inventcolorid],			 [inventgtdid_ru],			 [inventlocationid],			 [inventownerid_ru],			 [inventprofileid_ru],			 [inventserialid],			 [inventsiteid],			 [inventsizeid],			 [inventstatusid],			 [inventstyleid],			 [inventversionid],			 [licenseplateid],			 [wmslocationid],			 [wmspalletid],			 [inventdimension1],			 [inventdimension2],			 [inventdimension3],			 [inventdimension4],			 [inventdimension5],			 [inventdimension6],			 [inventdimension7],			 [inventdimension8],			 [inventdimension9],			 [inventdimension10],			 [inventdimension11],			 [inventdimension12],			 [modifieddatetime],			 [modifiedby],			 [modifiedtransactionid],			 [createddatetime],			 [createdby],			 [createdtransactionid],			 [dataareaid],			 [recversion],			 [partition],			 [sysrowversion],			 [recid],			 [tableid],			 [versionnumber],			 [createdon],			 [modifiedon],			 [IsDelete],			 [PartitionId],			 [ODSStartDate],			 [ODSEndDate],			 [ODSActive],			 [ODSHashValue]			) 	  SELECT [Id],			 [SinkCreatedOn],			 [SinkModifiedOn],			 [closed],			 [closedqty],			 [isexcludedfrominventoryvalue],			 [sysdatastatecode],			 [arrived],			 [availordered],			 [availphysical],			 [deducted],			 [inventdimid],			 [itemid],			 [lastupddateexpected],			 [lastupddatephysical],			 [onorder],			 [ordered],			 [pdscwarrived],			 [pdscwavailordered],			 [pdscwavailphysical],			 [pdscwdeducted],			 [pdscwonorder],			 [pdscwordered],			 [pdscwphysicalinvent],			 [pdscwpicked],			 [pdscwpostedqty],			 [pdscwquotationissue],			 [pdscwquotationreceipt],			 [pdscwreceived],			 [pdscwregistered],			 [pdscwreservordered],			 [pdscwreservphysical],			 [physicalinvent],			 [physicalvalue],			 [physicalvalueseccur_ru],			 [picked],			 [postedqty],			 [postedvalue],			 [postedvalueseccur_ru],			 [quotationissue],			 [quotationreceipt],			 [received],			 [registered],			 [reservordered],			 [reservphysical],			 [configid],			 [inventbatchid],			 [inventcolorid],			 [inventgtdid_ru],			 [inventlocationid],			 [inventownerid_ru],			 [inventprofileid_ru],			 [inventserialid],			 [inventsiteid],			 [inventsizeid],			 [inventstatusid],			 [inventstyleid],			 [inventversionid],			 [licenseplateid],			 [wmslocationid],			 [wmspalletid],			 [inventdimension1],			 [inventdimension2],			 [inventdimension3],			 [inventdimension4],			 [inventdimension5],			 [inventdimension6],			 [inventdimension7],			 [inventdimension8],			 [inventdimension9],			 [inventdimension10],			 [inventdimension11],			 [inventdimension12],			 [modifieddatetime],			 [modifiedby],			 [modifiedtransactionid],			 [createddatetime],			 [createdby],			 [createdtransactionid],			 [dataareaid],			 [recversion],			 [partition],			 [sysrowversion],			 [recid],			 [tableid],			 [versionnumber],			 [createdon],			 [modifiedon],			 [IsDelete],			 [PartitionId],			 GETUTCDATE(),			 CONVERT(DATETIME, '31-12-9999', 103),			 CONVERT(BIT, 1),			 [ODSHashValue] 		FROM [21D365_stg].[inventsum] WHERE [ODSRecordStatus] IN ('C', 'N');					   
				
/*
 ************************************************************************************************************
 *	End of creating the stored procedure.																	*
 ************************************************************************************************************
*/

END

GO

