CREATE TABLE [VAL].[STG_SALES_HIST] (
    [Company]                                 NVARCHAR (255) NULL,
    [ClosureDate]                             NVARCHAR (255) NULL,
    [CustomerID]                              NVARCHAR (255) NULL,
    [CustomerName]                            NVARCHAR (255) NULL,
    [BusinessType]                            NVARCHAR (255) NULL,
    [InvoiceID]                               NVARCHAR (255) NULL,
    [InvoiceDate]                             NVARCHAR (255) NULL,
    [InvoiceCurrency]                         NVARCHAR (255) NULL,
    [DestinationCountry]                      NVARCHAR (255) NULL,
    [ExternalReference]                       NVARCHAR (255) NULL,
    [LineProductID]                           NVARCHAR (255) NULL,
    [LineProductName]                         NVARCHAR (255) NULL,
    [LineQuantity]                            NVARCHAR (255) NULL,
    [LineUOM]                                 NVARCHAR (255) NULL,
    [LineInvoiceCurrencyTotalAmount]          NVARCHAR (255) NULL,
    [LineHomeCurrencyTotalAmount]             NVARCHAR (255) NULL,
    [LineHomeCurrencyCOGSAmount]              NVARCHAR (255) NULL,
    [FileName]                                NVARCHAR (255) NULL,
    [NewFiles]                                CHAR (1)       NULL,
    [Shares]                                  NVARCHAR (255) NULL,
    [LineHomeCurrencyExternalTransportAmount] NVARCHAR (255) NULL,
    [LineHomeCurrencyInternalTransportAmount] NVARCHAR (255) NULL,
    [LineHomeCurrencyOtherCOGS2Amount]        NVARCHAR (255) NULL
);


GO

CREATE NONCLUSTERED INDEX [idx_STG_SALES_HIST_company]
    ON [VAL].[STG_SALES_HIST]([Company] ASC, [InvoiceID] ASC);


GO

