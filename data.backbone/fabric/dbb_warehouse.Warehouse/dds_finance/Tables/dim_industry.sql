CREATE TABLE [dds_finance].[dim_industry] (

	[tkey_industry] bigint NULL, 
	[bkey_industry] varchar(255) NULL, 
	[industry_code] varchar(255) NULL, 
	[industry_description] varchar(255) NULL, 
	[industry_group] varchar(255) NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] bit NULL
);