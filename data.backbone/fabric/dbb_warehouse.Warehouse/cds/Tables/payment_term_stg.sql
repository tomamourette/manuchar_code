CREATE TABLE [cds].[payment_term_stg] (

	[bkey_payment_term_source] varchar(8000) NULL, 
	[bkey_payment_term] varchar(8000) NULL, 
	[bkey_source] varchar(3) NOT NULL, 
	[payment_term_description] int NULL, 
	[payment_term_number_of_days] int NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] int NOT NULL
);