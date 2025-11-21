CREATE TABLE [mim].[rv_hub_purchase_invoice_line] (

	[bkey_purchase_invoice_line_source] varchar(8000) NULL, 
	[bkey_purchase_invoice_line] varchar(8000) NULL, 
	[bkey_source] varchar(8) NOT NULL, 
	[ldts] datetime2(6) NULL, 
	[record_source] varchar(25) NULL
);