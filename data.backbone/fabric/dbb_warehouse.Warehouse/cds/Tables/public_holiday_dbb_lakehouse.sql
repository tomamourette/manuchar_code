CREATE TABLE [cds].[public_holiday_dbb_lakehouse] (

	[tkey_publicholiday_lakehouse] bigint NULL, 
	[date] date NULL, 
	[country_region_code] varchar(8000) NULL, 
	[country_or_region] varchar(8000) NULL, 
	[holiday_name] varchar(8000) NULL, 
	[normalized_holiday_name] varchar(8000) NULL, 
	[is_paid_time_off] bit NULL
);