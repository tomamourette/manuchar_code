CREATE PROC [MonaOnPrem].[UpSert_V_DATA_CONSO__ODS]

AS
BEGIN

	/*
	 ********************************************************************************************************
	 *	Update the ODSHashValue Field in the Staging table with the Hash value of the record.				*
	 ********************************************************************************************************
	*/

UPDATE TblSTG
SET ODSKey= ISNULL(cast([ConsoID] as varchar(50)),'')+ '|' +  ISNULL(cast([ConsolidatedAmountID]as varchar(50)),'')
,ODSVersion=0
, ODSHash =  CAST(HASHBYTES('MD5',
            ISNULL(cast([ConsoID] as varchar(50)),'')+ '|' + 
			ISNULL(cast([ConsolidatedAmountID] as varchar(50)),'')+ '|' + 
			ISNULL([ConsoCode],'')+ '|' + 
			ISNULL([CompanyCode],'')+ '|' + 
			ISNULL([JournalType],'')+ '|' + 
			ISNULL([JournalCategory],'')+ '|' + 
			ISNULL(cast([JournalEntry] as varchar(50)),'')+ '|' + 
			ISNULL(cast([JournalSequence] as varchar(50)),'')+ '|' + 
            ISNULL([Account],'')+ '|' + 
			ISNULL([PartnerCompanyCode],'')+ '|' + 
			ISNULL([CurrCode],'')+ '|' + 
			ISNULL(cast([Amount] as varchar(50)),'')+ '|' + 
            ISNULL([TransactionCurrCode],'')+ '|' + 
			ISNULL(cast([TransactionAmount] as varchar(50)),'')+ '|' + 
		    ISNULL(cast([CompanyID] as varchar(50)),'')+ '|' + 
            ISNULL(cast([JournalTypeID] as varchar(50)),'')+ '|' + 
            ISNULL(cast([AccountID] as varchar(50)),'')+ '|' + 
            ISNULL(cast([PartnerCompanyID] as varchar(50)),'')+ '|' + 
			ISNULL(cast([CustomerID] as varchar(50)),'')+ '|' + 
            ISNULL([MinorityFlag],'')
       )AS BINARY(16))
FROM [MonaOnPrem].[V_DATA_CONSO__STG] as TblSTG;

							 
	/*
	 ********************************************************************************************************
	 *	If the Destination table has no records update the Staging table Record Source with the value (N)ew.*
	 ********************************************************************************************************
	*/

	IF  EXISTS (SELECT count(*) FROM [MonaOnPrem].[V_DATA_CONSO__STG] HAVING count(*) > 0)
	BEGIN
	    UPDATE [REF_SHP].[GeoLoc_Country_STG]
		   SET [ODSChanged] = 'N' 
		 WHERE [ODSChanged] IS NULL
	END	;

	/*
	 ********************************************************************************************************
	 *	If the Destination table is not empty Update the ODSRecordStatus with values (N), (C) or (S).		*
	 ********************************************************************************************************
	*/

	IF EXISTS (SELECT count(*) FROM [MonaOnPrem].[V_DATA_CONSO__ODS] HAVING count(*) > 0)
	BEGIN
	-- Set 'New' when records doesn't exist in ODS
		UPDATE Stg
		   SET Stg.[ODSChanged] = 'N', ODSVersion = 0
		  FROM [MonaOnPrem].[V_DATA_CONSO__STG] Stg LEFT JOIN [MonaOnPrem].[V_DATA_CONSO__ODS] Ods
		    ON Stg.[ODSKey] = Ods.[ODSKey]
		 WHERE Ods.[ODSKey] IS NULL

-----------------------
	-- Set 'Change' status
	UPDATE Stg
		   SET Stg.[ODSChanged] = 'C'
		  FROM [MonaOnPrem].[V_DATA_CONSO__STG] Stg INNER JOIN [MonaOnPrem].[V_DATA_CONSO__ODS] Ods
		    ON Stg.[ODSKey] = Ods.[ODSKey]
		 WHERE Stg.[ODSHash] <> Ods.[ODSHash]
	-- Update OdsVersion = MaxVersion on OdsKey	 
	UPDATE Stg
		   SET ODSVersion = Ods.ODSVersion
		  FROM [MonaOnPrem].[V_DATA_CONSO__STG] Stg 
				INNER JOIN (SELECT tbl.ODSKey, max(tbl.ODSVersion) ODSVersion 
							from [MonaOnPrem].[V_DATA_CONSO__ODS] tbl GROUP BY tbl.ODSKey) Ods
		    ON Stg.[ODSKey] = Ods.[ODSKey]
		 WHERE Stg.[ODSChanged] = 'C'

----------------
	UPDATE Stg
		   SET Stg.[ODSChanged] = 'S'
		  FROM [MonaOnPrem].[V_DATA_CONSO__STG] Stg INNER JOIN [MonaOnPrem].[V_DATA_CONSO__ODS] Ods
		    ON Stg.[ODSKey] = Ods.[ODSKey]
		 WHERE Stg.[ODSHash] = Ods.[ODSHash]	

	END;				
	/*
	 ********************************************************************************************************
	 *	Update ODS Fields if table Exists.																	*
	 ********************************************************************************************************
	*/
	
	UPDATE Ods
		   SET Ods.[ODSEndDate] = GETUTCDATE(),
		   Ods.[ODSActive] = CONVERT(BIT, 0),
		   Ods.[ODSDeleted] =CONVERT(BIT, 0),
		   Ods.[ODSModifiedOn]= GETUTCDATE(),
		   Ods.[ODSModifiedBy]=SESSION_USER
		  FROM [MonaOnPrem].[V_DATA_CONSO__STG] Stg INNER JOIN [MonaOnPrem].[V_DATA_CONSO__ODS] Ods
		    ON Stg.[ODSKey] = Ods.[ODSKey]
		 WHERE Stg.[ODSChanged] = 'C'
	   AND Ods.[ODSEndDate] = CONVERT(DATETIME, '31-12-9999', 103)
	   AND Ods.[ODSActive] = CONVERT(BIT, 1); 

	   -- Update For DELETED RECORDS
--To DO, StoredProc parametre When FULL/batch load, deletes can't be checked on incremental load
	   ----UPDATE Ods
		  ---- SET Ods.[ODSEndDate] = GETDATE(),
		  ---- Ods.[ODSActive] = CONVERT(BIT, 0),
		  ---- Ods.[ODSDeleted] =CONVERT(BIT, 1)
		  ----FROM [REF_SHP].[GeoLoc_Country_ODS] Ods LEFT JOIN [REF_SHP].[GeoLoc_Country_STG] Stg
		  ----  ON Stg.[ODSKey] = Ods.[ODSKey]
		  ---- WHERE Stg.[ODSKey] is Null	
		  ---- and Ods.[ODSDeleted] is null
			


	/*
	 ********************************************************************************************************
	 *	Insert New And Changed records in the ODS Table.													*
	 ********************************************************************************************************
	*/

INSERT INTO [MonaOnPrem].[V_DATA_CONSO__ODS]
           ([ODSKey]
           ,[ODSVersion]
           ,[ODSActive]
           ,[ConsoID]
           ,[ConsolidatedAmountID]
           ,[ConsoCode]
           ,[CompanyCode]
           ,[JournalType]
           ,[JournalCategory]
           ,[JournalEntry]
           ,[JournalSequence]
           ,[Account]
           ,[PartnerCompanyCode]
           ,[CurrCode]
           ,[Amount]
           ,[TransactionCurrCode]
           ,[TransactionAmount]
           ,[CompanyID]
           ,[JournalTypeID]
           ,[AccountID]
           ,[PartnerCompanyID]
           ,[CustomerID]
           ,[MinorityFlag]
           ,[ODSModifiedOn]
           ,[ODSModifiedBy]
           ,[ODSHash]
         
           ,[ODSStartDate]
           ,[ODSEndDate])

		SELECT 
	   [ODSKey]
      ,[ODSVersion]
	  ,CONVERT(BIT, 1)
	  ,[ConsoID]
      ,[ConsolidatedAmountID]
      ,[ConsoCode]
      ,[CompanyCode]
      ,[JournalType]
      ,[JournalCategory]
      ,[JournalEntry]
      ,[JournalSequence]
      ,[Account]
      ,[PartnerCompanyCode]
      ,[CurrCode]
      ,[Amount]
      ,[TransactionCurrCode]
      ,[TransactionAmount]
      ,[CompanyID]
      ,[JournalTypeID]
      ,[AccountID]
      ,[PartnerCompanyID]
      ,[CustomerID]
      ,[MinorityFlag]
	  , GETUTCDATE()
	  , SESSION_USER 
      ,[ODSHash]
      ,GETUTCDATE()
	  ,CONVERT(DATETIME, '31-12-9999', 103) 
  FROM [MonaOnPrem].[V_DATA_CONSO__STG]
  WHERE [ODSChanged] IN ('C', 'N');	




END