

CREATE view [03DataSys].[rvw_DataProcess_LastRun]
AS
SELECT
dataProc.[DataProc_Id]		[Process_Id]
, dataProc.[DataProc_Code]	[Process_Code]
, dataProc.[DataProc_Name]	[Process_Name]
, dataProc.[DataProc_Descr]	[Process_Descr]
, dataProc.[Url_Documentation]	[Process_URL]

,tempLastRun.LastRun_Id
, dataProcRun.DataProc_Run_Status
,isnull((dataProcRun.DataProc_Run_DurationSec / 60),0) RunDuration_min
, dataProcRun.[DataProc_Run_DateStart]
, dataProcRun.DataProc_Run_DateEnd
, isnull(dataProcRun.[Run_NonCompletenessCheckCount],0) Run_NonCompletenessCheckCount
,isnull(tempLast7daysErrors.ErrorCountProcRun,0)ErrorCountProcRun
,isnull(tempLastStep7daysErrors.ErrorCountProcRunStep,0)ErrorCountProcRunStep

FROM [03DataSys].[Config_DataProcess] dataProc
LEFT JOIN (select [DataProc_Id],max([DataProc_Run_Id]) LastRun_Id from [03DataSys].[Log_DataProcess_Run]  group by [DataProc_Id]) tempLastRun
ON dataProc.[DataProc_Id] = tempLastRun.[DataProc_Id]
LEFT JOIN [03DataSys].[Log_DataProcess_Run] dataProcRun
On tempLastRun.LastRun_Id = dataProcRun.[DataProc_Run_Id]
LEFT JOIN (
	select [DataProc_Id], count([DataProc_Run_Id]) ErrorCountProcRun from [03DataSys].[Log_DataProcess_Run] dataProcRunError7days 
	where [DataProc_Run_Status] = 'Failed' and [DataProc_Run_DateStart]>= dateadd(d,-7,getdate())
	group by [DataProc_Id] ) tempLast7daysErrors on dataProc.[DataProc_Id] = tempLast7daysErrors.DataProc_Id
LEFT JOIN (
	select [DataProc_Id], count([DataProc_RunStep_Id]) ErrorCountProcRunStep 
	from [03DataSys].[Log_DataProcess_Run] dataProcRunError7days
	Join [03DataSys].[Log_DataProcess_RunStep] dataProcRunStepsError7days 
		on dataProcRunError7days.DataProc_Run_Id = dataProcRunStepsError7days.DataProc_Run_Id
	where [DataProc_RunStep_Status] = 'Failed' and [DataProc_RunStep_DateStart]>= dateadd(d,-7,getdate())
	group by [DataProc_Id]) tempLastStep7daysErrors on dataProc.[DataProc_Id] = tempLastStep7daysErrors.DataProc_Id

GO

