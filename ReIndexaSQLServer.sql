EXEC [sp_MSforeachtable] @command1="RAISERROR('DBCC DBREINDEX(''?'') ...',10,1) WITH NOWAIT DBCC DBREINDEX('?')"

EXEC [sp_MSforeachtable] @command1="SELECT COUNT(*) AS '?' FROM ?"


-- desabilita constraints e triggers
sp_msforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT all"
sp_msforeachtable "ALTER TABLE ? DISABLE TRIGGER  all"

-- reabilita constraints e triggers
sp_msforeachtable @command1="ALTER TABLE ? CHECK CONSTRAINT all", @command2="ALTER TABLE ? ENABLE TRIGGER  all"

-- mostra a contagem de registros de cada tabela
SELECT object_name (i.id) TableName, rows as RowCnt
FROM sysindexes i INNER JOIN sysObjects o ON (o.id = i.id AND o.xType = 'U')
WHERE indid < 2
ORDER BY 2 desc



EXEC sp_addlinkedserver   
   @server='SERVERR2', 
   @srvproduct='',
   @provider='SQLNCLI', 
   @datasrc='SQLSERVER\SQL2008R2'

 SELECT * FROM SERVERR2.BDSPARTAN.dbo.TBGENE035
