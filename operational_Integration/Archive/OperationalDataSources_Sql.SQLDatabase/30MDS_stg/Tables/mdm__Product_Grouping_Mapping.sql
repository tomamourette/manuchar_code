CREATE TABLE [30MDS_stg].[mdm__Product_Grouping_Mapping] (
    [ID]                         INT            NULL,
    [MUID]                       NVARCHAR (MAX) NULL,
    [Version_Name]               NVARCHAR (MAX) NULL,
    [Version_Number]             INT            NULL,
    [Version_ID]                 INT            NULL,
    [Version_Flag]               NVARCHAR (MAX) NULL,
    [Name]                       NVARCHAR (MAX) NULL,
    [Code]                       NVARCHAR (MAX) NULL,
    [Change_Tracking_Mask]       INT            NULL,
    [Product_Grouping_Code_Code] NVARCHAR (MAX) NULL,
    [Product_Grouping_Code_Name] NVARCHAR (MAX) NULL,
    [Product_Grouping_Code_ID]   INT            NULL,
    [Product_Code_Code]          NVARCHAR (MAX) NULL,
    [Product_Code_Name]          NVARCHAR (MAX) NULL,
    [Product_Code_ID]            INT            NULL,
    [Default_Code]               NVARCHAR (MAX) NULL,
    [Default_Name]               NVARCHAR (MAX) NULL,
    [Default_ID]                 INT            NULL,
    [Customer_Code]              NVARCHAR (MAX) NULL,
    [Customer_Name]              NVARCHAR (MAX) NULL,
    [Customer_ID]                INT            NULL,
    [Enter_DateTime]             DATETIME2 (6)  NULL,
    [Enter_User_Name]            NVARCHAR (MAX) NULL,
    [Enter_Version_Number]       INT            NULL,
    [Last_Change_DateTime]       DATETIME2 (6)  NULL,
    [Last_Change_User_Name]      NVARCHAR (MAX) NULL,
    [Last_Change_Version_Number] INT            NULL,
    [Validation_Status]          NVARCHAR (MAX) NULL,
    [ODSHashValue]               BINARY (16)    NULL,
    [ODSRecordStatus]            NCHAR (1)      NULL
);


GO

CREATE NONCLUSTERED INDEX [IDX_mdm__Product_grouping_Mapping]
    ON [30MDS_stg].[mdm__Product_Grouping_Mapping]([ID] ASC)
    INCLUDE([Enter_DateTime], [Last_Change_DateTime]);


GO

