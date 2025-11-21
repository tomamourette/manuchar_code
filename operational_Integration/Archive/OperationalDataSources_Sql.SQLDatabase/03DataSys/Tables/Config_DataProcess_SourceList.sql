CREATE TABLE [03DataSys].[Config_DataProcess_SourceList] (
    [DataProc_SourceList_Id]             INT           NOT NULL,
    [DataProc_Id]                        INT           NOT NULL,
    [DataProc_Source_Code]               VARCHAR (100) NULL,
    [DataProc_Source_Schema]             VARCHAR (100) NULL,
    [DataProc_Source_Table]              VARCHAR (100) NULL,
    [DataProc_Source_Table_LoadType]     VARCHAR (50)  NULL,
    [DataProc_Source_Watermark_Column]   VARCHAR (100) NULL,
    [DataProc_Source_Watermark_Value]    DATETIME      NULL,
    [UpdateDate]                         DATETIME      NULL,
    [UpdateBy]                           VARCHAR (50)  NULL,
    [DataProc_Source_TableName_SQLQuery] VARCHAR (MAX) NULL,
    [DataProc_Source]                    VARCHAR (MAX) NULL,
    [DataProc_TargetSchema]              VARCHAR (50)  NULL,
    [DataProc_ODS_Schema]                VARCHAR (50)  NULL,
    PRIMARY KEY CLUSTERED ([DataProc_SourceList_Id] ASC)
);


GO

