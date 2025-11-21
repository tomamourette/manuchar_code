CREATE TABLE [dds_finance].[dim_business_unit] (

	[tkey_business_unit] bigint NULL, 
	[bkey_business_unit] varchar(255) NULL, 
	[business_unit_code] varchar(255) NULL, 
	[business_unit_description] varchar(255) NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] bit NULL
);