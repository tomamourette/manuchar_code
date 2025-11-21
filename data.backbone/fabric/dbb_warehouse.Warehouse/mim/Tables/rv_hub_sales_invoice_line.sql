CREATE TABLE [mim].[rv_hub_sales_invoice_line] (

	[bkey_sales_invoice_line_source] varchar(8000) NULL, 
	[bkey_sales_invoice_line] varchar(8000) NULL, 
	[bkey_source] varchar(9) NOT NULL, 
	[ldts] datetime2(6) NULL, 
	[record_source] varchar(25) NULL
);