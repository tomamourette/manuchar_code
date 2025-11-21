CREATE TABLE [dds_finance].[dim_vessel] (

	[tkey_vessel] bigint NULL, 
	[bkey_vessel] varchar(255) NULL, 
	[vessel_id] varchar(255) NULL, 
	[vessel_description] varchar(255) NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] bit NULL
);