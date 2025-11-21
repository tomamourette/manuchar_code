CREATE TABLE [03DataSys].[Config_DataProcess] (

	[DataProc_Id] int NOT NULL, 
	[DataProc_Code] varchar(50) NOT NULL, 
	[DataProc_Name] varchar(100) NOT NULL, 
	[DataProc_Descr] varchar(255) NULL, 
	[Url_Documentation] varchar(255) NULL, 
	[UpdateDate] datetime2(3) NULL
);