CREATE TABLE [03DataSys].[Log_DataProcess_Run] (

	[DataProc_Run_Id] int NOT NULL, 
	[DataProc_Id] int NOT NULL, 
	[DataProc_Context] varchar(255) NOT NULL, 
	[DataProc_Run_Status] varchar(50) NOT NULL, 
	[DataProc_Run_DateStart] datetime2(3) NULL, 
	[DataProc_Run_DateEnd] datetime2(3) NULL, 
	[DataProc_Run_DurationSec] int NULL, 
	[Run_NonCompletenessCheckCount] int NULL, 
	[DataProc_Run_Output] varchar(255) NULL, 
	[UpdateDate] datetime2(3) NULL, 
	[UpdateBy] varchar(255) NULL
);