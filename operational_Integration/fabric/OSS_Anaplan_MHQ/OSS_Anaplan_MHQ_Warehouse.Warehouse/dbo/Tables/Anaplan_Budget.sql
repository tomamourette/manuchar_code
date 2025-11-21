CREATE TABLE [dbo].[Anaplan_Budget] (

	[Period] varchar(8000) NULL, 
	[Plan] varchar(8000) NULL, 
	[Version] varchar(8000) NULL, 
	[MonthCode] varchar(8000) NULL, 
	[CompanyCode] varchar(8000) NULL, 
	[FK_Product] varchar(8000) NULL, 
	[FK_ProductGrouping] varchar(8000) NULL, 
	[FK_Customer] varchar(8000) NULL, 
	[DestinationCountryCode] varchar(8000) NULL, 
	[SalesAmountGroupCurrency] varchar(8000) NULL, 
	[QuantityInMetricTon] varchar(8000) NULL, 
	[GrossProfitGroupCurrency] varchar(8000) NULL, 
	[COGSGroupCurrency] varchar(8000) NULL, 
	[COGS2GroupCurrency] varchar(8000) NULL, 
	[<<<Filter>>>] varchar(8000) NULL, 
	[To_Export] varchar(8000) NULL, 
	[<<<Tech>>>] varchar(8000) NULL, 
	[Version_to_export] varchar(8000) NULL
);