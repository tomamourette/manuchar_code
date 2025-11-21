CREATE TABLE [REF_SHP].[GeoLoc_Country_STG] (

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
	[ODSKey] varchar(250) NULL, 
	[ODSVersion] int NULL, 
	[ODSChanged] varchar(3) NULL
);