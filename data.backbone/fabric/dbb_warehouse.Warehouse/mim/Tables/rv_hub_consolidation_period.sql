CREATE TABLE [mim].[rv_hub_consolidation_period] (

	[bkey_consolidation_period_source] varchar(8000) NULL, 
	[bkey_consolidation_period] varchar(8000) NULL, 
	[bkey_source] varchar(4) NOT NULL, 
	[ldts] datetime2(6) NULL, 
	[record_source] varchar(25) NULL
);