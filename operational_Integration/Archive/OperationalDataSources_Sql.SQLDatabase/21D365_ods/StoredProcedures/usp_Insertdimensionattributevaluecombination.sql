
/*
 ************************************************************************************************************
 *	Create Stored Procedure.																				*
 ************************************************************************************************************
*/

CREATE PROCEDURE [21D365_ods].[usp_Insertdimensionattributevaluecombination]

AS

BEGIN

	/*
	 ********************************************************************************************************
	 *	Update the ODSHashValue Field in the Staging table with the Hash value of the record.				*
	 ********************************************************************************************************
	*/

	UPDATE A
	   SET [ODSHashValue] = CAST(HASHBYTES('MD5', ISNULL(SUBSTRING([Id], 1, 255), '') + '|' + 							CAST(ISNULL(CAST([SinkCreatedOn] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL(CAST([SinkModifiedOn] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL([ledgerdimensiontype], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([hashversion], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([systemgeneratedjournalaccounttype], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([sysdatastatecode], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([accountstructure], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([displayvalue], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([dataareaforcreation], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([implieddataareaid], 1, 255), '') + '|' + 							CAST(ISNULL([systemgeneratedjournalaccount], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([systemgeneratedjournalaccountvalue], 1, 255), '') + '|' + 							CAST(ISNULL([mainaccount], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([mainaccountvalue], 1, 255), '') + '|' + 							CAST(ISNULL([systemgeneratedattributebankaccount], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([systemgeneratedattributebankaccountvalue], 1, 255), '') + '|' + 							CAST(ISNULL([systemgeneratedattributecustomer], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([systemgeneratedattributecustomervalue], 1, 255), '') + '|' + 							CAST(ISNULL([systemgeneratedattributeemployee], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([systemgeneratedattributeemployeevalue], 1, 255), '') + '|' + 							CAST(ISNULL([systemgeneratedattributefixedasset], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([systemgeneratedattributefixedassetvalue], 1, 255), '') + '|' + 							CAST(ISNULL([systemgeneratedattributeitem], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([systemgeneratedattributeitemvalue], 1, 255), '') + '|' + 							CAST(ISNULL([systemgeneratedattributeproject], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([systemgeneratedattributeprojectvalue], 1, 255), '') + '|' + 							CAST(ISNULL([systemgeneratedattributevendor], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([systemgeneratedattributevendorvalue], 1, 255), '') + '|' + 							CAST(ISNULL([systemgeneratedattributefixedassets_ru], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([systemgeneratedattributefixedassets_ruvalue], 1, 255), '') + '|' + 							CAST(ISNULL([systemgeneratedattributerdeferrals], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([systemgeneratedattributerdeferralsvalue], 1, 255), '') + '|' + 							CAST(ISNULL([systemgeneratedattributercash], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([systemgeneratedattributercashvalue], 1, 255), '') + '|' + 							CAST(ISNULL([systemgeneratedattributeemployee_ru], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([systemgeneratedattributeemployee_ruvalue], 1, 255), '') + '|' + 							CAST(ISNULL([order_], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([order_value], 1, 255), '') + '|' + 							CAST(ISNULL([reg2], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([reg2value], 1, 255), '') + '|' + 							CAST(ISNULL([employ], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([employvalue], 1, 255), '') + '|' + 							CAST(ISNULL([procen], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([procenvalue], 1, 255), '') + '|' + 							CAST(ISNULL([coscen], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([coscenvalue], 1, 255), '') + '|' + 							CAST(ISNULL([countryofdestination], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([countryofdestinationvalue], 1, 255), '') + '|' + 							CAST(ISNULL([location], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([locationvalue], 1, 255), '') + '|' + 							CAST(ISNULL([logisticsfile], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([logisticsfilevalue], 1, 255), '') + '|' + 							CAST(ISNULL(CAST([modifieddatetime] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							ISNULL(SUBSTRING([modifiedby], 1, 255), '') + '|' + 							CAST(ISNULL([modifiedtransactionid], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL(CAST([createddatetime] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							ISNULL(SUBSTRING([createdby], 1, 255), '') + '|' + 							CAST(ISNULL([createdtransactionid], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([dataareaid], 1, 255), '') + '|' + 							CAST(ISNULL([recversion], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([partition], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([sysrowversion], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([recid], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([tableid], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([versionnumber], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL(CAST([createdon] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL(CAST([modifiedon] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL([IsDelete], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([PartitionId], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([Ingestion_Timestamp], 1, 255), '')) AS BINARY(16))
	  FROM [21D365_stg].[dimensionattributevaluecombination] A; 

							 
	/*
	 ********************************************************************************************************
	 *	If the Destination table has no records update the Staging table Record Source with the value (N)ew.*
	 ********************************************************************************************************
	*/

	IF NOT EXISTS (SELECT count(*) FROM [21D365_ods].[dimensionattributevaluecombination] HAVING count(*) > 0)
	BEGIN
	    UPDATE [21D365_stg].[dimensionattributevaluecombination]
		   SET [ODSRecordStatus] = 'N'
		 WHERE [ODSRecordStatus] IS NULL
	END;

	/*
	 ********************************************************************************************************
	 *	If the Destination table is not empty Update the ODSRecordStatus with values (N), (C) or (S).		*
	 ********************************************************************************************************
	*/

	IF EXISTS (SELECT count(*) FROM [21D365_ods].[dimensionattributevaluecombination] HAVING count(*) > 0)
	BEGIN

		UPDATE A
		   SET A.[ODSRecordStatus] = 'N'
		  FROM [21D365_stg].[dimensionattributevaluecombination] A LEFT JOIN [21D365_ods].[dimensionattributevaluecombination] B
		    ON A.[recid] = B.[recid]
		 WHERE B.[recid] IS NULL

		UPDATE A
		   SET A.[ODSRecordStatus] = 'C'
		  FROM [21D365_stg].[dimensionattributevaluecombination] A INNER JOIN [21D365_ods].[dimensionattributevaluecombination] B
		    ON A.[recid] = B.[recid]
		   AND A.[ODSHashValue] <> B.[ODSHashValue]

		UPDATE A
		   SET A.[ODSRecordStatus] = 'S'
		  FROM [21D365_stg].[dimensionattributevaluecombination] A INNER JOIN [21D365_ods].[dimensionattributevaluecombination] B
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
	  FROM [21D365_ods].[dimensionattributevaluecombination] A INNER JOIN [21D365_stg].[dimensionattributevaluecombination] B
	    ON A.[recid] = B.[recid]
	 WHERE B.[ODSRecordStatus] = 'C'
	   AND A.[ODSEndDate] = CONVERT(DATETIME, '31-12-9999', 103)
	   AND A.[ODSActive] = CONVERT(BIT, 1); 
	
	/*
	 ********************************************************************************************************
	 *	Insert New And Changed records in the ODS Table.													*
	 ********************************************************************************************************
	*/

	INSERT INTO [21D365_ods].[dimensionattributevaluecombination]			(			 [Id],			 [SinkCreatedOn],			 [SinkModifiedOn],			 [ledgerdimensiontype],			 [hashversion],			 [systemgeneratedjournalaccounttype],			 [sysdatastatecode],			 [accountstructure],			 [displayvalue],			 [dataareaforcreation],			 [implieddataareaid],			 [systemgeneratedjournalaccount],			 [systemgeneratedjournalaccountvalue],			 [mainaccount],			 [mainaccountvalue],			 [systemgeneratedattributebankaccount],			 [systemgeneratedattributebankaccountvalue],			 [systemgeneratedattributecustomer],			 [systemgeneratedattributecustomervalue],			 [systemgeneratedattributeemployee],			 [systemgeneratedattributeemployeevalue],			 [systemgeneratedattributefixedasset],			 [systemgeneratedattributefixedassetvalue],			 [systemgeneratedattributeitem],			 [systemgeneratedattributeitemvalue],			 [systemgeneratedattributeproject],			 [systemgeneratedattributeprojectvalue],			 [systemgeneratedattributevendor],			 [systemgeneratedattributevendorvalue],			 [systemgeneratedattributefixedassets_ru],			 [systemgeneratedattributefixedassets_ruvalue],			 [systemgeneratedattributerdeferrals],			 [systemgeneratedattributerdeferralsvalue],			 [systemgeneratedattributercash],			 [systemgeneratedattributercashvalue],			 [systemgeneratedattributeemployee_ru],			 [systemgeneratedattributeemployee_ruvalue],			 [order_],			 [order_value],			 [reg2],			 [reg2value],			 [employ],			 [employvalue],			 [procen],			 [procenvalue],			 [coscen],			 [coscenvalue],			 [countryofdestination],			 [countryofdestinationvalue],			 [location],			 [locationvalue],			 [logisticsfile],			 [logisticsfilevalue],			 [modifieddatetime],			 [modifiedby],			 [modifiedtransactionid],			 [createddatetime],			 [createdby],			 [createdtransactionid],			 [dataareaid],			 [recversion],			 [partition],			 [sysrowversion],			 [recid],			 [tableid],			 [versionnumber],			 [createdon],			 [modifiedon],			 [IsDelete],			 [PartitionId],			 [Ingestion_Timestamp],			 [ODSStartDate],			 [ODSEndDate],			 [ODSActive],			 [ODSHashValue]			) 	  SELECT [Id],			 [SinkCreatedOn],			 [SinkModifiedOn],			 [ledgerdimensiontype],			 [hashversion],			 [systemgeneratedjournalaccounttype],			 [sysdatastatecode],			 [accountstructure],			 [displayvalue],			 [dataareaforcreation],			 [implieddataareaid],			 [systemgeneratedjournalaccount],			 [systemgeneratedjournalaccountvalue],			 [mainaccount],			 [mainaccountvalue],			 [systemgeneratedattributebankaccount],			 [systemgeneratedattributebankaccountvalue],			 [systemgeneratedattributecustomer],			 [systemgeneratedattributecustomervalue],			 [systemgeneratedattributeemployee],			 [systemgeneratedattributeemployeevalue],			 [systemgeneratedattributefixedasset],			 [systemgeneratedattributefixedassetvalue],			 [systemgeneratedattributeitem],			 [systemgeneratedattributeitemvalue],			 [systemgeneratedattributeproject],			 [systemgeneratedattributeprojectvalue],			 [systemgeneratedattributevendor],			 [systemgeneratedattributevendorvalue],			 [systemgeneratedattributefixedassets_ru],			 [systemgeneratedattributefixedassets_ruvalue],			 [systemgeneratedattributerdeferrals],			 [systemgeneratedattributerdeferralsvalue],			 [systemgeneratedattributercash],			 [systemgeneratedattributercashvalue],			 [systemgeneratedattributeemployee_ru],			 [systemgeneratedattributeemployee_ruvalue],			 [order_],			 [order_value],			 [reg2],			 [reg2value],			 [employ],			 [employvalue],			 [procen],			 [procenvalue],			 [coscen],			 [coscenvalue],			 [countryofdestination],			 [countryofdestinationvalue],			 [location],			 [locationvalue],			 [logisticsfile],			 [logisticsfilevalue],			 [modifieddatetime],			 [modifiedby],			 [modifiedtransactionid],			 [createddatetime],			 [createdby],			 [createdtransactionid],			 [dataareaid],			 [recversion],			 [partition],			 [sysrowversion],			 [recid],			 [tableid],			 [versionnumber],			 [createdon],			 [modifiedon],			 [IsDelete],			 [PartitionId],			 [Ingestion_Timestamp],			 GETUTCDATE(),			 CONVERT(DATETIME, '31-12-9999', 103),			 CONVERT(BIT, 1),			 [ODSHashValue] 		FROM [21D365_stg].[dimensionattributevaluecombination] WHERE [ODSRecordStatus] IN ('C', 'N');					   
				
/*
 ************************************************************************************************************
 *	End of creating the stored procedure.																	*
 ************************************************************************************************************
*/

END

GO

