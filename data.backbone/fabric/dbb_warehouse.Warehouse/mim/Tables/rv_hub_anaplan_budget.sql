CREATE TABLE [mim].[rv_hub_anaplan_budget] (

	[bkey_budget_transaction_source] varchar(8000) NOT NULL, 
	[bkey_budget_transaction] varchar(8000) NOT NULL, 
	[bkey_source] varchar(5) NOT NULL, 
	[ldts] datetime2(6) NULL, 
	[record_source] varchar(25) NULL
);