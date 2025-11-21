


CREATE PROCEDURE  [10REF_log].[dbo.SP_VALIDATIONRUNDETAILSLOG] @LOGAPPRUNID varchar(50), 
														@FILENAME varchar(50),
														@FILETYPESHORT varchar (50),
														@STATUS varchar (20), 
														@FLAG_FILENAME bit, 
														@FLAG_COLUMNS bit, 
														@FLAG_VALIDATION bit,
														@COMPANY varchar(10)
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @VALRUNID int
	DECLARE @FILETYPE varchar(50)
	
	--GET VALRUNLOGID--	
	SELECT @VALRUNID = ValidationRunLog FROM [10REF_log].[dbo.ValidationRunLog] WHERE LogicAppRunId = @LOGAPPRUNID

	--GET FILETYPE--
	IF @STATUS = 'ERROR'
		SET @FILETYPE = ''
	ELSE
		--SELECT @FILETYPE = T1.Name FROM [10REF_mds].[mdm.[File_Types] T1 WHERE T1.Pattern LIKE '%' + @FILETYPESHORT + '%' 
		SELECT @FILETYPE = T1.Name FROM [10REF_mds].[mdm.File_Types] T1 WHERE @FILETYPESHORT LIKE T1.Pattern 
	
	-- INSERT INTO LOG--
	IF @STATUS = 'RUNNING'
	BEGIN
		INSERT INTO [10REF_log].[dbo.ValidationRunDetailsLog] (ValidationRunLog, FileName, FileType, StartDate, Status, CompanyCode)
		VALUES (@VALRUNID, @FILENAME, @FILETYPE, GETDATE(), @STATUS, @COMPANY)
	END
	ELSE
	BEGIN
		UPDATE [10REF_log].[dbo.ValidationRunDetailsLog] 
		SET Status = @STATUS, FileType = @FILETYPE, EndDate = GETDATE(), Flg_Error_FileName = @FLAG_FILENAME, Flg_Error_Columns = @FLAG_COLUMNS, Flg_Error_Validation = @FLAG_VALIDATION, CompanyCode = @COMPANY
		WHERE ValidationRunLog = @VALRUNID AND FileName = @FILENAME
	END

END

GO

