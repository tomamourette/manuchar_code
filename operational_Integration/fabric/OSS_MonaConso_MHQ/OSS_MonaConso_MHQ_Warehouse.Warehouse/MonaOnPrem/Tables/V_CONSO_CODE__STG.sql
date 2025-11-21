CREATE TABLE [MonaOnPrem].[V_CONSO_CODE__STG] (

	[ConsoID] int NULL, 
	[ConsoCode] char(12) NULL, 
	[ConsoName] varchar(8000) NULL, 
	[ODSConsoYear] smallint NULL, 
	[ODSConsoMonth] int NULL, 
	[ODSKey] varchar(30) NULL, 
	[ODSVersion] varchar(8000) NULL, 
	[ODSRecordStatus] varchar(8000) NULL, 
	[ODSActive] varchar(8000) NULL, 
	[ODSDeleted] varchar(8000) NULL, 
	[ODSModifiedOn] varchar(8000) NULL, 
	[ODSModifiedBy] varchar(8000) NULL, 
	[ODSIngestionDate] varchar(8000) NULL, 
	[ODSStartDate] varchar(8000) NULL, 
	[ODSEndDate] varchar(8000) NULL, 
	[ODSHash] varchar(8000) NULL
);