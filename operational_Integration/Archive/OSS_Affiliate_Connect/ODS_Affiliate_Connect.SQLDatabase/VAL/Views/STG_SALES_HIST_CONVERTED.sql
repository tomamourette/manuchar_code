
CREATE VIEW [VAL].[STG_SALES_HIST_CONVERTED]
AS
SELECT [Company]
      ,[ClosureDate] = convert(date,[ClosureDate],103)
      ,[CustomerID]
      ,[CustomerName]
      ,[BusinessType]
      ,[InvoiceID]
      ,[InvoiceDate] = convert(date,[InvoiceDate],103)
      ,[InvoiceCurrency]
      ,[DestinationCountry]
      ,[ExternalReference]
      ,[LineProductID]
      ,[LineProductName]
      ,[LineQuantity] = convert(decimal(18,2),[LineQuantity])
      ,[LineUOM]
      ,[LineInvoiceCurrencyTotalAmount] = convert(decimal(38,2),[LineInvoiceCurrencyTotalAmount])
      ,[LineHomeCurrencyTotalAmount]	= convert(decimal(38,2),[LineHomeCurrencyTotalAmount])
      ,[LineHomeCurrencyCOGSAmount]		= convert(decimal(38,2),[LineHomeCurrencyCOGSAmount])
      ,[FileName]
      ,[NewFiles]
      ,[Shares]
      ,[LineHomeCurrencyExternalTransportAmount] = convert(decimal(38,2),[LineHomeCurrencyExternalTransportAmount])
      ,[LineHomeCurrencyInternalTransportAmount] = convert(decimal(38,2),[LineHomeCurrencyInternalTransportAmount])
      ,[LineHomeCurrencyOtherCOGS2Amount]		= convert(decimal(38,2),[LineHomeCurrencyOtherCOGS2Amount])
  FROM [VAL].[STG_SALES_HIST]

GO

