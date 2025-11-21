CREATE TABLE [MonaOnPrem].[TS096N0__ODS] (

	[CategoryID] int NULL, 
	[CustomerID] int NULL, 
	[CategoryCode] varchar(8000) NULL, 
	[Description] varchar(8000) NULL, 
	[Active] bit NULL, 
	[LinkedCategoryID] int NULL, 
	[LinkedJournalSummationCode] varchar(8000) NULL, 
	[IsStatutory] bit NULL, 
	[ODSKey] varchar(8000) NULL, 
	[ODSVersion] varchar(8000) NULL, 
	[ODSHash] varchar(8000) NULL, 
	[ODSRecordStatus] varchar(8000) NULL, 
	[ODSActive] varchar(8000) NULL, 
	[ODSDeleted] varchar(8000) NULL, 
	[ODSModifiedOn] varchar(8000) NULL, 
	[ODSModifiedBy] varchar(8000) NULL, 
	[ODSIngestionDate] varchar(8000) NULL, 
	[ODSStartDate] varchar(8000) NULL, 
	[ODSEndDate] varchar(8000) NULL
);