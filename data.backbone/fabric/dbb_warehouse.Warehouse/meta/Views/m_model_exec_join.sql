-- Auto Generated (Do not modify) 2DD3A56DC5FB24AA81222A6B5DD25EAB77B2F361EBDD0FD16C54059D747DCF7E
create view [meta].[m_model_exec_join]
as
select m_job_name,m_invocation_id,m_model_exec_id,m_model_name, min(m_model_start_end) as start_date, 
case when min(m_model_start_end) = max(m_model_start_end) then NULL else max(m_model_start_end) end as end_date,
min(m_row_count) as count_pre,max(m_row_count) as count_post,
case when min(m_model_start_end) = max(m_model_start_end) then 'failed' else 'success' end as execution_state
from [dbb_warehouse].[meta].[m_model_exec]
group by m_job_name,m_invocation_id,m_model_exec_id,m_model_name