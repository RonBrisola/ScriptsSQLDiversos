

exec msdb.dbo.rds_restore_database 
        @restore_db_name='BDAGIW', 
        @s3_arn_to_restore_from='arn:aws:s3:::awssatis/BDAGIW.BAK';


exec msdb.dbo.rds_backup_database 
        @source_db_name='BDAGIW', 
        @s3_arn_to_backup_to='arn:aws:s3:::awssatis/BDAGIW_5.bak',
        @overwrite_S3_backup_file=0;


/*
sa: saawssatis2017
SISCOMP:sysdaff2017
*/


USE msdb 
GO 
CREATE USER SISCOMP FROM LOGIN SISCOMP 
GO 
GRANT EXECUTE ON msdb.dbo.rds_backup_database TO SISCOMP 
GO 
GRANT EXECUTE ON msdb.dbo.rds_restore_database TO SISCOMP 
GO 
GRANT EXECUTE ON msdb.dbo.rds_task_status TO SISCOMP 
GO 
GRANT EXECUTE ON msdb.dbo.rds_cancel_task TO SISCOMP 
GO 

execute msdb.dbo.rds_task_status


use BDAGIW

CREATE USER [SISCOMP] FOR LOGIN [SISCOMP] WITH DEFAULT_SCHEMA=[dbo]
GO

EXEC sp_addrolemember N'db_owner', N'SISCOMP'
go

--https://www.mssqltips.com/sqlservertip/5042/limitations-of-sql-server-native-backup-and-restore-in-amazon-rds/

18.231.58.44