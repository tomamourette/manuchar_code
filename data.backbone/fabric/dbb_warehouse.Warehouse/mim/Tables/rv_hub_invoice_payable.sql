CREATE TABLE [mim].[rv_hub_invoice_payable] (

	[bkey_invoice_payable_source] varchar(8000) NULL, 
	[bkey_invoice_payable] varchar(8000) NULL, 
	[bkey_source] varchar(6) NOT NULL, 
	[ldts] datetime2(6) NULL, 
	[record_source] varchar(25) NULL
);