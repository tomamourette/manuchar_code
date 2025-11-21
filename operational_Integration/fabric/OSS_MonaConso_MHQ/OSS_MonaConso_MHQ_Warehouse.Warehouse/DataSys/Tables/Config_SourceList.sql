CREATE TABLE [DataSys].[Config_SourceList] (

	[Id] int NOT NULL, 
	[Code] varchar(100) NULL, 
	[Schema] varchar(100) NULL, 
	[Table] varchar(100) NULL, 
	[SourceList_Id] int NULL, 
	[Source] varchar(max) NULL, 
	[LoadType] varchar(50) NULL, 
	[Watermark_Column] varchar(100) NULL, 
	[Watermark_Value] datetime2(3) NULL, 
	[UpdateDate] datetime2(3) NULL, 
	[UpdateBy] varchar(50) NULL, 
	[SQLQuery] varchar(max) NULL, 
	[TargetSchema] varchar(50) NULL, 
	[TargetTableName] varchar(50) NULL, 
	[IsActive] bit NULL
);