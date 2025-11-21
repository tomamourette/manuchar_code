CREATE TABLE [REF_SHP].[GeoLoc_Country_ODS] (

	[ODSKey] varchar(250) NOT NULL, 
	[ODSVersion] int NOT NULL, 
	[ODSActive] bit NULL, 
	[Country_key] varchar(10) NOT NULL, 
	[Country_alpha2] varchar(10) NULL, 
	[Country_alpha3] varchar(10) NULL, 
	[Country_name] varchar(100) NULL, 
	[GeoSubRegion_key] varchar(100) NULL, 
	[GeoSubRegion_name] varchar(100) NULL, 
	[GeoRegion_key] varchar(10) NULL, 
	[GeoRegion_name] varchar(100) NULL, 
	[Country_CommercialRegion] varchar(100) NULL, 
	[RowModifiedOn] datetime2(6) NULL, 
	[RowModifiedBy] varchar(100) NULL, 
	[ODSHash] varbinary(16) NULL, 
	[ODSDeleted] bit NULL, 
	[ODSStartDate] datetime2(6) NULL, 
	[ODSEndDate] datetime2(6) NULL
);


GO
ALTER TABLE [REF_SHP].[GeoLoc_Country_ODS] ADD CONSTRAINT PK_GeoLoc_Country_ODS primary key NONCLUSTERED ([ODSKey], [ODSVersion]);