CREATE TABLE [mim].[rv_sat_cost_center] (

	[bkey_cost_center_source] varchar(8000) NULL, 
	[cost_center_code] varchar(8000) NULL, 
	[cost_center_description] varchar(8000) NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] int NOT NULL
);