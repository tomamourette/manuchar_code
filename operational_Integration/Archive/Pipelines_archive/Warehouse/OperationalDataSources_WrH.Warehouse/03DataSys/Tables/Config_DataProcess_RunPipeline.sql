CREATE TABLE [03DataSys].[Config_DataProcess_RunPipeline] (

	[DataProcess_RunPipeline_Id] int NOT NULL, 
	[DataProc_Id] int NULL, 
	[DataProcess_RunPipeline_Name] varchar(255) NULL, 
	[DataProc_RunPipeline_Param1] varchar(255) NULL, 
	[DataProc_RunPipeline_Param2] varchar(255) NULL, 
	[UpdateDate] datetime2(3) NULL, 
	[UpdateBy] varchar(255) NULL
);