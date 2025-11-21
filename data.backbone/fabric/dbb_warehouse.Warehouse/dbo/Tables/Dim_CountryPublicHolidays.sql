CREATE TABLE [dbo].[Dim_CountryPublicHolidays] (

	[CountryPublicHoliday_HK] varbinary(16) NOT NULL, 
	[DateKey] date NOT NULL, 
	[Country_HK] varbinary(16) NOT NULL, 
	[Country_BK] varchar(2) NOT NULL, 
	[CountryName] varchar(50) NOT NULL, 
	[HolidayName] varchar(255) NOT NULL, 
	[NormalizeHolidayName] varchar(255) NULL
);


GO
ALTER TABLE [dbo].[Dim_CountryPublicHolidays] ADD CONSTRAINT PK_Dim_CountryPublicHolidays primary key NONCLUSTERED ([CountryPublicHoliday_HK]);