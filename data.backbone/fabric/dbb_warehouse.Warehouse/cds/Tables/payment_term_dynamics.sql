CREATE TABLE [cds].[payment_term_dynamics] (

	[bkey_payment_term_source] varchar(8000) NULL, 
	[bkey_payment_term] varchar(8000) NULL, 
	[bkey_source] varchar(8) NOT NULL, 
	[payment_term_description] varchar(8000) NULL, 
	[payment_term_number_of_days] bigint NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] int NOT NULL
);