CREATE TABLE [MonaOnPrem].[V_CALC_LOCALADJUSTED_BUNDLES__ODS] (

	[Type] varchar(1) NULL, 
	[ConsoID] int NULL, 
	[CompanyID] int NULL, 
	[AccountID] int NULL, 
	[Amount] decimal(24,6) NULL, 
	[ODSConsoYear] smallint NULL, 
	[ODSConsoMonth] int NULL, 
	[ODSKey] varchar(92) NULL, 
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