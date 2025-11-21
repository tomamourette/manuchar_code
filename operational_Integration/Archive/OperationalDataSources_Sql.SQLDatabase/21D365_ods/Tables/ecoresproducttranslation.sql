CREATE TABLE [21D365_ods].[ecoresproducttranslation] (
    [Id]                    NVARCHAR (MAX) NULL,
    [SinkCreatedOn]         DATETIME2 (6)  NULL,
    [SinkModifiedOn]        DATETIME2 (6)  NULL,
    [sysdatastatecode]      BIGINT         NULL,
    [description]           NVARCHAR (MAX) NULL,
    [languageid]            NVARCHAR (MAX) NULL,
    [name]                  NVARCHAR (MAX) NULL,
    [product]               BIGINT         NULL,
    [modifieddatetime]      DATETIME2 (6)  NULL,
    [modifiedby]            NVARCHAR (MAX) NULL,
    [modifiedtransactionid] BIGINT         NULL,
    [createddatetime]       DATETIME2 (6)  NULL,
    [createdby]             NVARCHAR (MAX) NULL,
    [createdtransactionid]  BIGINT         NULL,
    [dataareaid]            NVARCHAR (MAX) NULL,
    [recversion]            BIGINT         NULL,
    [partition]             BIGINT         NULL,
    [sysrowversion]         BIGINT         NULL,
    [recid]                 BIGINT         NULL,
    [tableid]               BIGINT         NULL,
    [versionnumber]         BIGINT         NULL,
    [createdon]             DATETIME2 (6)  NULL,
    [modifiedon]            DATETIME2 (6)  NULL,
    [IsDelete]              BIT            NULL,
    [PartitionId]           NVARCHAR (MAX) NULL,
    [ODSStartDate]          DATETIME       NOT NULL,
    [ODSEndDate]            DATETIME       NOT NULL,
    [ODSActive]             BIT            NOT NULL,
    [ODSHashValue]          BINARY (16)    NOT NULL
);


GO

