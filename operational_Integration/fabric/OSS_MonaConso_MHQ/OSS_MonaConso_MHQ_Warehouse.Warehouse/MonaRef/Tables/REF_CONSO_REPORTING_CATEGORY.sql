CREATE TABLE [MonaRef].[REF_CONSO_REPORTING_CATEGORY] (

	[Conso_CategoryCode] varchar(50) NOT NULL, 
	[Conso_ConsoSequence] int NOT NULL, 
	[Conso_Context] varchar(50) NOT NULL, 
	[Year_Used_start] int NOT NULL, 
	[Year_Used_end] int NOT NULL, 
	[Rpt_Scope] varchar(50) NOT NULL, 
	[Rpt_Category] varchar(50) NOT NULL, 
	[Rpt_Version] varchar(50) NOT NULL, 
	[Rpt_L4L_Scope] varchar(50) NOT NULL, 
	[ODSActive] varchar(20) NULL, 
	[ODSDeleted] varchar(2) NULL, 
	[ODSModifiedOn] datetime2(6) NULL, 
	[ODSModifiedBy] varchar(100) NULL
);


GO
ALTER TABLE [MonaRef].[REF_CONSO_REPORTING_CATEGORY] ADD CONSTRAINT PK_REF_CONSO_REPORTING_CATEGORY primary key NONCLUSTERED ([Conso_CategoryCode], [Conso_ConsoSequence]);