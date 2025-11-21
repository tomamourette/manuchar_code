CREATE VIEW [99_Sndb_KT].[vw4Test_GraphQL] AS

SELECT 
DP.DataProc_Code + '_' + CONVERT(VARCHAR(8), LDPR.DataProc_Run_DateStart, 112) as c_MyKey

,DP.DataProc_Id
,DP.DataProc_Code
,DP.DataProc_Name
,DP.DataProc_Descr
,DP.Url_Documentation
,DP.UpdateDate
,LDPR.DataProc_Run_Id
,LDPR.DataProc_Id as LDPR_DataProc_Id
,LDPR.DataProc_Context
,LDPR.DataProc_Run_Status
,LDPR.DataProc_Run_DateStart
,LDPR.DataProc_Run_DateEnd
,LDPR.DataProc_Run_DurationSec
,LDPR.Run_NonCompletenessCheckCount

FROM [03DataSys].Config_DataProcess DP 
    join [03DataSys].Log_DataProcess_Run LDPR
    on DP.DataProc_Id = LDPR.DataProc_Id

GO

