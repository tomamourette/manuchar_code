CREATE TABLE [10REF_mds].[stg.Customers_Mapping_Leaf] (
    [ID]                  INT            NULL,
    [ImportType]          SMALLINT       NULL,
    [ImportStatus_ID]     SMALLINT       NULL,
    [Batch_ID]            INT            NULL,
    [BatchTag]            NVARCHAR (MAX) NULL,
    [ErrorCode]           INT            NULL,
    [Code]                NVARCHAR (MAX) NULL,
    [Name]                NVARCHAR (MAX) NULL,
    [NewCode]             NVARCHAR (MAX) NULL,
    [Customer_Golden_Key] NVARCHAR (MAX) NULL,
    [Customer_To_Map]     NVARCHAR (MAX) NULL
);


GO

