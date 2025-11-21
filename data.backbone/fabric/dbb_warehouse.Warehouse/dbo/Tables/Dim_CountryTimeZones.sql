CREATE TABLE [dbo].[Dim_CountryTimeZones] (

	[CountryTimeZone_PK] varbinary(16) NOT NULL, 
	[Country_HK] varbinary(16) NOT NULL, 
	[Country_ISO_Code] varchar(2) NOT NULL, 
	[Country_Name] varchar(50) NOT NULL, 
	[TimeZone_Name] varchar(50) NOT NULL, 
	[UTC] varchar(50) NOT NULL, 
	[DaylightSavingTime] varchar(50) NOT NULL, 
	[Zone] varchar(50) NULL, 
	[Offset_In_Minutes] int NOT NULL, 
	[Offset_DaylightSavingTime_In_Minutes] int NOT NULL
);


GO
ALTER TABLE [dbo].[Dim_CountryTimeZones] ADD CONSTRAINT PK_Dim_CountryTimeZones primary key NONCLUSTERED ([CountryTimeZone_PK]);