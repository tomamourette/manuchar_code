CREATE TABLE [mim].[rv_hub_payment_term] (

	[bkey_payment_term_source] varchar(8000) NULL, 
	[bkey_payment_term] varchar(8000) NULL, 
	[bkey_source] varchar(8) NOT NULL, 
	[ldts] datetime2(6) NULL, 
	[record_source] varchar(25) NULL
);