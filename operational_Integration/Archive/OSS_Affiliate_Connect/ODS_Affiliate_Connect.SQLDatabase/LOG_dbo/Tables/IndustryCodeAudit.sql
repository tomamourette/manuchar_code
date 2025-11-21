CREATE TABLE [LOG_dbo].[IndustryCodeAudit] (
    [ID]                   INT            NULL,
    [CreateDate]           DATETIME2 (6)  NULL,
    [CompanyCode]          NVARCHAR (MAX) NULL,
    [Legal_Number]         NVARCHAR (MAX) NULL,
    [Type]                 NVARCHAR (MAX) NULL,
    [TypeID]               INT            NULL,
    [IndustryCode]         NVARCHAR (MAX) NULL,
    [CustomerCode]         NVARCHAR (MAX) NULL,
    [CustomerName]         NVARCHAR (MAX) NULL,
    [GKIndustryCode]       NVARCHAR (MAX) NULL,
    [UploadedIndustryCode] NVARCHAR (MAX) NULL,
    [filename]             NVARCHAR (MAX) NULL,
    [ValidConflict]        INT            NULL
);


GO

