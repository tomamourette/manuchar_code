CREATE TABLE [mim].[rv_hub_purchase_order_line] (

	[bkey_purchase_order_line_source] varchar(69) NULL, 
	[bkey_purchase_order_line] varchar(60) NULL, 
	[bkey_source] varchar(8) NOT NULL, 
	[ldts] datetime2(6) NULL, 
	[record_source] varchar(25) NULL
);