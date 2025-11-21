CREATE TABLE [03DataSys].[Log_DataProcess_RunStep] (

	[DataProc_RunStep_Id] int NOT NULL, 
	[DataProc_Run_Id] int NOT NULL, 
	[DataProc_Run_Context] varchar(255) NULL, 
	[DataProc_RunStep_Status] varchar(50) NULL, 
	[DataProc_RunStep_UpdateContext] varchar(255) NULL, 
	[DataProc_RunStep_DateStart] datetime2(3) NULL, 
	[DataProc_RunStep_DateEnd] datetime2(3) NULL, 
	[DataProc_RunStep_DurationSec] int NULL, 
	[DataProc_RunStep_LogLastTransUpdateDate] datetime2(3) NULL, 
	[RunStep_CheckCompleteness_SourceValue] int NULL, 
	[RunStep_CheckCompleteness_ControlValue] int NULL, 
	[RunStep_CheckCompleteness_Diff] int NULL, 
	[DataProc_RunStep_Output] varchar(255) NULL, 
	[UpdateDate] datetime2(3) NULL, 
	[UpdateBy] varchar(255) NULL
);