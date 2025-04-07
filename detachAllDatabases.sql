-- Script to Detach All User Databases
-- Written by Patrick Akhamie
-- 5/28/2011
 
SET NOCOUNT ON
 
DECLARE 
   @dbName     varchar(80),
   @ServerName varchar(20)
 
SELECT @ServerName = @@servername
 
DECLARE dbCursor CURSOR FOR 
   SELECT name 
   FROM master.dbo.sysdatabases 
   WHERE name NOT IN ( 'model', 'master', 'msdb', 'tempdb', 'distribution', 'repldata' )
     and name in (select dbname from tmpAttach where FileOLd like 'c%' and dbname like 'BD%' and dbname <> 'BDEGPISCINAS')
 
OPEN dbCursor 
 
FETCH NEXT FROM dbCursor INTO @dbName
 
IF ( @@FETCH_STATUS <> 0 )
   PRINT 'No User databases found!!!'
   
WHILE ( @@FETCH_STATUS = 0 )
   BEGIN
      DECLARE @SQLStr varchar(8000) 
      SET @SQLStr = 
        'DECLARE 
            @SPIDStr    varchar(8000) = '''' ,
            @ConnKilled smallint = 0
         SELECT @SPIDStr = coalesce( @SPIDStr, '', '' ) + ''KILL '' + convert( varchar, spid ) + ''; ''
         FROM master.dbo.sysprocesses 
         WHERE dbid = db_id( ''' + @dbName + ''' )
         IF LEN( @SPIDStr ) > 0 
            BEGIN
               EXECUTE( @SPIDStr )
               SELECT @ConnKilled = COUNT(1)
               FROM master..sysprocesses 
               WHERE dbid = db_id( ''' + @dbName + ''' )
            END' + char(10) + ';' + char(10) + 
        'EXECUTE sp_detach_db ' + @dbName
      EXECUTE ( @SQLStr )
      --print @SQLStr

      PRINT 'Detach of ' + upper( @dbName ) + ' Database Successfully Completed'
      PRINT ''
      FETCH NEXT FROM dbCursor INTO @dbName
   END
   
CLOSE dbCursor
DEALLOCATE dbCursor
 
PRINT ' '
PRINT upper( @ServerName ) + ' --> All User Databases Successfully Detached'