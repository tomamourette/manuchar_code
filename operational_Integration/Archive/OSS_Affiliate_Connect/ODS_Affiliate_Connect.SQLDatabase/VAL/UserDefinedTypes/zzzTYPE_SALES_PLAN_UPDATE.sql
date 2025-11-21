CREATE TYPE [VAL].[zzzTYPE_SALES_PLAN_UPDATE] AS TABLE (
    [Group1]           NVARCHAR (250) NOT NULL,
    [Group2]           NVARCHAR (100) NULL,
    [UOM]              NVARCHAR (250) NULL,
    [Old_Plan_Volume]  FLOAT (53)     NULL,
    [New_Plan_Volume]  FLOAT (53)     NULL,
    [Diff_Plan_Volume] FLOAT (53)     NULL);


GO

