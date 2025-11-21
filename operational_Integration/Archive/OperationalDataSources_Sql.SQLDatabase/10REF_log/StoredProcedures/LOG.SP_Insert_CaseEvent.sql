

CREATE PROCEDURE 
	[10REF_log].[LOG.SP_Insert_CaseEvent]

 @company nvarchar(50)
,@domain  nvarchar(50)
,@period  date = NULL
,@event   nvarchar(50)
,@user    nvarchar(512) = NULL
AS
DECLARE @caseID nvarchar(512), @periodSTR nvarchar(50)
SET @periodSTR = ISNULL(CONVERT(CHAR(8),@period,112),'?') 
SET @caseID = UPPER(CONCAT_WS('_', @company,@domain,@periodSTR))

IF NOT EXISTS (SELECT NULL FROM [10REF_log].[LOG.CaseAttributes] WHERE [caseID] = @caseID)
INSERT INTO [10REF_log].[LOG.CaseAttributes]
           ([caseID]
           ,[company]
           ,[domain]
           ,[period])
     SELECT  
		@caseID,
		UPPER(@company), 
		UPPER(@domain), 
		ISNULL(@period,'19000101')

INSERT INTO [10REF_log].[LOG.CaseEvents]
           ([caseID]
           ,[event]
           ,[user]
           ,[timestamp])
     SELECT 
		@caseID,
		@event, 
		@user, 
		GETDATE()

GO

