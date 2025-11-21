

SELECT   vconso.Consodate, year(vconso.Consodate), Month(vconso.Consodate),vconso.ConsoYear,vconso.consomonth,  vconso.*
FROM [dbo].[V_CONSO] vconso
where  (  ( vconso.ConsoYear = year(getdate()) and vconso.consomonth = month(getdate())   )
	   OR ( vconso.ConsoYear = year(dateadd(month,-1,getdate())) and vconso.consomonth = month(dateadd(month,-1,getdate()))   )
 	   )



SELECT 
ROW_NUMBER() OVER (PARTITION BY ConsolidatedAmountID, ConsoID, ingestion_timestamp ORDER BY ingestion_timestamp DESC) AS rn
    
FROM [dbo].[V_DATA_CONSO] vconsodata
where   vconso.ConsoYear = year(getdate()) OR  vconso.consomonth = year(dateadd(month,-1,getdate()))  

--------------- INCREMENTAL MINIMAL Current Month & Last Month
SELECT vconsodata.*
FROM [dbo].[V_DATA_CONSO] vconsodata
join [dbo].[V_CONSO] vconso
	on vconsodata.consoid = vconso.consoid
where  (  ( vconso.ConsoYear = year(getdate()) and vconso.consomonth = month(getdate())   )
	   OR ( vconso.ConsoYear = year(dateadd(month,-1,getdate())) and vconso.consomonth = month(dateadd(month,-1,getdate()))   )
 	   )
where  ((vconso.ConsoYear = year(getdate()) and vconso.consomonth = month(getdate())) OR (vconso.ConsoYear = year(dateadd(month,-1,getdate())) and vconso.consomonth = month(dateadd(month,-1,getdate()))))
--------------- INCREMENTAL BACH Current YEAR & Last YEAR
SELECT 
vconsodata.*
FROM [dbo].[V_DATA_CONSO] vconsodata
join [dbo].[V_CONSO] vconso
	on vconsodata.consoid = vconso.consoid
where   vconso.ConsoYear = year(getdate()) OR  vconso.consomonth = year(dateadd(month,-1,getdate()))   
--------------- INCREMENTAL BACH 5 Budget YEARS 
SELECT vconsodata.*
FROM [dbo].[V_DATA_CONSO] vconsodata
join [dbo].[V_CONSO] vconso
	on vconsodata.consoid = vconso.consoid
where   vconso.ConsoYear >= year(getdate()) AND  vconso.consomonth <= year(dateadd(year,5,getdate()))   

