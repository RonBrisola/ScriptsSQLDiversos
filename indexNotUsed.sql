
-- indexes that have been updated and not used
select SCHEMA_NAME(o.schema_id) as [schema_name], 
       OBJECT_NAME(s.object_id) table_name,
       i.name index_name, 
       s.user_seeks, 
       s.user_scans, 
       s.user_lookups,
       s.user_updates,
       'yes' Index_updated_but_not_used
from sys.dm_db_index_usage_stats s
join sys.objects o
on s.object_id = o.object_id
join sys.indexes i
on s.index_id = i.index_id
and s.object_id = i.object_id
where 
(s.user_seeks = 0
  and s.user_scans = 0
  and s.user_lookups = 0) 
and OBJECTPROPERTY(o.object_id,'IsUserTable') = 1
UNION
-- indexes that have not been updated or used 
SELECT
       SCHEMA_NAME(o.schema_id) as [schema_name], 
       OBJECT_NAME(o.object_id) table_name,
       i.name index_name, 
       0  as user_seeks, 
       0 as user_scans, 
       0 as user_lookups,
       0 as user_updates,
       'no' as Index_updated_but_not_used
FROM
sys.indexes i
JOIN
sys.objects o
on i.object_id = o.object_id
  
WHERE
  i.index_id NOT IN (
SELECT s.index_id
FROM sys.dm_db_index_usage_stats s
WHERE s.object_id = i.object_id
AND s.index_id = i.index_id
AND s.database_id =  DB_ID(DB_NAME()))
and OBJECTPROPERTY(o.object_id,'IsUserTable') = 1
order by Index_updated_but_not_used desc;