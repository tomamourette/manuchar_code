CREATE TABLE [mim].[rv_sat_sales_order] (

	[bkey_sales_order_source] varchar(8000) NULL, 
	[bkey_source] varchar(8) NOT NULL, 
	[sales_order_sales_id] varchar(8000) NULL, 
	[sales_order_currencycode] varchar(8000) NULL, 
	[sales_order_cust_account] varchar(8000) NULL, 
	[sales_order_sales_amount_accrual] decimal(38,6) NULL, 
	[sales_order_sales_volume_accrual] decimal(38,6) NULL, 
	[sales_order_sales_volume_mt_accrual] decimal(38,6) NULL, 
	[sales_order_sales_accrual_accounting_date] datetime2(6) NULL, 
	[sales_order_company] varchar(8000) NULL, 
	[sales_order_ledger_voucher] varchar(8000) NULL, 
	[sales_order_ledger_account_value] varchar(8000) NULL, 
	[sales_order_ledger_account] varchar(8000) NULL, 
	[sales_order_procen_value] varchar(8000) NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] int NOT NULL
);