CREATE TABLE [dds_finance].[dim_incoterm] (

	[tkey_incoterm] bigint NULL, 
	[bkey_incoterm] varchar(255) NULL, 
	[incoterm_code] varchar(255) NULL, 
	[incoterm_description] varchar(255) NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] bit NULL
);