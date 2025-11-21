CREATE TABLE [30MDS_ods].[mdm__Product_Grouping] (
    [ODSRowId]                   BIGINT         IDENTITY (1, 1) NOT NULL,
    [ID]                         INT            NULL,
    [MUID]                       NVARCHAR (MAX) NULL,
    [Version_Name]               NVARCHAR (MAX) NULL,
    [Version_Number]             INT            NULL,
    [Version_ID]                 INT            NULL,
    [Version_Flag]               NVARCHAR (MAX) NULL,
    [Name]                       NVARCHAR (MAX) NULL,
    [Code]                       NVARCHAR (MAX) NULL,
    [Change_Tracking_Mask]       INT            NULL,
    [Product_Business_Unit_Code] NVARCHAR (MAX) NULL,
    [Product_Business_Unit_Name] NVARCHAR (MAX) NULL,
    [Product_Business_Unit_ID]   INT            NULL,
    [Product_Category]           NVARCHAR (MAX) NULL,
    [Product_Sub_Category]       NVARCHAR (MAX) NULL,
    [Sort_Order]                 DECIMAL (38)   NULL,
    [Enter_DateTime]             DATETIME2 (6)  NULL,
    [Enter_User_Name]            NVARCHAR (MAX) NULL,
    [Enter_Version_Number]       INT            NULL,
    [Last_Change_DateTime]       DATETIME2 (6)  NULL,
    [Last_Change_User_Name]      NVARCHAR (MAX) NULL,
    [Last_Change_Version_Number] INT            NULL,
    [Validation_Status]          NVARCHAR (MAX) NULL,
    [ODSRecordStatus]            NVARCHAR (2)   NULL,
    [ODSStartDate]               DATETIME       NOT NULL,
    [ODSEndDate]                 DATETIME       NOT NULL,
    [ODSActive]                  BIT            NOT NULL,
    [ODSHashValue]               BINARY (16)    NOT NULL
);


GO

