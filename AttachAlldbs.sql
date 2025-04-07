-- Build the sp_attach_db: 
-- (I preach everyone against using cursor... so I don't) 
SET NOCOUNT ON  
DECLARE     @cmd        VARCHAR(MAX), 
            @dbname     VARCHAR(200), 
            @prevdbname VARCHAR(200) 

SELECT @cmd = '', @dbname = ';', @prevdbname = '' 
/*
CREATE TABLE tmpAttach 
    (Seq        INT IDENTITY(1,1) PRIMARY KEY, 
     dbname     SYSNAME NULL, 
     fileid     INT NULL, 
     filename   VARCHAR(1000) NULL, 
     TxtAttach  VARCHAR(MAX) NULL 
) 

INSERT INTO tmpAttach 
SELECT DISTINCT DB_NAME(dbid) AS dbname, fileid, filename, CONVERT(VARCHAR(MAX),'') AS TxtAttach 
FROM master.dbo.sysaltfiles 
WHERE dbid IN (SELECT dbid FROM master.dbo.sysaltfiles  
            WHERE 1=1 --SUBSTRING(filename,1,1) IN ('E','F')) 
            AND DATABASEPROPERTYEX( DB_NAME(dbid) , 'Status' ) = 'ONLINE' 
            AND DB_NAME(dbid) NOT IN ('master','tempdb','msdb','model')) 
ORDER BY dbname, fileid, filename 
*/
UPDATE tmpAttach 
SET @cmd = TxtAttach =   
            CASE WHEN dbname <> @prevdbname  
            THEN CONVERT(VARCHAR(200),'exec sp_attach_db @dbname = N''' + dbname + '''') 
            ELSE @cmd 
            END +',@filename' + CONVERT(VARCHAR(10),fileid) + '=N''' + filename +'''', 
    @prevdbname = CASE WHEN dbname <> @prevdbname THEN dbname ELSE @prevdbname END, 
    @dbname = dbname 
FROM tmpAttach  WITH (INDEX(0),TABLOCKX) 
 OPTION (MAXDOP 1) 

SELECT TxtAttach 
FROM 
(SELECT dbname, MAX(TxtAttach) AS TxtAttach FROM tmpAttach  
 where fileold like 'c%'
 GROUP BY dbname) AS x 

--DROP TABLE #Attach 
--GO

select * from tmpAttach
where fileold like 'c%'
order by filename



select * from tmpattach
where dbname like 

alter table tmpattach add FileOLd varchar(1000)

update tmpattach set fileold = filename

update tmpattach set filename = 'e:\bd\2008R2\' + rtrim(substring(dbname, 3, 100)) +


update tmpattach set filename =
'e:\bd\2008R2\' + rtrim(substring(dbname, 3, 100)) +
 reverse(substring(REVERSE(filename), 1, CHARINDEX('\',  REVERSE(filename))))
from tmpAttach
where filename like 'c%'

SELECT SUBSTRING(filename,1,LEN(filename)-(CHARINDEX('\',REVERSE(filename))-1)) from tmpAttach

delete from tmpattach where dbname = 'teste'

