CREATE TABLE [mim].[rv_hub_customer] (

	[bkey_customer_source] varchar(8000) NOT NULL, 
	[bkey_customer] varchar(8000) NOT NULL, 
	[bkey_source] varchar(8) NOT NULL, 
	[ldts] datetime2(6) NULL, 
	[record_source] varchar(25) NULL
);