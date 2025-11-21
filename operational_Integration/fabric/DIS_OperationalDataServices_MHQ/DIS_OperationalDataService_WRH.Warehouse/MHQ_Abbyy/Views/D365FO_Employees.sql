-- Auto Generated (Do not modify) 47E67753D193FA257BA5FA18AD2E370CFABFBB91871C9B35ED79009A8C62406C

CREATE VIEW [MHQ_Abbyy].[D365FO_Employees] AS 
(
SELECT DISTINCT
	hcmworker.personnelnumber,
	dirpartytable.name,
	logisticselectronicaddress.locator
FROM OSS_Dynamics_MHQ_Lakehouse.dbo.hcmworker
LEFT JOIN OSS_Dynamics_MHQ_Lakehouse.dbo.dirperson ON hcmworker.person = dirperson.recid
LEFT JOIN OSS_Dynamics_MHQ_Lakehouse.dbo.dirpartytable ON dirperson.recid = dirpartytable.recid
LEFT JOIN OSS_Dynamics_MHQ_Lakehouse.dbo.logisticselectronicaddress ON dirpartytable.primarycontactemail = logisticselectronicaddress.recid

LEFT JOIN (
	SELECT 
		position
		,validfrom
		,validto
		,hcmpositionworkerassignment.worker
		,modifieddatetime
		,modifiedby
	FROM OSS_Dynamics_MHQ_Lakehouse.dbo.hcmpositionworkerassignment
	JOIN (
		SELECT 
			worker, 
			MAX(validfrom) as maxpositionvalidfrom
		FROM OSS_Dynamics_MHQ_Lakehouse.dbo.hcmpositionworkerassignment 
		group by worker 
	) as maxworkerassignment ON maxworkerassignment.worker = hcmpositionworkerassignment.worker AND maxworkerassignment.maxpositionvalidfrom = hcmpositionworkerassignment.validfrom
) as maxassignment ON maxassignment.worker = hcmworker.recid


LEFT JOIN (
	SELECT hcmemployment.worker, 
		   hcmemployment.legalentity,
		   modifieddatetime,
		   modifiedby,
		   employmenttype,
		   recid,validfrom,
		   validto  
	FROM OSS_Dynamics_MHQ_Lakehouse.dbo.hcmemployment 
	JOIN (
			SELECT worker,
				   max(validfrom) as maxvalidfrom,
				   max(validto) as maxvalidto
			FROM OSS_Dynamics_MHQ_Lakehouse.dbo.hcmemployment
			group by worker
		 ) as maxemployment ON maxemployment.worker = hcmemployment.worker AND maxemployment.maxvalidfrom = hcmemployment.validfrom
) as maxemployment ON hcmworker.recid = maxemployment.worker 

WHERE ISNULL(maxassignment.validto, maxemployment.validto) > GETDATE()
)