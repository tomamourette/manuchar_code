CREATE TABLE [03DataSys].[Config_DataProcess_SourceList] (

	[DataProc_SourceList_Id] int NOT NULL, 
	[DataProc_Id] int NOT NULL, 
	[DataProc_Source_Code] varchar(100) NULL, 
	[DataProc_Source_Schema] varchar(100) NULL, 
	[DataProc_Source_Table] varchar(100) NULL, 
	[DataProc_Source_Table_LoadType] varchar(50) NULL, 
	[DataProc_Source_TableName_SQLQuery] varchar(max) NULL, 
	[DataProc_Source] varchar(max) NULL, 
	[DataProc_TargetSchema] varchar(50) NULL, 
	[DataProc_Source_Watermark_Column] varchar(100) NULL, 
	[DataProc_Source_Watermark_Value] datetime2(3) NULL, 
	[UpdateDate] datetime2(3) NULL, 
	[UpdateBy] varchar(50) NULL
);