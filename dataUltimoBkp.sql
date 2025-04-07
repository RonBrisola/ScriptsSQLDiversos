USE BDSCRIPT

SELECT TOP 1 s.database_name,
       s.backup_finish_date,
       DATEDIFF(hour, s.backup_finish_date, getdate()),
       s.backup_start_date,
       s.server_name,
       m.physical_device_name
FROM msdb.dbo.backupset s
INNER JOIN msdb.dbo.backupmediafamily m ON s.media_set_id = m.media_set_id
WHERE s.database_name = DB_NAME() -- Remove this line for all the database
ORDER BY backup_start_date DESC, backup_finish_date
GO

SELECT TOP 1 s.database_name,
       s.backup_finish_date,
       DATEDIFF(hour, s.backup_finish_date, getdate()),
       s.backup_start_date,
       s.server_name,
       m.physical_device_name
FROM msdb.dbo.backupset s
INNER JOIN msdb.dbo.backupmediafamily m ON s.media_set_id = m.media_set_id
WHERE s.database_name = DB_NAME() -- Remove this line for all the database
ORDER BY backup_finish_date DESC 
GO


SELECT * FROM msdb.dbo.backupset

