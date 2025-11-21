CREATE TABLE [21D365_stg].[ecoresproductcategory] (
    [Id]                    NVARCHAR (MAX)  NULL,
    [SinkCreatedOn]         DATETIME2 (6)   NULL,
    [SinkModifiedOn]        DATETIME2 (6)   NULL,
    [mnrusehscode]          BIGINT          NULL,
    [sysdatastatecode]      BIGINT          NULL,
    [category]              BIGINT          NULL,
    [categoryhierarchy]     BIGINT          NULL,
    [product]               BIGINT          NULL,
    [displayorder]          DECIMAL (38, 6) NULL,
    [modifieddatetime]      DATETIME2 (6)   NULL,
    [modifiedby]            NVARCHAR (MAX)  NULL,
    [modifiedtransactionid] BIGINT          NULL,
    [createddatetime]       DATETIME2 (6)   NULL,
    [createdby]             NVARCHAR (MAX)  NULL,
    [createdtransactionid]  BIGINT          NULL,
    [dataareaid]            NVARCHAR (MAX)  NULL,
    [recversion]            BIGINT          NULL,
    [partition]             BIGINT          NULL,
    [sysrowversion]         BIGINT          NULL,
    [recid]                 BIGINT          NULL,
    [tableid]               BIGINT          NULL,
    [versionnumber]         BIGINT          NULL,
    [createdon]             DATETIME2 (6)   NULL,
    [modifiedon]            DATETIME2 (6)   NULL,
    [IsDelete]              BIT             NULL,
    [PartitionId]           NVARCHAR (2048) NULL,
    [ODSActive]             BIT             NULL,
    [ODSHashValue]          BINARY (16)     NULL,
    [Ingestion_Timestamp]   NVARCHAR (MAX)  NULL,
    [ODSRecordStatus]       NCHAR (1)       NULL
);


GO

