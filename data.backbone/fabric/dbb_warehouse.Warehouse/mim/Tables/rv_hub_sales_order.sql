CREATE TABLE [mim].[rv_hub_sales_order] (

	[bkey_sales_order_source] varchar(8000) NULL, 
	[bkey_sales_order] varchar(8000) NULL, 
	[bkey_source] varchar(8) NOT NULL, 
	[ldts] datetime2(6) NULL, 
	[record_source] varchar(25) NULL
);