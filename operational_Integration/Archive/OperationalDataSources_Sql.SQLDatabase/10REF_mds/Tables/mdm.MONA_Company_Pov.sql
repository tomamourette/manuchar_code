CREATE TABLE [10REF_mds].[mdm.MONA_Company_Pov] (
    [ID]                   INT            NULL,
    [MUID]                 NVARCHAR (MAX) NULL,
    [VersionName]          NVARCHAR (MAX) NULL,
    [VersionNumber]        INT            NULL,
    [Version_ID]           INT            NULL,
    [VersionFlag]          NVARCHAR (MAX) NULL,
    [Name]                 NVARCHAR (MAX) NULL,
    [Code]                 NVARCHAR (MAX) NULL,
    [ChangeTrackingMask]   INT            NULL,
    [Year]                 DECIMAL (38)   NULL,
    [End_Year]             DECIMAL (38)   NULL,
    [PovName]              NVARCHAR (MAX) NULL,
    [Segment]              NVARCHAR (MAX) NULL,
    [PovOrder]             DECIMAL (38)   NULL,
    [SegmentOrder]         DECIMAL (38)   NULL,
    [SubSegment]           NVARCHAR (MAX) NULL,
    [EnterDateTime]        DATETIME2 (6)  NULL,
    [EnterUserName]        NVARCHAR (MAX) NULL,
    [EnterVersionNumber]   INT            NULL,
    [LastChgDateTime]      DATETIME2 (6)  NULL,
    [LastChgUserName]      NVARCHAR (MAX) NULL,
    [LastChgVersionNumber] INT            NULL,
    [ValidationStatus]     NVARCHAR (MAX) NULL
);


GO

