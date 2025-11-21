CREATE TABLE [dbo].[PaymentTerms_v1] (
    [bk]                     NVARCHAR (50)  NOT NULL,
    [paymenttermcode]        NVARCHAR (50)  NOT NULL,
    [paymenttermdescription] NVARCHAR (255) NULL,
    [numberofdays]           INT            NULL,
    [startdate]              DATE           NOT NULL,
    [enddate]                DATE           DEFAULT ('9999-12-31') NOT NULL,
    [row_hash]               VARBINARY (32) NOT NULL
);


GO

