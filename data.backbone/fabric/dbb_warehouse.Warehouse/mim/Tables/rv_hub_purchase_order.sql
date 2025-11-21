CREATE TABLE [mim].[rv_hub_purchase_order] (

	[bkey_purchase_order_source] varchar(8000) NULL, 
	[bkey_purchase_order] varchar(8000) NULL, 
	[bkey_source] varchar(8) NOT NULL, 
	[ldts] datetime2(6) NULL, 
	[record_source] varchar(25) NULL
);