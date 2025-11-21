CREATE PROC [03DataSys].[SP_Update_SourceList_Watermark_Value]
@watermarkValue DATETIME2(3),
@tableName VARCHAR(100)
AS
BEGIN
UPDATE [03DataSys].Config_DataProcess_SourceList
SET UpdateDate = getdate(),
    DataProc_Source_Watermark_Value = @watermarkValue
WHERE DataProc_Source_Table = @tableName
END

GO

