CREATE TABLE [mim].[rv_hub_sales_invoice] (

	[bkey_sales_invoice_source] varchar(8000) NULL, 
	[bkey_sales_invoice] varchar(8000) NULL, 
	[bkey_source] varchar(9) NOT NULL, 
	[ldts] datetime2(6) NULL, 
	[record_source] varchar(25) NULL
);