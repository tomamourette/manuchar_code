CREATE TABLE [cds].[stock_stg_stock] (

	[bkey_stock_source] varchar(8000) NOT NULL, 
	[stock_company] varchar(8000) NULL, 
	[stock_closure_date] datetime2(6) NULL, 
	[stock_entry_date] datetime2(6) NULL, 
	[stock_warehouse_name] varchar(8000) NULL, 
	[stock_lot_number] varchar(8000) NULL, 
	[bkey_product] varchar(8000) NULL, 
	[stock_product_id] varchar(8000) NULL, 
	[stock_product_name] varchar(8000) NULL, 
	[stock_quantity] decimal(18,4) NULL, 
	[stock_uom] varchar(8000) NULL, 
	[stock_amount] decimal(18,4) NULL, 
	[stock_committed] varchar(8000) NULL, 
	[file_name] varchar(8000) NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] int NOT NULL
);