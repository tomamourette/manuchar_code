CREATE TABLE [cds].[sales_plan_stg] (

	[Category] varchar(8000) NULL, 
	[Plan] varchar(8000) NULL, 
	[Version] int NULL, 
	[Company] varchar(8000) NULL, 
	[CLosureDate] datetime2(6) NULL, 
	[GroupCustomerID] varchar(8000) NULL, 
	[GroupCustomerName] varchar(8000) NULL, 
	[BusinessType] varchar(8000) NULL, 
	[DestinationCountry] varchar(8000) NULL, 
	[GroupProductID] varchar(8000) NULL, 
	[GroupProductName] varchar(8000) NULL, 
	[UOM] varchar(8000) NULL, 
	[Quantity] float NULL, 
	[GroupCurrencyTotalAmount] float NULL, 
	[GroupCurrencyCOGS1Amount] float NULL, 
	[GroupCurrencyCOGS2Amount] float NULL, 
	[HomeCurrency] varchar(8000) NULL, 
	[PlanRate] float NULL
);