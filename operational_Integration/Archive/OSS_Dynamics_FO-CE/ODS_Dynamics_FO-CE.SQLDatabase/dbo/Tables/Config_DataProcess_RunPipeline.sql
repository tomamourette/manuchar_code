CREATE TABLE [dbo].[Config_DataProcess_RunPipeline] (
    [DataProcess_RunPipeline_Id]   INT           NULL,
    [DataProc_Id]                  INT           NULL,
    [DataProcess_RunPipeline_Name] VARCHAR (255) NULL,
    [DataProc_RunPipeline_Param1]  VARCHAR (255) NULL,
    [DataProc_RunPipeline_Param2]  VARCHAR (255) NULL,
    [UpdateDate]                   DATETIME      NULL,
    [UpdateBy]                     VARCHAR (255) NULL
);


GO

