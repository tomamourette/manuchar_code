CREATE TABLE [cds].[sales_plan_anaplan_boomi] (

	[Category] varchar(8) NOT NULL, 
	[Plan] varchar(8000) NULL, 
	[Version] int NULL, 
	[Company] varchar(8000) NULL, 
	[ClosureDate] int NULL, 
	[GroupCustomerID] varchar(8000) NULL, 
	[GroupCustomerName] varchar(8000) NULL, 
	[BusinessType] int NULL, 
	[DestinationCountryCode] varchar(8000) NULL, 
	[GroupProductID] varchar(8000) NULL, 
	[GroupProductName] varchar(8000) NULL, 
	[UOM] varchar(2) NOT NULL, 
	[Quantity] float NULL, 
	[GroupCurrencyTotalAmount] float NULL, 
	[GroupCurrencyCOGS1Amount] float NULL, 
	[GroupCurrencyCOGS2Amount] float NULL, 
	[HomeCurrency] int NULL, 
	[PlanRate] float NULL
);