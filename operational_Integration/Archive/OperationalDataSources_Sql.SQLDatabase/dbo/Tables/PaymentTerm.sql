CREATE TABLE [dbo].[PaymentTerm] (
    [id]                     INT            IDENTITY (1, 1) NOT NULL,
    [bk]                     NVARCHAR (50)  NOT NULL,
    [paymenttermcode]        NVARCHAR (50)  NOT NULL,
    [paymenttermdescription] NVARCHAR (255) NULL,
    [numberofdays]           INT            NULL,
    [startdate]              DATE           NOT NULL,
    [enddate]                DATE           DEFAULT ('9999-12-31') NULL,
    [row_hash]               VARBINARY (32) NULL
);


GO

