SELECT request_session_id AS session_id,
	request_owner_id AS transaction_id,
	DB_NAME(resource_database_id) AS DatabaseName,
	OBJECT_SCHEMA_NAME(resource_associated_entity_id,
			resource_database_id) AS SchemaName,
	OBJECT_NAME(resource_associated_entity_id,
			resource_database_id) AS ObjectName,
	request_mode, request_type, request_status,
	COUNT_BIG(1) AS lock_count
FROM sys.dm_tran_locks
WHERE resource_type = 'OBJECT'
GROUP BY request_session_id, request_owner_id,
	resource_database_id, resource_associated_entity_id,
	request_mode, request_type, request_status