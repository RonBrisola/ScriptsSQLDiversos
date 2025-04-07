--Detach database
sp_detach_db 'BDHOLLINGSWORTH'



--Attach database com o seu log já existes
CREATE DATABASE BDHOLLINGSWORTH 
    ON (FILENAME = 'E:\SQL2005\HOLLINGSWORTH\BDHOLLINGSWORTH.mdf'),
       (FILENAME = 'E:\SQL2005\HOLLINGSWORTH\BDHOLLINGSWORTH.ldf')
    FOR ATTACH;
GO


--Attach database, sem o log, ele será recriado
EXEC sp_attach_single_file_db @dbname='BDHOLLINGSWORTH',
@physname='E:\SQL2005\HOLLINGSWORTH\BDHOLLINGSWORTH.mdf'
GO


--Attach database, sem o log, se o bando tiver mais de um log
CREATE DATABASE BDHOLLINGSWORTH ON
(FILENAME = 'E:\SQL2005\HOLLINGSWORTH\BDHOLLINGSWORTH.mdf')
FOR ATTACH_REBUILD_LOG
GO



USE AdventureWorks2008R2;
GO
-- Truncate the log by changing the database recovery model to SIMPLE.
ALTER DATABASE AdventureWorks2008R2
SET RECOVERY SIMPLE;
GO
-- Shrink the truncated log file to 1 MB.
DBCC SHRINKFILE (AdventureWorks2008R2_Log, 1);
GO
-- Reset the database recovery model.
ALTER DATABASE AdventureWorks2008R2
SET RECOVERY FULL;
GO