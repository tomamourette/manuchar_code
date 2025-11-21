
/*
 ************************************************************************************************************
 *	Create Stored Procedure.																				*
 ************************************************************************************************************
*/

CREATE PROCEDURE [21D365_ods].[usp_Insertlogisticspostaladdress]

AS

BEGIN

	/*
	 ********************************************************************************************************
	 *	Update the ODSHashValue Field in the Staging table with the Hash value of the record.				*
	 ********************************************************************************************************
	*/

	UPDATE A
	   SET [ODSHashValue] = CAST(HASHBYTES('MD5', ISNULL(SUBSTRING([Id], 1, 255), '') + '|' + 							CAST(ISNULL(CAST([SinkCreatedOn] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL(CAST([SinkModifiedOn] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL([isprivate], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([timezone], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([issimplifiedaddress_ru], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([sysdatastatecode], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([address], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([apartment_ru], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([building_ru], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([buildingcompliment], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([city], 1, 255), '') + '|' + 							CAST(ISNULL([cityrecid], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([countryregionid], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([county], 1, 255), '') + '|' + 							CAST(ISNULL([district], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([districtname], 1, 255), '') + '|' + 							CAST(ISNULL([flatid_ru], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([houseid_ru], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([latitude], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([location], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([longitude], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([postbox], 1, 255), '') + '|' + 							CAST(ISNULL([privateforparty], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([state], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([street], 1, 255), '') + '|' + 							CAST(ISNULL([streetid_ru], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([streetnumber], 1, 255), '') + '|' + 							CAST(ISNULL(CAST([validfrom] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL(CAST([validto] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							ISNULL(SUBSTRING([zipcode], 1, 255), '') + '|' + 							CAST(ISNULL([zipcoderecid], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([citykana_jp], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([streetkana_jp], 1, 255), '') + '|' + 							CAST(ISNULL([steadid_ru], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([channelreferenceid], 1, 255), '') + '|' + 							CAST(ISNULL([settlementrecid], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([localityrecid], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([openinghours_custom], 1, 255), '') + '|' + 							CAST(ISNULL(CAST([modifieddatetime] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							ISNULL(SUBSTRING([modifiedby], 1, 255), '') + '|' + 							CAST(ISNULL([modifiedtransactionid], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL(CAST([createddatetime] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							ISNULL(SUBSTRING([createdby], 1, 255), '') + '|' + 							CAST(ISNULL([createdtransactionid], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([dataareaid], 1, 255), '') + '|' + 							CAST(ISNULL([recversion], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([partition], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([sysrowversion], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([recid], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([tableid], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL([versionnumber], 0) AS NVARCHAR(50)) + '|' + 							CAST(ISNULL(CAST([createdon] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL(CAST([modifiedon] AS DATETIME2(6)), CAST('1901-01-01' AS DATETIME2(6))) AS NVARCHAR(26)) + '|' + 							CAST(ISNULL([IsDelete], 0) AS NVARCHAR(50)) + '|' + 							ISNULL(SUBSTRING([PartitionId], 1, 255), '') + '|' + 							ISNULL(SUBSTRING([Ingestion_Timestamp], 1, 255), '')) AS BINARY(16))
	  FROM [21D365_stg].[logisticspostaladdress] A; 

							 
	/*
	 ********************************************************************************************************
	 *	If the Destination table has no records update the Staging table Record Source with the value (N)ew.*
	 ********************************************************************************************************
	*/

	IF NOT EXISTS (SELECT count(*) FROM [21D365_ods].[logisticspostaladdress] HAVING count(*) > 0)
	BEGIN
	    UPDATE [21D365_stg].[logisticspostaladdress]
		   SET [ODSRecordStatus] = 'N'
		 WHERE [ODSRecordStatus] IS NULL
	END;

	/*
	 ********************************************************************************************************
	 *	If the Destination table is not empty Update the ODSRecordStatus with values (N), (C) or (S).		*
	 ********************************************************************************************************
	*/

	IF EXISTS (SELECT count(*) FROM [21D365_ods].[logisticspostaladdress] HAVING count(*) > 0)
	BEGIN

		UPDATE A
		   SET A.[ODSRecordStatus] = 'N'
		  FROM [21D365_stg].[logisticspostaladdress] A LEFT JOIN [21D365_ods].[logisticspostaladdress] B
		    ON A.[recid] = B.[recid]
		 WHERE B.[recid] IS NULL

		UPDATE A
		   SET A.[ODSRecordStatus] = 'C'
		  FROM [21D365_stg].[logisticspostaladdress] A INNER JOIN [21D365_ods].[logisticspostaladdress] B
		    ON A.[recid] = B.[recid]
		   AND A.[ODSHashValue] <> B.[ODSHashValue]

		UPDATE A
		   SET A.[ODSRecordStatus] = 'S'
		  FROM [21D365_stg].[logisticspostaladdress] A INNER JOIN [21D365_ods].[logisticspostaladdress] B
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
	  FROM [21D365_ods].[logisticspostaladdress] A INNER JOIN [21D365_stg].[logisticspostaladdress] B
	    ON A.[recid] = B.[recid]
	 WHERE B.[ODSRecordStatus] = 'C'
	   AND A.[ODSEndDate] = CONVERT(DATETIME, '31-12-9999', 103)
	   AND A.[ODSActive] = CONVERT(BIT, 1); 
	
	/*
	 ********************************************************************************************************
	 *	Insert New And Changed records in the ODS Table.													*
	 ********************************************************************************************************
	*/

	INSERT INTO [21D365_ods].[logisticspostaladdress]			(			 [Id],			 [SinkCreatedOn],			 [SinkModifiedOn],			 [isprivate],			 [timezone],			 [issimplifiedaddress_ru],			 [sysdatastatecode],			 [address],			 [apartment_ru],			 [building_ru],			 [buildingcompliment],			 [city],			 [cityrecid],			 [countryregionid],			 [county],			 [district],			 [districtname],			 [flatid_ru],			 [houseid_ru],			 [latitude],			 [location],			 [longitude],			 [postbox],			 [privateforparty],			 [state],			 [street],			 [streetid_ru],			 [streetnumber],			 [validfrom],			 [validto],			 [zipcode],			 [zipcoderecid],			 [citykana_jp],			 [streetkana_jp],			 [steadid_ru],			 [channelreferenceid],			 [settlementrecid],			 [localityrecid],			 [openinghours_custom],			 [modifieddatetime],			 [modifiedby],			 [modifiedtransactionid],			 [createddatetime],			 [createdby],			 [createdtransactionid],			 [dataareaid],			 [recversion],			 [partition],			 [sysrowversion],			 [recid],			 [tableid],			 [versionnumber],			 [createdon],			 [modifiedon],			 [IsDelete],			 [PartitionId],			 [Ingestion_Timestamp],			 [ODSStartDate],			 [ODSEndDate],			 [ODSActive],			 [ODSHashValue]			) 	  SELECT [Id],			 [SinkCreatedOn],			 [SinkModifiedOn],			 [isprivate],			 [timezone],			 [issimplifiedaddress_ru],			 [sysdatastatecode],			 [address],			 [apartment_ru],			 [building_ru],			 [buildingcompliment],			 [city],			 [cityrecid],			 [countryregionid],			 [county],			 [district],			 [districtname],			 [flatid_ru],			 [houseid_ru],			 [latitude],			 [location],			 [longitude],			 [postbox],			 [privateforparty],			 [state],			 [street],			 [streetid_ru],			 [streetnumber],			 [validfrom],			 [validto],			 [zipcode],			 [zipcoderecid],			 [citykana_jp],			 [streetkana_jp],			 [steadid_ru],			 [channelreferenceid],			 [settlementrecid],			 [localityrecid],			 [openinghours_custom],			 [modifieddatetime],			 [modifiedby],			 [modifiedtransactionid],			 [createddatetime],			 [createdby],			 [createdtransactionid],			 [dataareaid],			 [recversion],			 [partition],			 [sysrowversion],			 [recid],			 [tableid],			 [versionnumber],			 [createdon],			 [modifiedon],			 [IsDelete],			 [PartitionId],			 [Ingestion_Timestamp],			 GETUTCDATE(),			 CONVERT(DATETIME, '31-12-9999', 103),			 CONVERT(BIT, 1),			 [ODSHashValue] 		FROM [21D365_stg].[logisticspostaladdress] WHERE [ODSRecordStatus] IN ('C', 'N');					   
				
/*
 ************************************************************************************************************
 *	End of creating the stored procedure.																	*
 ************************************************************************************************************
*/

END

GO

