CREATE TABLE [mim].[rv_hub_journal_mapping] (

	[bkey_journal_mapping_source] varchar(8000) NULL, 
	[bkey_journal_mapping] varchar(8000) NULL, 
	[bkey_source] varchar(13) NOT NULL, 
	[ldts] datetime2(6) NULL, 
	[record_source] varchar(25) NULL
);