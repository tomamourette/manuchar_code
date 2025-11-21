CREATE TABLE [03DataSys].[Config_DataProcess] (
    [DataProc_Id]       INT           NOT NULL,
    [DataProc_Code]     VARCHAR (50)  NOT NULL,
    [DataProc_Name]     VARCHAR (100) NOT NULL,
    [DataProc_Descr]    TEXT          NULL,
    [Url_Documentation] VARCHAR (255) NULL,
    [UpdateDate]        DATETIME      NULL,
    PRIMARY KEY CLUSTERED ([DataProc_Id] ASC)
);


GO

